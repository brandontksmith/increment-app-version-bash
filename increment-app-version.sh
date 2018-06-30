#!/bin/bash
# jq is required to parse the version.json file
# https://stedolan.github.io/jq/download/

if ! [ -x "$(command -v jq)" ]; then
  echo "Error: jq could not be found. Is it installed?"
  exit
fi

MAX_TAIL=9

CONFIG_PATH="config/environment.js"
VERSION_PATH="public/version.json"

# read and set the current version
APP_VERSION=$(cat public/version.json | jq ".version")

# remove the quotation marks from the beginning and end
APP_VERSION=$(cut -d '"' -f2 <<< ${APP_VERSION})

LEAD=$(cut -d '.' -f1 <<< ${APP_VERSION})
MID=$(cut -d '.' -f2 <<< ${APP_VERSION})
TAIL=$(cut -d '.' -f3 <<< ${APP_VERSION})

if [ "${TAIL}" -lt "${MAX_TAIL}" ]; then
  TAIL=$((TAIL + 1))
else
  TAIL=0
  MID=$((MID + 1))
fi

NEW_VERSION="$LEAD.$MID.$TAIL"

if [ "$LEAD" -gt 0 ] || [ "$MID" -gt 0 ] || [ "$TAIL" -gt 0 ]; then
  echo "{\"version\": \"$NEW_VERSION\"}" > "$VERSION_PATH"
  sed -i '' "s/$APP_VERSION/$NEW_VERSION/g" "$CONFIG_PATH"

  echo "\nPREVIOUS VERSION: $APP_VERSION"
  echo "NEW VERSION: $NEW_VERSION\n"
fi

