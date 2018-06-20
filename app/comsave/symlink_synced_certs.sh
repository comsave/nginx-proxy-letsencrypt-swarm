#!/bin/bash

echo 'recovering synced symlinks...'

rm -rf /etc/letsencrypt/live >/dev/null 2>&1

for D in $(ls /etc/letsencrypt/archive); do
      mkdir -p /etc/letsencrypt/live/$D >/dev/null 2>&1

      echo 'created directory /etc/letsencrypt/live/'$D

      for F in $(ls /etc/letsencrypt/archive/$D); do
          new_name=$(printf '%s\n' "${F//[[:digit:]]/}")

          rm /etc/letsencrypt/live/$D/$new_name >/dev/null 2>&1
          ln -s /etc/letsencrypt/archive/$D/$F /etc/letsencrypt/live/$D/$new_name >/dev/null 2>&1

          echo 'created file /etc/letsencrypt/live/'${D}'/'${new_name}
      done
done

echo 'recovered synced symlinks.'

echo 'adding virtual host certs symlinks...'

for VIRTUAL_HOST in $(ls /etc/letsencrypt/live); do
  /app/comsave/symlink_nginx_cert.sh $VIRTUAL_HOST

  echo "Symlinked $VIRTUAL_HOST certs."
done

echo 'finished adding virtual host certs symlinks.'

docker-gen /app/nginx.tmpl /etc/nginx/conf.d/default.conf
