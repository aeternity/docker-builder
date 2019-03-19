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

ENV REBAR3_VERSION="3.9.1-aeternity.2"
RUN set -xe \
    && REBAR3_DOWNLOAD_URL="https://github.com/aeternity/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
    && REBAR3_DOWNLOAD_SHA256="3322371eb80f6362f3784f231c7777b5ff22862101552d29d9dc37a61a8b3ea4" \
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
