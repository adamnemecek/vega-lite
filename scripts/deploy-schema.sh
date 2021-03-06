#!/bin/bash

set -e

version=$(scripts/version.sh)

pushd ../schema/vega-lite/

git checkout master
git pull

cp ../../vega-lite/vega-lite-schema.json v$version.json

prefix=$version
while echo "$prefix" | grep -q '\.'; do
    # stip off everything before . or -
    prefix=$(echo $prefix | sed 's/[\.-][^\.-]*$//')
    ln -f -s v$version.json v$prefix.json
    echo "Symlinked v$prefix.json to v$version.json"
done

if [ -n "$(git status --porcelain)" ]; then
    git add *.json
    git commit -m"Add Vega-Lite $version"
    git push
else
  echo "Nothing has changed"
fi

popd
