"""Shared rules for ESOUI zip packaging and live AddOns deploy."""

from __future__ import annotations

import re
from collections.abc import Iterator
from pathlib import Path

ADDON_NAME = "SetContainerCollector"

EXCLUDE_DIRS = {".git", "image", "scripts", "docs"}
EXCLUDE_FILES = {".gitignore", "LICENSE", "desktop.ini"}
EXCLUDE_SUFFIXES = {".md", ".zip"}


def repo_root() -> Path:
    return Path(__file__).resolve().parent.parent


def manifest_path(repo: Path | None = None) -> Path:
    root = repo or repo_root()
    return root / f"{ADDON_NAME}.txt"


def read_version(repo: Path | None = None) -> str:
    manifest = manifest_path(repo)
    text = manifest.read_text(encoding="utf-8")
    match = re.search(r"^## Version:\s*(.+)$", text, re.MULTILINE)
    if not match:
        raise SystemExit(f"Could not read version from {manifest}")
    return match.group(1).strip()


def should_include(path: Path, repo: Path) -> bool:
    rel = path.relative_to(repo)
    if any(part in EXCLUDE_DIRS for part in rel.parts):
        return False
    if path.name in EXCLUDE_FILES:
        return False
    if path.suffix.lower() in EXCLUDE_SUFFIXES:
        return False
    return True


def iter_packaged_files(repo: Path | None = None) -> Iterator[Path]:
    root = repo or repo_root()
    for path in sorted(root.rglob("*")):
        if path.is_file() and should_include(path, root):
            yield path
