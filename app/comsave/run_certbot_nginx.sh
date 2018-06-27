#!/bin/bash

SERVICES_VIRTUAL_HOST_ENVS=$(curl -s -X GET --unix-socket /tmp/docker.sock "http://v1.37/services" | jq '.[].Spec.TaskTemplate.ContainerSpec.Env  | map(select(. | contains("VIRTUAL_HOST")))[0]')

for SERVICE_VIRTUAL_HOST_ENV in $SERVICES_VIRTUAL_HOST_ENVS; do
  if [ ! -z "$SERVICE_VIRTUAL_HOST_ENV" ]; then
    SERVICE_VIRTUAL_HOSTS=$(eval echo "$SERVICE_VIRTUAL_HOST_ENV" | sed 's/VIRTUAL_HOST=\(.*\)/\1/')

    for SERVICE_VIRTUAL_HOSTS in $(echo ${IN//,/ }); do
      # if [ ! -d /etc/letsencrypt/live/$SERVICE_VIRTUAL_HOST ]; then
      certbot certonly --nginx --agree-tos -n -m $LETSENCRYPT_EMAIL -d $SERVICE_VIRTUAL_HOST --expand 2>/var/log/certbot.log || true
      # fi

      /app/comsave/symlink_nginx_cert.sh $SERVICE_VIRTUAL_HOST
    done
  fi
done
