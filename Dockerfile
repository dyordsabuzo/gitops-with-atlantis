FROM ghcr.io/runatlantis/atlantis:v0.23.1

ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN apk add --no-cache python3 py3-pip python3-dev \
    gcc libc-dev libffi-dev \
    && pip install -U pip

COPY scripts/generate-client-config.sh \
    scripts/generate-tfc-rc.sh \
    /usr/local/bin/