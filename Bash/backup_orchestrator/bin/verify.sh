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
    --help|-h) echo "Usage: verify.sh --target <name>"; exit 0 ;;
    *) die "unknown: $1" ;;
  esac
done
[[ -n "$TARGET" ]] || die "--target required"
resolve_target "$TARGET"
tdir="$(target_dir)"
ok=0; bad=0
shopt -s nullglob
for sumfile in "$tdir"/*."$CHECKSUM"; do
  archive="${sumfile%.$CHECKSUM}"
  [[ -f "$archive" ]] || { log "missing archive for $sumfile"; bad=$((bad+1)); continue; }
  expected="$(awk '{print $1}' "$sumfile")"
  actual="$(checksum_file "$archive")"
  if [[ "$expected" == "$actual" ]]; then
    log "OK $(basename "$archive")"
    ok=$((ok+1))
  else
    log "BAD $(basename "$archive") expected=$expected actual=$actual"
    bad=$((bad+1))
  fi
done
log "verify done ok=$ok bad=$bad"
[[ "$bad" -eq 0 ]]
