#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/config/.env}"
[[ -f "$ENV_FILE" ]] && { set -a; source "$ENV_FILE"; set +a; }
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT_DIR/out}"
INCLUDE_PACKAGES="${INCLUDE_PACKAGES:-1}"
INCLUDE_PORTS="${INCLUDE_PORTS:-1}"
INCLUDE_DOCKER="${INCLUDE_DOCKER:-1}"
log(){ printf '[%s] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"; }
die(){ log "ERROR: $*"; exit 1; }
ensure_out(){ mkdir -p "$OUTPUT_DIR"; }
