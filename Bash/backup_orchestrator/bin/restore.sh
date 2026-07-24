#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/archive.sh"

TARGET=""; DEST=""; LATEST=0; ARCHIVE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --dest) DEST="$2"; shift 2 ;;
    --latest) LATEST=1; shift ;;
    --archive) ARCHIVE="$2"; shift 2 ;;
    --help|-h) echo "Usage: restore.sh --target <name> --dest <dir> (--latest|--archive <file>)"; exit 0 ;;
    *) die "unknown: $1" ;;
  esac
done
[[ -n "$TARGET" && -n "$DEST" ]] || die "--target and --dest required"
resolve_target "$TARGET"
tdir="$(target_dir)"

if [[ "$LATEST" -eq 1 ]]; then
  ARCHIVE="$(ls -1t "$tdir"/*.tar.gz "$tdir"/*.tar 2>/dev/null | head -n1 || true)"
fi
[[ -n "$ARCHIVE" && -f "$ARCHIVE" ]] || die "archive not found"
mkdir -p "$DEST"
log "restoring $ARCHIVE -> $DEST"
tar -xf "$ARCHIVE" -C "$DEST"
log "restore complete"
