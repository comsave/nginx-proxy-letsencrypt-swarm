#!/bin/bash
(
 /app/comsave/run_certbot_nginx.sh \
 && nginx -s reload \
 && /app/comsave/sync_push_certs.sh
) &
