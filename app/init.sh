#!/bin/bash
set -e

rm -rf /etc/letsencrypt/* && mc mirror wasabi/nginx-proxy-letsencrypt /etc/letsencrypt \
 && /app/create_certs_symlinks.sh \
 && /app/docker-entrypoint.sh

exec "$@"
