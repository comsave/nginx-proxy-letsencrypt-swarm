#!/bin/bash
echo "Running /app/comsave/after_dockergen.sh ..."

if [ -z "$1" ]; then
  echo "SWARM_SERVICE_NAME argument is not set"

  exit 1
fi

(
 /app/comsave/run_certbot_nginx.sh "$1" \
 && nginx -s reload \
 && /app/comsave/sync_push_certs.sh
) &

echo "Finished /app/comsave/after_dockergen.sh"
