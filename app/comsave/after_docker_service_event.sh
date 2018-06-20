#!/bin/bash

docker-gen -notify "nginx -s reload && /app/comsave/after_dockergen.sh $1" /app/nginx.tmpl /etc/nginx/conf.d/default.conf
