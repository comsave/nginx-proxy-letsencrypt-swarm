#!/bin/bash

docker-gen -notify "nginx -s reload && /app/comsave/after_dockergen.sh" /app/nginx.tmpl /etc/nginx/conf.d/default.conf
