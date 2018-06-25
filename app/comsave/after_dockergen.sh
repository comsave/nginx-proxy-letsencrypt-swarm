#!/bin/bash
echo "Running /app/comsave/after_dockergen.sh ..."

(
 /app/comsave/run_certbot_nginx.sh \
 && docker-gen -notify="nginx -s reload" /app/nginx.tmpl /etc/nginx/conf.d/default.conf \
 && /app/comsave/sync_push_certs.sh
) &

echo "Finished /app/comsave/after_dockergen.sh"
