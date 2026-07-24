#!/usr/bin/env bash
# shellcheck shell=bash

prune_target_dir() {
  local dir="$1" dry="${2:-0}"
  local keep_min="$RETENTION_KEEP_MIN" days="$RETENTION_DAYS"
  [[ -d "$dir" ]] || return 0

  mapfile -t archives < <(ls -1t "$dir"/*.tar.gz "$dir"/*.tar 2>/dev/null || true)
  local count="${#archives[@]}"
  log "found $count archives in $dir (keep_min=$keep_min, retention_days=$days)"

  local i=0
  for a in "${archives[@]}"; do
    i=$((i+1))
    local age_days
    age_days=$(( ( $(date +%s) - $(stat -c %Y "$a" 2>/dev/null || stat -f %m "$a") ) / 86400 ))
    if [[ $i -gt $keep_min && $age_days -gt $days ]]; then
      if [[ "$dry" == "1" ]]; then
        log "DRY-RUN prune: $a (age=${age_days}d)"
      else
        log "pruning $a"
        rm -f "$a" "${a}.${CHECKSUM}"
      fi
    fi
  done
}
