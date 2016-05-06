#!/bin/bash
set -e

version="$1"

if [ -z "$1" ]; then
    echo "No version specified"
    exit 1
fi

tag="v$version"


git add -A
git commit -m "Updating version $version with tag $tag" --allow-empty
git push
# Delete tag if already present
git tag -d "$tag" || true
git push origin ":refs/tags/$tag" || true
git tag "$tag"
git push --tags

