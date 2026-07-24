#!/usr/bin/env bash
# parsers: expect combined/nginx-ish: IP - - [date] "METHOD PATH PROTO" STATUS BYTES "REF" "UA" [optional time]
# shellcheck shell=bash

parse_status_counts() {
  local file="$1"
  awk '{
    for (i=1;i<=NF;i++) if ($i ~ /^[1-5][0-9][0-9]$/) { print $i; break }
  }' "$file" | sort | uniq -c | sort -nr
}

parse_top_ips() {
  local file="$1" n="${2:-10}"
  awk '{print $1}' "$file" | sort | uniq -c | sort -nr | head -n "$n"
}

parse_top_paths() {
  local file="$1" n="${2:-10}"
  awk -F\" '{print $2}' "$file" | awk '{print $2}' | sort | uniq -c | sort -nr | head -n "$n"
}

parse_error_lines() {
  local file="$1"
  local statuses="${ERROR_STATUSES//,/|}"
  awk -v re="$statuses" '{
    for (i=1;i<=NF;i++) if ($i ~ "^(" re ")$") { print; break }
  }' "$file"
}

parse_methods() {
  local file="$1"
  awk -F\" '{print $2}' "$file" | awk '{print $1}' | sort | uniq -c | sort -nr
}

count_lines() {
  wc -l < "$1" | tr -d ' '
}
