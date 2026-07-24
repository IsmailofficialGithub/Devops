#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/gitmeta.sh"

mkdir -p "$ARTIFACT_DIR"
ver="$(current_version)"
sha="$(git_sha)"
branch="$(git_branch)"
artifact="$ARTIFACT_DIR/${APP_NAME}-${ver}-${sha}.txt"
{
  echo "app=$APP_NAME"
  echo "version=$ver"
  echo "git_sha=$sha"
  echo "git_branch=$branch"
  echo "built_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
} > "$artifact"
# optional custom build hook
if [[ -n "${BUILD_COMMAND:-}" ]]; then
  log "running BUILD_COMMAND"
  bash -c "$BUILD_COMMAND"
fi
ln -sfn "$(basename "$artifact")" "$ARTIFACT_DIR/latest"
log "built $artifact"
echo "$artifact"
