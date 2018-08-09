FROM ubuntu:18.04

RUN apt-get -qq update
RUN apt-get -qq -y install erlang libsodium-dev \
        git curl \
        python-pip python-dev \
        default-jre-headless \
    && rm -rf /var/lib/apt/lists/*

RUN pip install virtualenv awscli

# Add non-root user in case some app won't run as root
RUN useradd --shell /bin/bash builder --create-home

ENV SHELL=/bin/bash
