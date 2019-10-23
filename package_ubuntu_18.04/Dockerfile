FROM ubuntu:18.04

RUN apt-get -qq update \
    && apt-get -qq -y install \
        apt-transport-https \
        autoconf \
        build-essential \
        curl \
        debhelper \
        default-jre-headless \
        devscripts \
        erlang \
        dh-autoreconf \
        git \
        libsodium-dev \
        libssl-dev \
        ncurses-dev \
        python-dev \
        python-pip \
        unzip \
    && rm -rf /var/lib/apt/lists/*

ENV REBAR3_VERSION="3.12.0"
RUN set -xe \
    && REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
    && REBAR3_DOWNLOAD_SHA256="d39bda02dd30276b2803fdb64ff731723961007608aa38e7422e603def70dc55" \
    && mkdir -p /usr/src/rebar3-src \
    && curl -fSL -o rebar3-src.tar.gz "$REBAR3_DOWNLOAD_URL" \
    && echo "$REBAR3_DOWNLOAD_SHA256 rebar3-src.tar.gz" | sha256sum -c - \
    && tar -xzf rebar3-src.tar.gz -C /usr/src/rebar3-src --strip-components=1 \
    && rm rebar3-src.tar.gz \
    && cd /usr/src/rebar3-src \
    && HOME=$PWD ./bootstrap \
    && install -v ./rebar3 /usr/local/bin/ \
    && rm -rf /usr/src/rebar3-src

RUN pip install virtualenv awscli

# Add non-root user in case some app won't run as root
RUN useradd --shell /bin/bash builder --create-home

ENV SHELL=/bin/bash
