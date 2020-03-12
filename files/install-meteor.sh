#!/bin/sh
set -e

RELEASE=${1%".0"}
PLATFORM="os.linux.x86_64"

TARBALL_URL="https://static-meteor.netdna-ssl.com/packages-bootstrap/${RELEASE}/meteor-bootstrap-${PLATFORM}.tar.gz"
TARBALL_TMP="${HOME}/.meteor-tarball"
INSTALL_TMP="${HOME}/.meteor-install"

cleanup() {
    rm -rf "${TARBALL_TMP}"
    rm -rf "${INSTALL_TMP}"
}

mkdir ${INSTALL_TMP}

VERBOSITY="--quiet"
if [ -t 1 ]; then
    VERBOSITY="--progress-bar"
fi

ATTEMPTS_NUM=${2:-10}
RETRY_INTERVAL=${3:-5}

wget \
    $VERBOSITY \
    --tries=${ATTEMPTS_NUM} \
    --waitretry=${RETRY_INTERVAL} \
    --continue \
    --output-document=${TARBALL_TMP} \
    "${TARBALL_URL}"

test -e "${TARBALL_TMP}"
tar -xzf "${TARBALL_TMP}" -C "${INSTALL_TMP}" -o
test -x "${INSTALL_TMP}/.meteor/meteor"
mv "${INSTALL_TMP}/.meteor" "${HOME}"

cleanup

METEOR_SYMLINK_TARGET="$(readlink "${HOME}/.meteor/meteor")"
METEOR_TOOL_DIRECTORY="$(dirname "${METEOR_SYMLINK_TARGET}")"
LAUNCHER="${HOME}/.meteor/${METEOR_TOOL_DIRECTORY}/scripts/admin/launch-meteor"

sudo cp "${LAUNCHER}" "/usr/local/bin/meteor"
