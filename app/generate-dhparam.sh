#!/bin/bash -e

PREGEN_DHPARAM_FILE="/app/dhparam.pem.default"
DHPARAM_FILE="/etc/nginx/dhparam/dhparam.pem"

if [[ -f $DHPARAM_FILE ]]; then
  cp $PREGEN_DHPARAM_FILE $DHPARAM_FILE \
  && nginx -s reload
fi
