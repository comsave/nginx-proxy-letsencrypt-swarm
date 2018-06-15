#!/bin/bash
for container_id in $(curl -s -X GET --unix-socket /tmp/docker.sock http:///v1.37/containers/json | jq -r '.[] | .Id'); do
  container_virtual_host=$(curl -s -X GET --unix-socket /tmp/docker.sock "http:///v1.37/containers/$container_id/json" | jq '.Config.Env | map(select(. | contains("VIRTUAL_HOST"))) | .[0]')

  if [ "$container_virtual_host" != "null" ]; then
    container_virtual_host=$(eval echo "$container_virtual_host" | sed 's/VIRTUAL_HOST=\(.*\)/\1/')

    certbot --staging --nginx --agree-tos -n -m joeri.veder@comsave.com -d $container_virtual_host 2>/var/log/certbot.log

    ln -s /etc/letsencrypt/live/$container_virtual_host/fullchain.pem /etc/nginx/certs/$container_virtual_host.crt
    ln -s /etc/letsencrypt/live/$container_virtual_host/privkey.pem /etc/nginx/certs/$container_virtual_host.key
    ln -s /etc/letsencrypt/ssl-dhparams.pem /etc/nginx/certs/$container_virtual_host.dhparam.pem

    docker-gen /app/nginx.tmpl /etc/nginx/conf.d/default.conf
  fi
done
