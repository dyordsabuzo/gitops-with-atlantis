FROM ghcr.io/runatlantis/atlantis:v0.19.6

RUN apk add --no-cache python3 py3-pip

COPY scripts/generate-client-config.sh \
    scripts/generate-tfc-rc.sh \
    /usr/local/bin/