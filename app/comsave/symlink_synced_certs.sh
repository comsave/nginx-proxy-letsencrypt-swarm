#!/bin/bash

echo 'Recovering synced certs symlinks...'

rm -rf /etc/letsencrypt/live

for CERTIFICATE_DIR in $(ls /etc/letsencrypt/archive); do
      mkdir -p /etc/letsencrypt/live/$CERTIFICATE_DIR

      echo "Created directory /etc/letsencrypt/live/$CERTIFICATE_DIR"

      for ORIGINAL_VIRTUAL_HOST_CERTIFICATE_FILE in $(ls /etc/letsencrypt/archive/$CERTIFICATE_DIR); do
          SYMLINKED_VIRTUAL_HOST_CERTIFICATE_FILE=$(printf '%s\n' "${ORIGINAL_VIRTUAL_HOST_CERTIFICATE_FILE//[[:digit:]]/}")

          rm /etc/letsencrypt/live/$CERTIFICATE_DIR/$SYMLINKED_VIRTUAL_HOST_CERTIFICATE_FILE
          ln -s /etc/letsencrypt/archive/$CERTIFICATE_DIR/$ORIGINAL_VIRTUAL_HOST_CERTIFICATE_FILE /etc/letsencrypt/live/$CERTIFICATE_DIR/$SYMLINKED_VIRTUAL_HOST_CERTIFICATE_FILE

          echo "Created file /etc/letsencrypt/live/$CERTIFICATE_DIR/$SYMLINKED_VIRTUAL_HOST_CERTIFICATE_FILE"
      done
done

echo 'Recovered synced certs symlinks.'

echo 'Aadding virtual host certs symlinks...'

for VIRTUAL_HOST in $(ls /etc/letsencrypt/live); do
  /app/comsave/symlink_nginx_cert.sh $VIRTUAL_HOST

  echo "Symlinked $VIRTUAL_HOST cert."
done

echo 'Finished adding virtual host certs symlinks.'
