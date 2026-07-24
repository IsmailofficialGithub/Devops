#!/usr/bin/env bash
# shellcheck shell=bash

collect_os() {
  if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    echo "${NAME:-unknown}|${VERSION_ID:-unknown}|${ID:-unknown}"
  elif command -v sw_vers >/dev/null 2>&1; then
    echo "macOS|$(sw_vers -productVersion)|macos"
  else
    echo "unknown|unknown|unknown"
  fi
}

collect_cpu() {
  if [[ -f /proc/cpuinfo ]]; then
    grep -c ^processor /proc/cpuinfo
  elif command -v sysctl >/dev/null 2>&1; then
    sysctl -n hw.ncpu
  else
    echo 1
  fi
}

collect_mem_mb() {
  if [[ -f /proc/meminfo ]]; then
    awk '/MemTotal/{printf "%d", $2/1024}' /proc/meminfo
  elif command -v sysctl >/dev/null 2>&1; then
    awk 'BEGIN{} {print int($0/1024/1024)}' <<<"$(sysctl -n hw.memsize)"
  else
    echo 0
  fi
}

collect_disks() {
  df -P -k 2>/dev/null | awk 'NR>1{printf "%s %sKB %s\n",$6,$2,$5}'
}

collect_ips() {
  if command -v ip >/dev/null 2>&1; then
    ip -4 -o addr show | awk '{print $2,$4}'
  elif command -v ifconfig >/dev/null 2>&1; then
    ifconfig | awk '/inet /{print $2}'
  else
    hostname -I 2>/dev/null || true
  fi
}

collect_ports() {
  [[ "$INCLUDE_PORTS" == "1" ]] || return 0
  if command -v ss >/dev/null 2>&1; then
    ss -tulpn 2>/dev/null | awk 'NR>1{print $1,$5}'
  elif command -v netstat >/dev/null 2>&1; then
    netstat -tulpn 2>/dev/null | awk 'NR>2{print $1,$4}'
  fi
}

collect_packages_sample() {
  [[ "$INCLUDE_PACKAGES" == "1" ]] || return 0
  if command -v dpkg >/dev/null 2>&1; then
    dpkg-query -W -f='${Package}\n' 2>/dev/null | head -n 50
  elif command -v rpm >/dev/null 2>&1; then
    rpm -qa 2>/dev/null | head -n 50
  elif command -v brew >/dev/null 2>&1; then
    brew list 2>/dev/null | head -n 50
  fi
}

collect_docker() {
  [[ "$INCLUDE_DOCKER" == "1" ]] || return 0
  if command -v docker >/dev/null 2>&1; then
    docker ps --format '{{.Names}} {{.Image}} {{.Status}}' 2>/dev/null || true
  fi
}
