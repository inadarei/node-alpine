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
SEMVER_REGEX="^v([0-9]+)\.([0-9]+)\.([0-9])+$"
if [[ ! $node_version =~ $SEMVER_REGEX ]]; then
  usage;
  exit 1;
fi

re='(.*)[0-9]+(.*)'
if [[ $node_version =~ $SEMVER_REGEX ]]; then
  node_full_number="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
  node_major_number="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
fi

curr_date=`date +%Y-%m-%d_%H%M`
echo "Releasing: Node $node_version ($node_full_number/$node_major_number). Refresh: $curr_date ";

sed -i.bak "s/{{NODE_VERSION}}/$node_version/" Dockerfile
sed -i.bak "s/{{DATE_TIME}}/$curr_date/" Dockerfile

# Just node

git commit -m "$node_full_number" Dockerfile
git tag -a $node_full_number -m "$node_full_number"
git tag -d "$node_major_number" && git push origin :refs/tags/$node_major_number && git tag -a node_major_number -m "node_major_number"
git push origin --tags

# Node with runit
sed -i.bak "s/#!RUNIT//g" Dockerfile
 runit_suffix="-runit"
 node_full_number="$node_full_number$runit_suffix"
 node_major_number="$node_major_number$runit_suffix"

git commit -m "$node_full_number" Dockerfile
git tag -a $node_full_number -m "$node_full_number"
git tag -d "$node_major_number" # This may fail if such major ver doesn't yet exist. That's OK
git push origin :refs/tags/$node_major_number && git tag -a node_major_number -m "node_major_number"
git push origin --tags

# Cleanup
mv Dockerfile.bak Dockerfile

echo "Done!"
