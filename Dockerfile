ARG DEBIAN_VERSION=stretch

FROM debian:${DEBIAN_VERSION}

RUN apt-get update && \
    apt-get install -y wget sudo \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 meteor && \
    useradd -u 1000 -g meteor -G sudo -s /bin/bash -m meteor

COPY files/sudoers /etc/sudoers.d/nopasswd
COPY files/install-meteor.sh /usr/local/bin/install-meteor

USER meteor

ARG METEOR_VERSION=1.9.2
ARG DOWNLOAD_RETRY_NUM=10
ARG DOWNLOAD_RETRY_INTERVAL=5

RUN sudo chmod +x /usr/local/bin/install-meteor && \
    install-meteor $METEOR_VERSION $DOWNLOAD_RETRY_NUM $DOWNLOAD_RETRY_INTERVAL

VOLUME [ "/home/meteor/.meteor" ]
