#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/config/.env}"
[[ -f "$ENV_FILE" ]] && { set -a; source "$ENV_FILE"; set +a; }
CHECKS_FILE="${CHECKS_FILE:-$ROOT_DIR/config/checks.conf}"
ALERT_LOG="${ALERT_LOG:-$ROOT_DIR/out/alerts.log}"
STATE_DIR="${STATE_DIR:-$ROOT_DIR/out/state}"
INTERVAL_SEC="${INTERVAL_SEC:-30}"
RESTART_COOLDOWN_SEC="${RESTART_COOLDOWN_SEC:-120}"
HTTP_TIMEOUT_SEC="${HTTP_TIMEOUT_SEC:-5}"
DISK_WARN_PERCENT="${DISK_WARN_PERCENT:-85}"
log(){ printf '[%s] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"; }
die(){ log "ERROR: $*"; exit 1; }
ensure_dirs(){ mkdir -p "$(dirname "$ALERT_LOG")" "$STATE_DIR"; }
alert(){ ensure_dirs; local m="$*"; log "ALERT $m"; echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) $m" >> "$ALERT_LOG"; }
