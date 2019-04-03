#!/bin/bash

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
	echo "Set the GITHUB_REPOSITORY env variable."
  exit 1
fi

checkValidVersion() {
  current_version=`echo $1 | tr -d \" | sed 's/\.//g'`
  new_version=`echo $2 | tr -d \" | sed 's/\.//g'`

  if [[ new_version -gt current_version ]]; then
    return 1;
  else
    return 0;
  fi
}

URI=https://api.github.com
API_VERSION=v3
API_HEADER="Accept: application/vnd.github.${API_VERSION}+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

echo 'START GET CURRENT VERSION'
body=$(curl -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/${GITHUB_REPOSITORY}/contents/app.json")
APP_JSON_CONTENT=$(echo "${body}" | jq '.content')
CURRENT_VERSION=$(echo ${APP_JSON_CONTENT//\\n/} | tr -d \" | base64 --decode | jq .version | tr -d \")
echo $CURRENT_VERSION
echo 'END GET CURRENT VERSION'

echo 'GET NEW VERSION'

if [ -f "./app.json" ]; then
  NEW_VERSION=$(node /usr/src/app/version.js -f ./app.json)
else
  echo 'Could not found the app.json file!'
  exit 1;
fi

echo $NEW_VERSION
echo 'END GET NEW VERSION'

checkValidVersion $CURRENT_VERSION $NEW_VERSION && echo 'Please make sure the version is bumped' && exit 1

echo 'GET RELEASE NOTE'
if [ -f "./CHANGELOG.md" ]; then
  RELEASE_NOTE="$(node /usr/src/app/release_note.js -f ./CHANGELOG.md -v $NEW_VERSION)"
else
  echo 'Cound not found the CHANGELOG.md file!'
  exit 1;
fi

echo "$RELEASE_NOTE"
echo 'END GET RELEASE NOTE'

if [ -z "$RELEASE_NOTE" ]; then
  echo 'Please add the note content for your changes on the new version'
  exit 1
fi

