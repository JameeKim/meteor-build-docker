#!/bin/bash
set -e

if ! type "for_each_ver" | grep -q "function$" 2>/dev/null; then
    echo "function \"for_each_ver\" should be defined" 1>&2
    exit 1
fi

source ./vars.sh

for METEOR in "${METEOR_VERSIONS[@]}"; do
    echo "Meteor version ${METEOR}"

    local i=0
    local length=${#DEBIAN_VERSIONS[@]}

    while [ $i -lt $length ]; do
        for_each_ver $METEOR ${DEBIAN_VERSIONS[$i]} ${DEBIAN_NUM_VERSIONS[$i]}

        i=`expr $i + 1`
    done
done
