#!/bin/bash
set -e

PREV_VER=""
PREV_MAIN=""
PREV_SUBMAIN=""
NEW_MAIN=1
NEW_SUBMAIN=1

for_each_ver() {
    local METEOR=$1
    local DEBIAN=$2
    local DEBIANS=($DEBIAN "debian$3")

    local MAIN=$(echo $METEOR | grep -Eo "^[0-9]+")
    local SUBMAIN=$(echo $METEOR | grep -Eo "^[0-9]+\.[0-9]+")
    SUBMAIN=${SUBMAIN#"$MAIN."}

    if [ -n "$PREV_VER" -a "$METEOR" != "$PREV_VER" ]; then
        if [ $MAIN -lt $PREV_MAIN ]; then
            NEW_MAIN=1
            NEW_SUBMAIN=1
        else
            NEW_MAIN=0
            if [ $SUBMAIN -lt $PREV_SUBMAIN ]; then
                NEW_SUBMAIN=1
            else
                NEW_SUBMAIN=0
            fi
        fi
    fi

    # build args
    local BUILD_ARGS=("METEOR_VERSION=$METEOR" "DEBIAN_VERSION=$DEBIAN")

    # image tags
    local TAGS=${DEBIANS[@]/#/"$METEOR-"}
    if [ $NEW_MAIN -gt 0 ]; then
        TAGS=(${TAGS[@]} ${DEBIANS[@]/#/"$MAIN-"})
    fi
    if [ $NEW_SUBMAIN -gt 0 ]; then
        TAGS=(${TAGS[@]} ${DEBIANS[@]/#/"$MAIN.$SUBMAIN-"})
    fi
    if [ $METEOR = ${METEOR_VERSIONS[0]} ]; then
        TAGS=(${TAGS[@]} ${DEBIANS[@]})
        if [ $DEBIAN = ${DEBIAN_VERSIONS[0]} ]; then
            TAGS=(${TAGS[@]} "latest")
        fi
    fi
    if [ $DEBIAN = ${DEBIAN_VERSIONS[0]} ]; then
        TAGS=(${TAGS[@]} "${METEOR}")
        if [ $NEW_MAIN -gt 0 ]; then
            TAGS=(${TAGS[@]} $MAIN)
        fi
        if [ $NEW_SUBMAIN -gt 0 ]; then
            TAGS=(${TAGS[@]} "$MAIN.$SUBMAIN")
        fi
    fi

    # echo ${TAGS[@]}
    docker build ${BUILD_ARGS[@]/#/"--build-arg "} ${TAGS[@]/#/"-t ${DOCKER_REPO}:"} .

    PREV_VER=$METEOR
    PREV_MAIN=$MAIN
    PREV_SUBMAIN=$SUBMAIN
}

if [ -n "$1" ]; then
    source ./vars.sh
    if [ "$1" = "${METEOR_VERSIONS[0]}" -o "$1" = "latest" ]; then
        echo "Building the latest meteor version..."
        for_each_ver ${METEOR_VERSIONS[0]} ${DEBIAN_VERSIONS[0]} ${DEBIAN_NUM_VERSIONS[0]}
        exit 0
    else
        echo "Invalid argument: $1" >&2
        exit 1
    fi
fi

source ./for-each-ver.sh
