#!/bin/bash
(
 /app/nginx_proxy_certbot.sh \
 && nginx -s reload \
 && echo 'mirror letsencrypt' \
 && mc mirror --overwrite --remove /etc/letsencrypt wasabi/nginx-proxy-letsencrypt
) &
