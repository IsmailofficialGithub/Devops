#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/formatters.sh"

INPUT=""; FORMAT="md"; OUT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --input) INPUT="$2"; shift 2 ;;
    --format) FORMAT="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    --help|-h) echo "Usage: report.sh --input <json> [--format md] [--out file]"; exit 0 ;;
    *) die "unknown: $1" ;;
  esac
done
[[ -n "$INPUT" && -f "$INPUT" ]] || die "--input required"
ensure_out
case "$FORMAT" in
  md)
    OUT="${OUT:-$OUTPUT_DIR/inventory.md}"
    write_inventory_md "$INPUT" "$OUT"
    ;;
  *) die "unsupported format: $FORMAT" ;;
esac
log "wrote $OUT"
