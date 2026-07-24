#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/config/.env}"
[[ -f "$ENV_FILE" ]] && { set -a; source "$ENV_FILE"; set +a; }
APP_NAME="${APP_NAME:-demo-app}"
ARTIFACT_DIR="${ARTIFACT_DIR:-$ROOT_DIR/dist}"
CURRENT_ENV_DIR="${CURRENT_ENV_DIR:-$ROOT_DIR/environments}"
VERSION_FILE="$ROOT_DIR/VERSION"
CHANGELOG_FILE="$ROOT_DIR/CHANGELOG.md"
log(){ printf '[%s] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"; }
die(){ log "ERROR: $*"; exit 1; }
current_version(){ tr -d '[:space:]' < "$VERSION_FILE"; }
