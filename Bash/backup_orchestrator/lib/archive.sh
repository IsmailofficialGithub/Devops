#!/usr/bin/env bash
# shellcheck shell=bash

make_archive() {
  local src="$1" dest_archive="$2"
  need tar
  case "$COMPRESS" in
    gzip) tar -czf "$dest_archive" -C "$(dirname "$src")" "$(basename "$src")" ;;
    none) tar -cf "$dest_archive" -C "$(dirname "$src")" "$(basename "$src")" ;;
    *) die "unsupported COMPRESS=$COMPRESS" ;;
  esac
}

checksum_file() {
  local f="$1"
  case "$CHECKSUM" in
    sha256) sha256sum "$f" | awk '{print $1}' ;;
    md5) md5sum "$f" | awk '{print $1}' ;;
    *) die "unsupported CHECKSUM=$CHECKSUM" ;;
  esac
}
