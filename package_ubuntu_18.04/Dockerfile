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

RUN pip install virtualenv awscli

# Add non-root user in case some app won't run as root
RUN useradd --shell /bin/bash builder --create-home

ENV SHELL=/bin/bash
