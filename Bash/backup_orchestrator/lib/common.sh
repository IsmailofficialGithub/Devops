#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/config/.env}"
[[ -f "$ENV_FILE" ]] && { set -a; # shellcheck disable=SC1090
source "$ENV_FILE"; set +a; }

BACKUP_ROOT="${BACKUP_ROOT:-$ROOT_DIR/backups}"
TARGETS_FILE="${TARGETS_FILE:-$ROOT_DIR/config/targets.conf}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"
RETENTION_KEEP_MIN="${RETENTION_KEEP_MIN:-3}"
COMPRESS="${COMPRESS:-gzip}"
CHECKSUM="${CHECKSUM:-sha256}"
DRY_RUN="${DRY_RUN:-0}"

log(){ printf '[%s] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"; }
die(){ log "ERROR: $*"; exit 1; }
need(){ command -v "$1" >/dev/null 2>&1 || die "missing: $1"; }

resolve_target() {
  local name="$1" line n src en
  [[ -f "$TARGETS_FILE" ]] || die "targets file missing: $TARGETS_FILE"
  while IFS='|' read -r n src en; do
    [[ "$n" =~ ^#.*$ || -z "$n" ]] && continue
    if [[ "$n" == "$name" ]]; then
      [[ "$en" == "1" ]] || die "target disabled: $name"
      TARGET_NAME="$n"; TARGET_SRC="$src"; return 0
    fi
  done < "$TARGETS_FILE"
  die "unknown target: $name"
}

target_dir() {
  echo "$BACKUP_ROOT/$TARGET_NAME"
}
