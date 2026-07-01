#!/usr/bin/env python3
"""Build an ESOUI/Minion distribution zip for SetContainerCollector."""

from __future__ import annotations

import sys
import zipfile
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

import packaging

REPO_ROOT = packaging.repo_root()


def make_zip(version: str) -> Path:
    output = REPO_ROOT / f"{packaging.ADDON_NAME}-{version}.zip"
    with zipfile.ZipFile(output, "w", zipfile.ZIP_DEFLATED) as zf:
        for path in packaging.iter_packaged_files(REPO_ROOT):
            arcname = Path(packaging.ADDON_NAME) / path.relative_to(REPO_ROOT)
            zf.write(path, arcname.as_posix())
    return output


def main() -> int:
    version = packaging.read_version(REPO_ROOT)
    output = make_zip(version)
    print(f"Created {output} ({output.stat().st_size} bytes)")
    with zipfile.ZipFile(output) as zf:
        for info in sorted(zf.infolist(), key=lambda x: x.filename):
            print(f"  {info.filename}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
