#!/usr/bin/env bash
# setup.sh — conda(python) + pip toolchain, macOS / Apple Silicon. All pip via env python.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
BIN="$HERE/bin"; mkdir -p "$BIN"
ENV="ll-repro"

# 0. Make sure `conda` is usable in THIS shell
if ! command -v conda >/dev/null 2>&1; then
  for base in "$HOME/miniconda3" "$HOME/anaconda3" "$HOME/miniforge3" \
              "/opt/miniconda3" "/opt/anaconda3" "/opt/homebrew/anaconda3"; do
    if [ -f "$base/etc/profile.d/conda.sh" ]; then
      set +eu; source "$base/etc/profile.d/conda.sh"; set -eu   # hook may reference unset vars / return nonzero
      break
    fi
  done
fi
command -v conda >/dev/null 2>&1 || {
  echo "ERROR: 'conda' not found. Install Miniconda/Anaconda, or run 'conda init zsh' then" >&2
  echo "       restart the terminal (or 'source ~/.zshrc'), and re-run this script." >&2
  exit 1
}

# 1. create/update the conda env (interpreter + pip + ZnaKes from environment.yml)
conda env create -f "$HERE/environment.yml" 2>/dev/null \
  || conda env update -f "$HERE/environment.yml" --prune
conda run -n "$ENV" python -c 'import sys; print("env interpreter:", sys.executable)'

# 2. zokrates_pycrypto pinned by COMMIT (clone + checkout; clone alone = latest branch)
[ -d "$HERE/pycrypto" ] || git clone https://github.com/Zokrates/pycrypto.git "$HERE/pycrypto"
git -C "$HERE/pycrypto" fetch --all
git -C "$HERE/pycrypto" checkout 2e0601ef3f4c2472362ef620e7c81fc555d5cf8d   # the pin
conda run -n "$ENV" python -m pip install -r "$HERE/pycrypto/requirements.txt"   # env's pip (safeguard)

# 3. zokrates 0.8.8 via the official one-liner (0.8.8 is the latest release, so latest == pinned),
#    then RELOCATE it from ~/.zokrates into ./bin so the project is self-contained.
curl -LSfs get.zokrat.es | sh
cp "$HOME/.zokrates/bin/zokrates" "$BIN/zokrates"   # <-- adjust if the installer layout differs
cp -R "$HOME/.zokrates/stdlib"    "$BIN/stdlib"     # zokrates needs its stdlib via ZOKRATES_STDLIB
chmod +x "$BIN/zokrates"
rm -rf "$HOME/.zokrates"                            # drop the global install for clean teardown

# 4. hyperfine 1.19.0 native arm64 binary (commit 12fec42 == tag v1.19.0)
HF_VER="1.19.0"; HF_DIR="hyperfine-v${HF_VER}-aarch64-apple-darwin"
curl -L -o /tmp/hf.tar.gz \
  "https://github.com/sharkdp/hyperfine/releases/download/v${HF_VER}/${HF_DIR}.tar.gz"  # confirm name
tar -xzf /tmp/hf.tar.gz -C /tmp
cp "/tmp/${HF_DIR}/hyperfine" "$BIN/" && chmod +x "$BIN/hyperfine"

# 5. freeze the full pip layer as the source of truth (via env python)
conda run -n "$ENV" python -m pip freeze > "$HERE/requirements.lock.txt"

echo
echo "Activate:        conda activate $ENV"
echo "PATH:            export PATH=\"$BIN:\$PATH\""
echo "ZOKRATES_STDLIB: export ZOKRATES_STDLIB=\"$BIN/stdlib\""
echo "PYTHONPATH:      export PYTHONPATH=\"$HERE/pycrypto:\$PYTHONPATH\""
echo "Then:            bash check_env.sh"