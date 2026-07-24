#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/collectors.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/formatters.sh"

OUT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --out) OUT="$2"; shift 2 ;;
    --help|-h) echo "Usage: collect.sh --out <file.json>"; exit 0 ;;
    *) die "unknown: $1" ;;
  esac
done
ensure_out
OUT="${OUT:-$OUTPUT_DIR/inventory-$(date -u +%Y%m%dT%H%M%SZ).json}"
write_inventory_json "$OUT"
log "wrote $OUT"
echo "$OUT"
