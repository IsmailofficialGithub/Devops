#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"

INPUT_FILE=""
ONCE=0
PATTERN="${ALERT_PATTERN:-5[0-9][0-9]}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input) INPUT_FILE="$2"; shift 2 ;;
    --pattern) PATTERN="$2"; shift 2 ;;
    --once) ONCE=1; shift ;;
    --help|-h)
      echo "Usage: tail_alerts.sh --input <file> [--pattern REGEX] [--once]"
      exit 0
      ;;
    *) die "unknown arg: $1" ;;
  esac
done

[[ -n "$INPUT_FILE" && -f "$INPUT_FILE" ]] || die "--input file required"

alert_line() {
  local line="$1"
  if echo "$line" | grep -Eq "$PATTERN"; then
    log "ALERT: $line"
  fi
}

if [[ "$ONCE" -eq 1 ]]; then
  while IFS= read -r line; do alert_line "$line"; done < "$INPUT_FILE"
else
  log "following $INPUT_FILE for /$PATTERN/"
  tail -n0 -F "$INPUT_FILE" | while IFS= read -r line; do alert_line "$line"; done
fi
