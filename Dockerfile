FROM ghcr.io/runatlantis/atlantis:v0.19.6

COPY scripts/generate-client-config.sh \
    scripts/generate-tfc-rc.sh \
    /usr/local/bin/