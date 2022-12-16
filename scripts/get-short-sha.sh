#!/bin/sh
set -e
echo '{"sha": "'"$(git rev-parse --short HEAD)"'"}'