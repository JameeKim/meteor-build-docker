#!/bin/bash
set -e

# 1.9 versions
METEOR_VERSIONS=(1.9.2 1.9.1 1.9.0)
# 1.8 versions
METEOR_VERSIONS=(${METEOR_VERSIONS[@]} 1.8.3 1.8.2 1.8.1 1.8.0.2 1.8.0.1 1.8.0)

DEBIAN_VERSIONS=(stretch buster jessie)
DEBIAN_NUM_VERSIONS=(9 10 8)

if [ ${#DEBIAN_VERSIONS[@]} -ne ${#DEBIAN_NUM_VERSIONS[@]} ]; then
    echo "Debian versions and Debian number versions should have same number of elements" >&2
    exit 1
fi

DOCKER_REPO="jameekim/meteor-builder"
