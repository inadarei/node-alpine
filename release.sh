#! /usr/bin/env bash

function usage() {
echo "
usage: $0 <version>

  version      Version of Node to release. Must be in semver format with leading 'v', e.g.: 'v4.4.5'

Example usage:
  $0 v6.2.2
"
}

while getopts ":h:" opt; do
  case $opt in
    h)
      usage;
      exit 1;
      ;;
  esac
done

shift "$((OPTIND-1))"

if [ $# -ne 1 ]; then
  usage;
  exit 1;
fi


node_version="$1"
SEMVER_REGEX="^v[0-9]+\.[0-9]+\.[0-9]+$"
if [[ ! $node_version =~ $SEMVER_REGEX ]]; then
  usage;
  exit 1;
fi

curr_date=`date +%Y-%m-%d_%H%M`
echo "Releasing: Node $node_version Refresh: $curr_date ";
