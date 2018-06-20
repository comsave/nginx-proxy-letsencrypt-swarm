#!/bin/bash
set -e

/app/comsave/setup_sync.sh \
 && rm -rf /etc/letsencrypt/* \
 && /app/comsave/sync_pull_certs.sh \
 && /app/comsave/symlink_synced_certs.sh \

docker-gen /app/nginx.tmpl /etc/nginx/conf.d/default.conf

/app/comsave/setup_certbot.sh

/app/docker-entrypoint.sh

exec "$@"
