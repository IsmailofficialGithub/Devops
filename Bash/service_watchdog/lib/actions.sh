#!/usr/bin/env bash
# shellcheck shell=bash

maybe_restart() {
  local name="$1" action="$2"
  [[ "$action" == "none" || -z "$action" ]] && return 0
  local stamp_file="$STATE_DIR/${name}.last_restart"
  local now last=0
  now="$(date +%s)"
  [[ -f "$stamp_file" ]] && last="$(cat "$stamp_file")"
  if (( now - last < RESTART_COOLDOWN_SEC )); then
    log "cooldown active for $name; skip action"
    return 0
  fi
  log "running action for $name: $action"
  bash -c "$action"
  echo "$now" > "$stamp_file"
}
