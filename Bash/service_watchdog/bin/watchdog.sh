#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"

LOOPS=0
INTERVAL="$INTERVAL_SEC"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --loops) LOOPS="$2"; shift 2 ;;
    --interval) INTERVAL="$2"; shift 2 ;;
    --help|-h) echo "Usage: watchdog.sh [--loops N] [--interval SEC]"; exit 0 ;;
    *) die "unknown: $1" ;;
  esac
done

i=0
while true; do
  i=$((i+1))
  log "watchdog loop $i"
  "$ROOT_DIR/bin/check_once.sh" || true
  [[ "$LOOPS" -gt 0 && "$i" -ge "$LOOPS" ]] && break
  sleep "$INTERVAL"
done
