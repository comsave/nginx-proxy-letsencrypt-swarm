#!/bin/bash
set -e

/app/comsave/setup_sync.sh \
 && rm -rf /etc/letsencrypt/* \
 && /app/comsave/sync_pull_certs.sh \
 && /app/comsave/symlink_synced_certs.sh

/app/comsave/setup_certbot.sh

export NGINX_TEMPLATE=/app/nginx.tmpl

if [ ! -z "$BEHIND_PROXY" ] && [ "$BEHIND_PROXY" = true ]; then
  export NGINX_TEMPLATE=/app/nginx-proxy.tmpl
fi

cron -f &

docker-gen -notify="nginx -s reload" $NGINX_TEMPLATE /etc/nginx/conf.d/default.conf

/app/docker-entrypoint.sh

exec "$@"
