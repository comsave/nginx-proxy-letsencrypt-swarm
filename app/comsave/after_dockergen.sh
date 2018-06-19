#!/bin/bash
(
 /app/comsave/nginx_proxy_certbot.sh \
 && nginx -s reload \
 && mc mirror --overwrite /etc/letsencrypt wasabi/nginx-proxy-letsencrypt
) &
