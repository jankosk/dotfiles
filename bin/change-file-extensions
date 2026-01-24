#!/bin/bash

set -e

if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
  echo "Usage: change-file-extensions <path> <ext> <new ext>"
  exit 1
fi

PATH=$1
EXT=$2
NEW_EXT=$3

for file in "$PATH"/*."$EXT"; do
  /bin/mv "$file" "${file%.*}.$NEW_EXT";
done

