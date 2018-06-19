#!/bin/bash -e

PREGEN_DHPARAM_FILE="/app/dhparam.pem.default"
DHPARAM_FILE="/etc/nginx/dhparam/dhparam.pem"

cp $PREGEN_DHPARAM_FILE $DHPARAM_FILE
