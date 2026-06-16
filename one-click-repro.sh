#!/usr/bin/env bash
# one-click-repro.sh — full reproduction pipeline; aborts on the first failing step.
#
# Usage:  bash one-click-repro.sh [START_STEP]
#   START_STEP (1-8, default 1) = step to resume from. Steps:
#     1 prerequisites   2 clone+setup   3 check_env   4 file checks
#     5/6/7 benchmark depth 10/20/30    8 compare + audit  (the two CLAIM checks)
#   Resuming at >=3 requires the repo + env to already exist; run from lendlocked's PARENT dir.
#   COOLDOWN env var (default 60s) sets the rest before each benchmark, e.g. COOLDOWN=120 bash one-click-repro.sh
set -uo pipefail

START="${1:-1}"
case "$START" in 1|2|3|4|5|6|7|8) ;; *) echo "START_STEP must be 1-8 (got '$START')" >&2; exit 1 ;; esac

REPO_URL="https://github.com/Boyaw/lendlocked.git"
REPO_DIR="lendlocked"
COOLDOWN="${COOLDOWN:-60}"   # seconds to let the machine cool BEFORE each experiment (curbs thermal throttling)

die()      { echo; echo "ABORTED: $*" >&2; exit 1; }
do_step()  { [ "$START" -le "$1" ]; }
banner()   { echo; echo "########################################################################"; \
                   echo "#  $*"; \
                   echo "########################################################################"; }
cooldown() { echo; echo ">>> Cooling down ${COOLDOWN}s before the next experiment ..."; sleep "$COOLDOWN"; }

# STEP 1 — prerequisites
if do_step 1; then
  banner "[1/8] Checking prerequisites"
  if [[ "$(sw_vers -productVersion 2>/dev/null)" == 15.* ]] \
     && command -v git >/dev/null && command -v git-lfs >/dev/null && command -v conda >/dev/null; then
    echo "Prerequisites satisfied"
  else
    die "Missing a prerequisite (macOS Sequoia / git / git-lfs / conda)"
  fi
fi

# STEP 2 — clone (~1.5 GB incl. git-lfs files) + build the toolchain
if do_step 2; then
  banner "[2/8] Cloning repository + building toolchain"
  [ -e "$REPO_DIR" ] && die "'$REPO_DIR' already exists — remove it, or resume at step >= 3"
  git lfs install || die "git lfs install failed"   # idempotent: ensures the clone pulls REAL files, not pointers
  git clone "$REPO_URL" "$REPO_DIR" || die "git clone failed (check network / git-lfs)"
  cd "$REPO_DIR" || die "cannot enter $REPO_DIR"
  git lfs pull || die "git lfs pull failed — large files not materialized (still pointers?)"
  bash setup.sh || die "setup.sh failed"
else
  [ -d "$REPO_DIR" ] || die "cannot resume at step $START: '$REPO_DIR' not found (run from its parent dir)"
  cd "$REPO_DIR" || die "cannot enter $REPO_DIR"
fi
REPO_ROOT="$PWD"

# Always activate the env + set the session vars (needed by every step from 3 on; NOT persisted)
source "$(conda info --base)/etc/profile.d/conda.sh" || die "cannot source conda shell hook"
conda activate ll-repro || die "cannot activate env 'll-repro' (did setup.sh run?)"
export PATH="$REPO_ROOT/bin:$PATH"
export ZOKRATES_STDLIB="$REPO_ROOT/bin/stdlib"        # zokrates reads ZOKRATES_STDLIB for its stdlib
export PYTHONPATH="$REPO_ROOT/pycrypto:$PYTHONPATH"   # zokrates_pycrypto lives inside the cloned pycrypto subdir

# STEP 3 — verify exports, then check_env.sh
if do_step 3; then
  banner "[3/8] Verifying exports + running check_env.sh"
  which zokrates  || die "zokrates not on PATH (expected \$PWD/bin/zokrates)"
  which hyperfine || die "hyperfine not on PATH (expected \$PWD/bin/hyperfine)"
  echo "$ZOKRATES_STDLIB"
  ls "$ZOKRATES_STDLIB" >/dev/null && echo "ZOKRATES_STDLIB OK"       || die "ZOKRATES_STDLIB missing: $ZOKRATES_STDLIB"
  python -c "import zokrates_pycrypto" && echo "zokrates_pycrypto OK" || die "zokrates_pycrypto not importable (PYTHONPATH?)"
  bash check_env.sh || die "check_env.sh failed — environment not reproducible"
fi

# STEP 4 — verify all experiment files exist
if do_step 4; then
  banner "[4/8] Checking experiment files"
  required=( compare-res.py exp-audit.py )
  for d in 10 20 30; do
    required+=(
      "exp-borrow-depth-$d/$d-create-input.py"
      "exp-borrow-depth-$d/$d-loan-proof.zok"
      "exp-borrow-depth-$d/abi.json"
      "exp-borrow-depth-$d/out"
      "exp-borrow-depth-$d/out.r1cs"
    )
  done
  for f in "${required[@]}"; do
    [ -e "$REPO_ROOT/$f" ] || die "missing required file: $f"
  done
  echo "Perfect! All experiment reproduction files exist, ready to reproduce."
fi

# Benchmark one depth: create inputs FIRST, then setup -> witness -> prove -> verify
run_depth() {
  local d="$1"
  banner "Benchmarking Merkle depth $d"
  cd "$REPO_ROOT/exp-borrow-depth-$d" || die "cannot enter exp-borrow-depth-$d"
  python "${d}-create-input.py" || die "depth $d: ${d}-create-input.py failed"   # writes ${d}-proof-inputs.txt
  [ -f "${d}-proof-inputs.txt" ] || die "depth $d: ${d}-proof-inputs.txt was not generated"
  cooldown   # cool after the (CPU-heavy) input generation so 'setup' is also measured on a cool machine
  hyperfine --warmup 3 --runs 5 'zokrates setup'          --export-json "${d}_setup.json"   || die "depth $d: setup failed"
  cooldown
  hyperfine --warmup 3 --runs 5 "zokrates compute-witness -a $(cat ${d}-proof-inputs.txt)" --export-json "${d}_witness.json" || die "depth $d: witness failed"
  cooldown
  hyperfine --warmup 3 --runs 5 'zokrates generate-proof' --export-json "${d}_proof.json"   || die "depth $d: prove failed"
  cooldown
  hyperfine --warmup 3 --runs 5 'zokrates verify'         --export-json "${d}_verify.json"  || die "depth $d: verify failed"
  cd "$REPO_ROOT" || die "cannot return to repo root"
  echo "Depth $d benchmarks complete."
}

# STEPS 5/6/7 — benchmarks (cool down first so thermal throttling doesn't skew the timings)
do_step 5 && { cooldown; run_depth 10; }
do_step 6 && { cooldown; run_depth 20; }
do_step 7 && { cooldown; run_depth 30; }

# STEP 8 — compare + audit, then the TWO CLAIM checks (the focus of the reproduction)
if do_step 8; then
  cooldown
  banner "[8/8] Comparing results + running audit"
  cd "$REPO_ROOT" || die "cannot return to repo root"

  echo
  echo "==================== compare-res.py  (measured timings vs. claimed table) ===================="
  python compare-res.py            # always exits 0; out-of-margin metrics are printed, pipeline continues
  cat <<'EOF'

=========================================================================================
>>> CHECK CLAIM 1   (judge this against the compare-res.py output directly above)
=========================================================================================
The online computation on the e-reader side (witness + prove) for the largest scale of
existing libraries (Merkle depth 30) can finish within 5 seconds. Other cryptographic
computation does not impact user experience, as the e-reader runs setup offline, and the
very efficient verification (a few ms) is done by library who has reasonably more
computational resources.
=========================================================================================
EOF

  echo
  echo "==================== exp-audit.py  (append-only audit) ===================="
  python exp-audit.py || die "exp-audit.py failed"
  cat <<'EOF'

=========================================================================================
>>> CHECK CLAIM 2   (judge this against the exp-audit.py output directly above)
=========================================================================================
An auditor with a laptop can automatically verify the append-only proof monthly within a
few days (e.g., 2-3 days), by recompute the hashes and verify the signatures in each record,
even for the largest existing library.
=========================================================================================
EOF

  banner "All reproduction results are ready"
  echo "Focus your evaluation on the TWO claims above:"
  echo "    Claim 1   <--  supported by the compare-res.py timing output"
  echo "    Claim 2   <--  supported by the exp-audit.py audit output"
  echo
  echo "To clean up the environment and remove everything, run the full teardown:"
  cat <<'EOF'
# Tear down (full cleanup — nothing persists outside these)
conda deactivate
conda env remove -n ll-repro
rm -rf lendlocked             # run from lendlocked's PARENT folder; removes ./bin, the pycrypto clone, the lockfile
rm one-click-repro.sh         # remove the standalone driver you downloaded
EOF
fi