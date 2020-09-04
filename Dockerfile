FROM ubuntu:16.04

RUN apt-get -qq update \
    && apt-get -qq -y install \
        autoconf \
        build-essential \
        curl \
        default-jre-headless \
        git \
        libgmp-dev \
        libssl-dev \
        ncurses-dev \
        python-dev \
        python-pip \
        unzip \
        libwxbase3.0-dev \
        libwxgtk3.0-dev \
        libsctp1 \
    && rm -rf /var/lib/apt/lists/*

ARG BUILD_OTP_VERSION="22.3.4.9"
ENV OTP_VERSION=$BUILD_OTP_VERSION
RUN PACKAGE_NAME=esl-erlang_${OTP_VERSION}-1~ubuntu~xenial_amd64.deb \
    && OTP_DOWNLOAD_URL=https://packages.erlang-solutions.com/erlang/debian/pool/${PACKAGE_NAME} \
    && curl -fsSL -o ${PACKAGE_NAME} "$OTP_DOWNLOAD_URL" \
    && dpkg -i ${PACKAGE_NAME} \
    && rm esl-erlang_${OTP_VERSION}-1~ubuntu~xenial_amd64.deb

ENV LIBSODIUM_VERSION=1.0.16
RUN LIBSODIUM_DOWNLOAD_URL="https://github.com/jedisct1/libsodium/releases/download/${LIBSODIUM_VERSION}/libsodium-${LIBSODIUM_VERSION}.tar.gz" \
    && curl -fsSL -o libsodium-src.tar.gz "$LIBSODIUM_DOWNLOAD_URL" \
    && mkdir libsodium-src \
    && tar -zxf libsodium-src.tar.gz -C libsodium-src --strip-components=1 \
    && cd libsodium-src \
    && ./configure && make -j$(nproc) && make install && ldconfig

ENV REBAR3_VERSION="3.14.0"
RUN set -xe \
    && REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
    && REBAR3_DOWNLOAD_SHA256="1e1a0d1d88d9b69311714eede8393a8a443cc53f9291755aa3c4da1f89a1132c" \
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
