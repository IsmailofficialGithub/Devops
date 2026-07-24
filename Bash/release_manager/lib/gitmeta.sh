#!/usr/bin/env bash
# shellcheck shell=bash

git_sha() {
  if git -C "$ROOT_DIR" rev-parse --short HEAD >/dev/null 2>&1; then
    git -C "$ROOT_DIR" rev-parse --short HEAD
  else
    echo "nogit"
  fi
}

git_branch() {
  if git -C "$ROOT_DIR" rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
    git -C "$ROOT_DIR" rev-parse --abbrev-ref HEAD
  else
    echo "unknown"
  fi
}
