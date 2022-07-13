#!/bin/sh
set -e

ATLANTIS_VERSION=v0.19.4
ATLANTIS_PACKAGE=atlantis_linux_386.zip

echo "Download atlantis lib"
wget https://github.com/runatlantis/atlantis/releases/download/${ATLANTIS_VERSION}/${ATLANTIS_PACKAGE}
unzip atlantis_linux_386.zip

echo "Download ngrok"
wget -c https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-386.tgz -O - \
        | tar -xz

echo "Generate random secret string"
echo $RANDOM | md5sum | head -c 20; echo;
