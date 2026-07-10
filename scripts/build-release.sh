#!/usr/bin/env bash
set -euo pipefail

# Build the Super Productivity plugin ZIP using the same mechanism that was
# manually verified in this repo: Python 3's standard-library zipfile module
# with ZIP_DEFLATED compression over the four plugin root files.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="${1:-}"
OS_NAME="${2:-linux}"
ARCH_NAME="${3:-x64}"
OUT_DIR="${4:-${ROOT_DIR}/dist/release}"
GITHUB_REPOSITORY_VALUE="${GITHUB_REPOSITORY:-}"
REPO_NAME="${GITHUB_REPOSITORY_VALUE##*/}"
REPO_NAME="${REPO_NAME:-$(basename "${ROOT_DIR}")}"

if [[ -z "${VERSION}" ]]; then
  VERSION="$(python3 - <<'PY'
import json
from pathlib import Path
print('v' + json.loads(Path('manifest.json').read_text(encoding='utf-8'))['version'].lstrip('v'))
PY
)"
fi

if [[ "${VERSION}" != v* ]]; then
  VERSION="v${VERSION}"
fi

ZIP_NAME="${REPO_NAME}-${VERSION}-${OS_NAME}-${ARCH_NAME}.zip"
ZIP_PATH="${OUT_DIR}/${ZIP_NAME}"

cd "${ROOT_DIR}"
mkdir -p "${OUT_DIR}"
rm -f "${ZIP_PATH}"

python3 - "${ZIP_PATH}" <<'PY'
import sys
import zipfile
from pathlib import Path

zip_path = Path(sys.argv[1])
files = ['manifest.json', 'plugin.js', 'index.html', 'icon.svg']
missing = [f for f in files if not Path(f).is_file()]
if missing:
    raise SystemExit(f"Missing required plugin files: {', '.join(missing)}")

with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zf:
    for f in files:
        zf.write(f, f)
        print(f'  added: {f}')
print(zip_path)
PY

python3 - "${ZIP_PATH}" <<'PY'
import sys
import zipfile
from pathlib import Path

zip_path = Path(sys.argv[1])
required = {'manifest.json', 'plugin.js', 'index.html', 'icon.svg'}
if not zip_path.is_file():
    raise SystemExit(f"ZIP was not created: {zip_path}")
with zipfile.ZipFile(zip_path) as zf:
    bad = zf.testzip()
    if bad:
        raise SystemExit(f"ZIP integrity check failed at: {bad}")
    names = set(zf.namelist())
missing = required - names
if missing:
    raise SystemExit(f"ZIP missing required files: {', '.join(sorted(missing))}")
print(f"Verified {zip_path}")
PY
