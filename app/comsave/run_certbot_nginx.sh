#!/bin/bash

if [ -n "$1" ]; then
  echo "SWARM_SERVICE_NAME argument is not set"

  exit 1
fi

SWARM_SERVICE_NAME=$1

SERVICE_VIRTUAL_HOST=$(curl -s -X GET --unix-socket /tmp/docker.sock 'http://v1.37/services?filters=\{"name":\["$SWARM_SERVICE_NAME"\]\}' | jq '.Spec.TaskTemplate.ContainerSpec.Env | map(select(. | contains("VIRTUAL_HOST"))) | .[0]')

if [ "$SERVICE_VIRTUAL_HOST" != "null" ]; then
  SERVICE_VIRTUAL_HOST=$(eval echo "$SERVICE_VIRTUAL_HOST" | sed 's/VIRTUAL_HOST=\(.*\)/\1/')

  certbot certonly --nginx --agree-tos -n -m $LETSENCRYPT_EMAIL -d $SERVICE_VIRTUAL_HOST --expand 2>/var/log/certbot.log

  /app/comsave/symlink_nginx_cert.sh $VIRTUAL_HOST

  docker-gen /app/nginx.tmpl /etc/nginx/conf.d/default.conf

  echo "Generated certificate for $SERVICE_VIRTUAL_HOST."
fi
