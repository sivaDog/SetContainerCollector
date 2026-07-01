#!/usr/bin/env python3
"""Build an ESOUI/Minion distribution zip for SetContainerCollector."""

from __future__ import annotations

import re
import sys
import zipfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
ADDON_NAME = "SetContainerCollector"
MANIFEST = REPO_ROOT / f"{ADDON_NAME}.txt"

EXCLUDE_DIRS = {".git", "image", "scripts", "docs"}
EXCLUDE_FILES = {".gitignore", "LICENSE", "desktop.ini"}
EXCLUDE_SUFFIXES = {".md", ".zip"}


def read_version() -> str:
    text = MANIFEST.read_text(encoding="utf-8")
    match = re.search(r"^## Version:\s*(.+)$", text, re.MULTILINE)
    if not match:
        raise SystemExit(f"Could not read version from {MANIFEST}")
    return match.group(1).strip()


def should_include(path: Path) -> bool:
    rel = path.relative_to(REPO_ROOT)
    if any(part in EXCLUDE_DIRS for part in rel.parts):
        return False
    if path.name in EXCLUDE_FILES:
        return False
    if path.suffix.lower() in EXCLUDE_SUFFIXES:
        return False
    return True


def make_zip(version: str) -> Path:
    output = REPO_ROOT / f"{ADDON_NAME}-{version}.zip"
    with zipfile.ZipFile(output, "w", zipfile.ZIP_DEFLATED) as zf:
        for path in sorted(REPO_ROOT.rglob("*")):
            if path.is_file() and should_include(path):
                arcname = Path(ADDON_NAME) / path.relative_to(REPO_ROOT)
                zf.write(path, arcname.as_posix())
    return output


def main() -> int:
    version = read_version()
    output = make_zip(version)
    print(f"Created {output} ({output.stat().st_size} bytes)")
    with zipfile.ZipFile(output) as zf:
        for info in sorted(zf.infolist(), key=lambda x: x.filename):
            print(f"  {info.filename}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
