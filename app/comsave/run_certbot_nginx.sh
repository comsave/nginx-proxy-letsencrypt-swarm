#!/bin/bash

if [ -z "$1" ]; then
  echo "SWARM_SERVICE_NAME argument is not set"

  exit 1
fi

SWARM_SERVICE_NAME=$1

SERVICE_VIRTUAL_HOST=$(curl -s -X GET --unix-socket /tmp/docker.sock "http://v1.37/services?filters=\{\"name\":\[\"$SWARM_SERVICE_NAME\"\]\}" | jq '.[0].Spec.TaskTemplate.ContainerSpec.Env')
echo $SERVICE_VIRTUAL_HOST

if [ ! -z "$SERVICE_VIRTUAL_HOST" ]; then
  SERVICE_VIRTUAL_HOST=$(echo $SERVICE_VIRTUAL_HOST | jq '. | map(select(. | contains("VIRTUAL_HOST"))) | .[0]')
  SERVICE_VIRTUAL_HOST=$(eval echo "$SERVICE_VIRTUAL_HOST" | sed 's/VIRTUAL_HOST=\(.*\)/\1/')

  certbot certonly --nginx --agree-tos -n -m $LETSENCRYPT_EMAIL -d $SERVICE_VIRTUAL_HOST --expand 2>/var/log/certbot.log || true

  /app/comsave/symlink_nginx_cert.sh $SERVICE_VIRTUAL_HOST

  echo "Generated certificate for $SERVICE_VIRTUAL_HOST."
fi
