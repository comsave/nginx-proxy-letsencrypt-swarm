#!/bin/bash
echo "Running /app/comsave/after_dockergen.sh ..."

(
 /app/comsave/run_certbot_nginx.sh \
 && docker-gen /app/nginx.tmpl /etc/nginx/conf.d/default.conf \
 && nginx -s reload \
 && /app/comsave/sync_push_certs.sh
) &

echo "Finished /app/comsave/after_dockergen.sh"
