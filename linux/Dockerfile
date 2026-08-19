FROM debian:trixie-slim

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gcc \
        binutils \
        libc6-dev \
        make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work
