#!/bin/bash

echo 'recovering synced symlinks...'

rm -rf /etc/letsencrypt/live

for CERTIFICATE_DIR in $(ls /etc/letsencrypt/archive); do
      mkdir -p /etc/letsencrypt/live/$CERTIFICATE_DIR

      echo "created directory /etc/letsencrypt/live/$CERTIFICATE_DIR"

      for ORIGINAL_VIRTUAL_HOST_CERTIFICATE_FILE in $(ls /etc/letsencrypt/archive/$CERTIFICATE_DIR); do
          SYMLINKED_VIRTUAL_HOST_CERTIFICATE_FILE=$(printf '%s\n' "${ORIGINAL_VIRTUAL_HOST_CERTIFICATE_FILE//[[:digit:]]/}")

          rm /etc/letsencrypt/live/$CERTIFICATE_DIR/$SYMLINKED_VIRTUAL_HOST_CERTIFICATE_FILE
          ln -s /etc/letsencrypt/archive/$CERTIFICATE_DIR/$ORIGINAL_VIRTUAL_HOST_CERTIFICATE_FILE /etc/letsencrypt/live/$CERTIFICATE_DIR/$SYMLINKED_VIRTUAL_HOST_CERTIFICATE_FILE

          echo "created file /etc/letsencrypt/live/$CERTIFICATE_DIR/$SYMLINKED_VIRTUAL_HOST_CERTIFICATE_FILE"
      done
done

echo 'recovered synced symlinks.'

echo 'adding virtual host certs symlinks...'

for VIRTUAL_HOST in $(ls /etc/letsencrypt/live); do
  /app/comsave/symlink_nginx_cert.sh $VIRTUAL_HOST

  echo "Symlinked $VIRTUAL_HOST certs."
done

echo 'finished adding virtual host certs symlinks.'
