#!/usr/bin/env bash
# check_env.sh — assert the exact toolchain. Critical mismatch -> exit 1.
# Run with the env ACTIVE (conda activate ll-repro). macOS/git checked for the record only.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PYCRYPTO_DIR="$HERE/pycrypto"

fail=0
pass(){ printf "  OK    %s\n" "$1"; }
warn(){ printf "  WARN  %s\n" "$1"; }
bad (){ printf "  FAIL  %s\n" "$1"; fail=1; }
expect(){  # <label> <expected> <actual> <crit|warn>
  if   [ "$3" = "$2" ];   then pass "$1 = $3"
  elif [ "$4" = "warn" ]; then warn "$1: got '$3', expected '$2'"
  else                         bad  "$1: got '$3', expected '$2'"; fi
}

echo "== env safeguard =="
prefix="$(python -c 'import sys; print(sys.prefix)' 2>/dev/null)"
case "$prefix" in
  *ll-repro) pass "interpreter in env: $prefix" ;;
  *) warn "python prefix is '$prefix' — did you 'conda activate ll-repro'?" ;;
esac

echo "== environment (checked only, not pinned) =="
expect "macOS" "15.7.3" "$(sw_vers -productVersion 2>/dev/null)" warn
gv="$(git --version 2>/dev/null)"; [ -n "$gv" ] && pass "git: $gv" || warn "git not found"
glfs="$(git lfs version 2>/dev/null)"; [ -n "$glfs" ] && pass "git-lfs: $glfs" || warn "git-lfs not found"
# conda: minimum major 24 required, exact tested 24.11.3
cv="$(conda --version 2>/dev/null | awk '{print $2}')"
cv_major="${cv%%.*}"
if [ "$cv" = "24.11.3" ]; then
  pass "conda = $cv"
elif [ -n "$cv_major" ] && [ "$cv_major" -ge 24 ] 2>/dev/null; then
  warn "conda $cv (>= 24 OK; exact tested 24.11.3)"
else
  bad "conda ${cv:-not found} requires version >= 24 (exact tested 24.11.3)"
fi

echo "== python ecosystem (pinned) =="
expect "python" "3.11.7" "$(python --version 2>&1 | awk '{print $2}')" crit
expect "pip"    "23.3.1" "$(python -m pip --version 2>/dev/null | awk '{print $2}')" crit
zn="$(python -m pip show ZnaKes 2>/dev/null | awk -F': ' '/^Version/{print $2}')"
expect "ZnaKes" "0.1.1" "$zn" crit
ed="$(python -m pip show ed25519 2>/dev/null | awk -F': ' '/^Version/{print $2}')"
expect "ed25519" "1.5" "$ed" crit

# zokrates_pycrypto: it is NOT pip-installed (clone + requirements installs only its DEPS),
# so verify BOTH that the clone is on the pinned commit AND that Python can import it.
PYC="2e0601ef3f4c2472362ef620e7c81fc555d5cf8d"
expect "pycrypto commit" "$PYC" "$(git -C "$PYCRYPTO_DIR" rev-parse HEAD 2>/dev/null)" crit
if python -c "import zokrates_pycrypto" 2>/dev/null; then
  pass "zokrates_pycrypto importable"
else
  bad "zokrates_pycrypto NOT importable — add the clone to PYTHONPATH:"
  echo "        export PYTHONPATH=\"\$PWD/pycrypto:\$PYTHONPATH\""
fi

echo "== native binaries (asserted) =="
# zokrates: custom guidance on failure
zk="$(zokrates --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
if [ "$zk" = "0.8.8" ]; then
  pass "zokrates = 0.8.8"
else
  bad "zokrates ${zk:-not found}, expected 0.8.8"
  echo "        Zokrates must be 0.8.8, please install it manually from source"
  echo "        https://github.com/Zokrates/ZoKrates/releases/tag/0.8.8"
  echo "        then rerun this version assertion script: check_env.sh"
fi

expect "hyperfine" "1.19.0" "$(hyperfine --version 2>/dev/null | awk '{print $2}')" crit

echo
if [ "$fail" -ne 0 ]; then
  echo "ENV CHECK FAILED — do not trust benchmark numbers until resolved."
  exit 1
fi
echo "Yayyy! Environment check passed!"