FROM ubuntu:18.04

RUN apt-get -qq update \
    && apt-get -qq -y install git curl unzip \
        autoconf build-essential ncurses-dev libssl-dev \
        python-pip python-dev \
        default-jre-headless \
	libsodium-dev debhelper apt-transport-https \
	autoconf build-essential devscripts erlang \
	debhelper dh-autoreconf \
    && rm -rf /var/lib/apt/lists/*

ENV REBAR3_VERSION="3.9.1-aeternity.1"
RUN set -xe \
    && REBAR3_DOWNLOAD_URL="https://github.com/aeternity/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
    && REBAR3_DOWNLOAD_SHA256="09e66f741d46f1cc4d33cc5d31e616b5be06aac025938d1a4f82802c3b7341ea" \
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
