#!/usr/bin/env bash

set -euo pipefail

bump_type="${1:-patch}"
current_tag="$(git describe --tags --abbrev=0 2>/dev/null || true)"
current_version="${current_tag#v}"

if [[ -z "$current_version" ]]; then
  current_version="0.0.0"
fi

if [[ ! "$current_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Latest tag is not a semantic version: $current_tag" >&2
  exit 1
fi

IFS='.' read -r major minor patch <<<"$current_version"

case "$bump_type" in
patch)
  patch=$((patch + 1))
  ;;
minor)
  minor=$((minor + 1))
  patch=0
  ;;
major)
  major=$((major + 1))
  minor=0
  patch=0
  ;;
*)
  echo "Usage: $0 {patch|minor|major}" >&2
  exit 1
  ;;
esac

new_version="$major.$minor.$patch"
new_tag="$new_version"
if [[ -z "$current_tag" || "$current_tag" == v* ]]; then
  new_tag="v$new_version"
fi

printf 'Current version: %s\n' "$current_version"
printf 'New version:     %s\n\n' "$new_version"
printf 'Create and push release? [y/N] '
read -r answer || true

if [[ "$answer" =~ ^[Yy]$ ]]; then
  git tag "$new_tag"
  git push origin "$new_tag"
fi
