#!/bin/bash

echo 'recovering synced symlinks...'

rm -rf /etc/letsencrypt/live

for D in $(ls /etc/letsencrypt/archive); do
      mkdir -p /etc/letsencrypt/live/$D

      echo 'created directory /etc/letsencrypt/live/'$D

      for F in $(ls /etc/letsencrypt/archive/$D); do
          new_name=$(printf '%s\n' "${F//[[:digit:]]/}")

          rm /etc/letsencrypt/live/$D/$new_name
          ln -s /etc/letsencrypt/archive/$D/$F /etc/letsencrypt/live/$D/$new_name

          echo 'created file /etc/letsencrypt/live/'${D}'/'${new_name}
      done
done

echo 'recovered synced symlinks.'

echo 'adding virtual host certs symlinks...'

for container_virtual_host in $(ls /etc/letsencrypt/live); do
  ln -s /etc/letsencrypt/live/$container_virtual_host/fullchain.pem /etc/nginx/certs/$container_virtual_host.crt
  ln -s /etc/letsencrypt/live/$container_virtual_host/privkey.pem /etc/nginx/certs/$container_virtual_host.key
  ln -s /etc/letsencrypt/live/$container_virtual_host/fullchain.pem /etc/nginx/certs/$container_virtual_host.chain.pem
  ln -s /etc/letsencrypt/ssl-dhparams.pem /etc/nginx/certs/$container_virtual_host.dhparam.pem

  echo "Symlinked $container_virtual_host certs."
done

echo 'finished adding virtual host certs symlinks.'

docker-gen /app/nginx.tmpl /etc/nginx/conf.d/default.conf
