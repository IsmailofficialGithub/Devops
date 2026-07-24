#!/usr/bin/env bash
# shared helpers for log_analyzer
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/config/.env}"

if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  set -a; source "$ENV_FILE"; set +a
fi

TOP_N="${TOP_N:-10}"
ERROR_STATUSES="${ERROR_STATUSES:-500,502,503,504}"
SLOW_MS="${SLOW_MS:-1000}"
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT_DIR/out}"
REPORT_TITLE="${REPORT_TITLE:-Log Analyzer Report}"

log()  { printf '[%s] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"; }
die()  { log "ERROR: $*"; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "missing dependency: $1"; }

ensure_outdir() {
  mkdir -p "$OUTPUT_DIR"
}

usage_analyze() {
  cat <<'EOF'
Usage: analyze.sh --input <file> [--format md|json|html] [--out <path>] [--top N]

Options:
  --input   Access log file (required)
  --format  Report format (default: md)
  --out     Output path (default: stdout / OUTPUT_DIR)
  --top     Top-N for rankings (default from config)
  --help    Show help
EOF
}
