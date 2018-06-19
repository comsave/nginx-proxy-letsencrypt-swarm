#!/bin/bash

echo 'recovered synced symlinks.'

rm -rf /etc/letsencrypt/live_original/
mv /etc/letsencrypt/live /etc/letsencrypt/live_original

for D in $(ls /etc/letsencrypt/live_original); do
      mkdir -p /etc/letsencrypt/live/$D

      echo 'created directory /etc/letsencrypt/live/'$D

      for F in $(ls /etc/letsencrypt/live_original/$D); do
          ln -s /etc/letsencrypt/live_original/$D/$F /etc/letsencrypt/live/$D/$F

          echo 'created file /etc/letsencrypt/live/'${D}'/'${F}
      done
done

echo 'creating certs symlinks...'

for container_virtual_host in $(ls /etc/letsencrypt/live); do
  ln -s /etc/letsencrypt/live/$container_virtual_host/fullchain.pem /etc/nginx/certs/$container_virtual_host.crt
  ln -s /etc/letsencrypt/live/$container_virtual_host/privkey.pem /etc/nginx/certs/$container_virtual_host.key
  ln -s /etc/letsencrypt/live/$container_virtual_host/fullchain.pem /etc/nginx/certs/$container_virtual_host.chain.pem
  ln -s /etc/letsencrypt/ssl-dhparams.pem /etc/nginx/certs/$container_virtual_host.dhparam.pem

  docker-gen /app/nginx.tmpl /etc/nginx/conf.d/default.conf

  echo "Symlinked $container_virtual_host certs."
done

echo 'finished creating certs symlinks.'
