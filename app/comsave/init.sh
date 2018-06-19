#!/bin/bash
set -e

mc config host add wasabi $S3FS_ENDPOINT $S3FS_ACCESSKEY $S3FS_SECRETKEY \
 && rm -rf /etc/letsencrypt/* && mc mirror wasabi/nginx-proxy-letsencrypt /etc/letsencrypt \
 && certbot register -n -m $LETSENCRYPT_EMAIL --agree-tos \
 && /app/comsave/create_certs_symlinks.sh \
 && /app/docker-entrypoint.sh

exec "$@"
