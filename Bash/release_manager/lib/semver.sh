#!/usr/bin/env bash
# shellcheck shell=bash

bump_semver() {
  local ver="$1" part="$2"
  local major minor patch
  IFS=. read -r major minor patch <<<"$ver"
  case "$part" in
    major) major=$((major+1)); minor=0; patch=0 ;;
    minor) minor=$((minor+1)); patch=0 ;;
    patch) patch=$((patch+1)) ;;
    *) die "part must be major|minor|patch" ;;
  esac
  echo "${major}.${minor}.${patch}"
}
