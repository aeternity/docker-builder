FROM ubuntu:16.04

RUN apt-get -qq update \
    && apt-get -qq -y install \
        autoconf \
        build-essential \
        curl \
        default-jre-headless \
        git \
        libssl-dev \
        ncurses-dev \
        python-dev \
        python-pip \
        unzip \
    && rm -rf /var/lib/apt/lists/*

ARG BUILD_OTP_VERSION="20.3.8.23"
ENV OTP_VERSION=$BUILD_OTP_VERSION
RUN OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
    && curl -fsSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
    && mkdir otp-src \
    && tar -zxf otp-src.tar.gz -C otp-src --strip-components=1 \
    && cd otp-src \
    && export ERL_TOP=`pwd` \
    && ./otp_build autoconf && ./configure && make -j$(nproc) && make install

ENV LIBSODIUM_VERSION=1.0.16
RUN LIBSODIUM_DOWNLOAD_URL="https://github.com/jedisct1/libsodium/releases/download/${LIBSODIUM_VERSION}/libsodium-${LIBSODIUM_VERSION}.tar.gz" \
    && curl -fsSL -o libsodium-src.tar.gz "$LIBSODIUM_DOWNLOAD_URL" \
    && mkdir libsodium-src \
    && tar -zxf libsodium-src.tar.gz -C libsodium-src --strip-components=1 \
    && cd libsodium-src \
    && ./configure && make -j$(nproc) && make install && ldconfig

ENV REBAR3_VERSION="3.12.0"
RUN set -xe \
    && REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
    && REBAR3_DOWNLOAD_SHA256="8ac45498f03e293bc6342ec431888f9a81a4fb9e1177a69965238d127c00a79e" \
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
