#!/bin/bash

set -eou pipefail

if [[ -z $1 ]]; then
  echo "Usage: repeat <times> <command>"
  exit 1
fi

REPEATS=$1
shift
CMD=$*

for ((i = 1; i <= REPEATS; i++)); do
  echo "Running $CMD / $REPEATS"
  $CMD;
done

