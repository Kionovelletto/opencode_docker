FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    tar \
    gzip \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY install.sh /tmp/install.sh

RUN chmod +x /tmp/install.sh && \
    /tmp/install.sh && \
    rm /tmp/install.sh

ENV PATH="/root/.opencode/bin:${PATH}"

WORKDIR /workspace

CMD ["opencode"]