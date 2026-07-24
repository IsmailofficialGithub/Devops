#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/parsers.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/report.sh"

INPUT_FILE=""
FORMAT="md"
OUT_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input) INPUT_FILE="$2"; shift 2 ;;
    --format) FORMAT="$2"; shift 2 ;;
    --out) OUT_PATH="$2"; shift 2 ;;
    --top) TOP_N="$2"; shift 2 ;;
    --help|-h) usage_analyze; exit 0 ;;
    *) die "unknown arg: $1" ;;
  esac
done

[[ -n "$INPUT_FILE" ]] || { usage_analyze; die "--input is required"; }
[[ -f "$INPUT_FILE" ]] || die "input not found: $INPUT_FILE"
ensure_outdir

TOTAL="$(count_lines "$INPUT_FILE")"
log "analyzing $INPUT_FILE ($TOTAL lines), format=$FORMAT"

case "$FORMAT" in
  md)
    OUT_PATH="${OUT_PATH:-$OUTPUT_DIR/report.md}"
    write_md_report "$OUT_PATH" "$TOTAL"
    ;;
  json)
    OUT_PATH="${OUT_PATH:-$OUTPUT_DIR/report.json}"
    write_json_report "$OUT_PATH" "$TOTAL"
    ;;
  html)
    OUT_PATH="${OUT_PATH:-$OUTPUT_DIR/report.html}"
    write_html_report "$OUT_PATH" "$TOTAL"
    ;;
  *) die "unsupported format: $FORMAT" ;;
esac

log "wrote $OUT_PATH"
