#!/usr/bin/env bash
# shellcheck shell=bash

check_http() {
  local url="$1"
  if command -v curl >/dev/null 2>&1; then
    curl -fsS --max-time "$HTTP_TIMEOUT_SEC" -o /dev/null "$url"
  else
    wget -q --timeout="$HTTP_TIMEOUT_SEC" -O /dev/null "$url"
  fi
}

check_tcp() {
  local hostport="$1" host port
  host="${hostport%%:*}"; port="${hostport##*:}"
  if command -v nc >/dev/null 2>&1; then
    nc -z -w "$HTTP_TIMEOUT_SEC" "$host" "$port"
  else
    timeout "$HTTP_TIMEOUT_SEC" bash -c "echo >/dev/tcp/$host/$port"
  fi
}

check_process() {
  local name="$1"
  pgrep -f "$name" >/dev/null
}

check_disk() {
  local path="$1"
  local used
  used="$(df -P "$path" | awk 'NR==2{gsub(/%/,"",$5); print $5}')"
  [[ -n "$used" ]] || return 1
  [[ "$used" -lt "$DISK_WARN_PERCENT" ]]
}

run_check() {
  local name="$1" type="$2" target="$3"
  case "$type" in
    http) check_http "$target" ;;
    tcp) check_tcp "$target" ;;
    process) check_process "$target" ;;
    disk) check_disk "$target" ;;
    *) die "unknown check type: $type" ;;
  esac
}
