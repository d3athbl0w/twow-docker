# Fast C++ Incremental Development Builder Dockerfile
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    make \
    git \
    g++ \
    libace-dev \
    default-libmysqlclient-dev \
    libssl-dev \
    zlib1g-dev \
    ca-certificates \
    ccache \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

CMD ["bash", "/app/scripts/rebuild.sh"]
