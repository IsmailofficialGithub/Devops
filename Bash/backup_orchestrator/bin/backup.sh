#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/archive.sh"

TARGET=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --help|-h) echo "Usage: backup.sh --target <name>"; exit 0 ;;
    *) die "unknown: $1" ;;
  esac
done
[[ -n "$TARGET" ]] || die "--target required"
resolve_target "$TARGET"
[[ -d "$TARGET_SRC" ]] || die "source missing: $TARGET_SRC"

dest="$(target_dir)"
mkdir -p "$dest"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
ext="tar.gz"; [[ "$COMPRESS" == "none" ]] && ext="tar"
archive="$dest/${TARGET_NAME}-${stamp}.${ext}"

log "backing up $TARGET_SRC -> $archive"
if [[ "$DRY_RUN" == "1" ]]; then
  log "DRY-RUN skip write"
  exit 0
fi
make_archive "$TARGET_SRC" "$archive"
sum="$(checksum_file "$archive")"
echo "$sum  $(basename "$archive")" > "${archive}.${CHECKSUM}"
log "ok checksum=$sum"
