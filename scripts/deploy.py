#!/usr/bin/env python3
"""Deploy packaged addon files to the ESO live AddOns folder."""

from __future__ import annotations

import argparse
import os
import shutil
import stat
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

import packaging

REPO_ROOT = packaging.repo_root()
DEFAULT_ADDONS = Path.home() / "Documents/Elder Scrolls Online/live/AddOns"


def _on_rm_error(func, path, _exc_info) -> None:
    os.chmod(path, stat.S_IWRITE)
    func(path)


def _remove_extras(dest: Path, packaged_rels: set[Path]) -> None:
    if not dest.exists():
        return
    for path in sorted(dest.rglob("*"), reverse=True):
        rel = path.relative_to(dest)
        if path.is_file() and rel not in packaged_rels:
            path.unlink(missing_ok=True)
    for path in sorted(dest.rglob("*"), reverse=True):
        if path.is_dir() and not any(path.iterdir()):
            path.rmdir()
    for child in list(dest.iterdir()):
        rel = Path(child.name)
        if child.is_dir() and rel not in {p.parts[0] for p in packaged_rels if p.parts}:
            shutil.rmtree(child, onerror=_on_rm_error)


def deploy(addons_dir: Path, dry_run: bool) -> int:
    dest = addons_dir / packaging.ADDON_NAME
    files = list(packaging.iter_packaged_files(REPO_ROOT))
    packaged_rels = {path.relative_to(REPO_ROOT) for path in files}

    if dry_run:
        print(f"Dry run: would deploy to {dest}")
        for rel in sorted(packaged_rels):
            print(f"  {rel.as_posix()}")
        return 0

    if dest.exists():
        try:
            shutil.rmtree(dest, onerror=_on_rm_error)
        except OSError:
            _remove_extras(dest, packaged_rels)
    dest.mkdir(parents=True, exist_ok=True)

    for path in files:
        rel = path.relative_to(REPO_ROOT)
        target = dest / rel
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, target)

    print(f"Deployed to {dest} ({len(files)} files)")
    for path in files:
        print(f"  {path.relative_to(REPO_ROOT).as_posix()}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Deploy SetContainerCollector to ESO AddOns.")
    parser.add_argument(
        "--addons-dir",
        type=Path,
        default=DEFAULT_ADDONS,
        help=f"AddOns directory (default: {DEFAULT_ADDONS})",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="List files without deleting or copying",
    )
    args = parser.parse_args()
    return deploy(args.addons_dir, args.dry_run)


if __name__ == "__main__":
    sys.exit(main())
