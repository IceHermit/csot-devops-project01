#!/usr/bin/env bash
set -euo pipefail

usage() { echo "Usage: $0 <source-dir> <dest-dir>"; exit 1; }
[[ $# -ne 2 ]] && usage

src="$1"
dest="$2"
[[ ! -d "$src" ]] && { echo "Source dir not found: $src" >&2; exit 1; }
mkdir -p "$dest"

ts=$(date +%Y%m%d-%H%M%S)
out="$dest/$(basename "$src")-$ts.tar.gz"

tar czf "$out" -C "$(dirname "$src")" "$(basename "$src")"
size=$(du -h "$out" | cut -f1)

echo "[$ts] backed up $src → $out ($size)" | tee -a "$dest/backup.log"