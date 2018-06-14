certbot --staging --nginx --agree-tos -n -m joeri.veder@comsave.com -d staging.developer.comsave.com

ln -s /etc/letsencrypt/live/staging.developer.comsave.com/fullchain.pem /etc/nginx/certs/staging.developer.comsave.com.crt
ln -s /etc/letsencrypt/live/staging.developer.comsave.com/privkey.pem /etc/nginx/certs/staging.developer.comsave.com.key
ln -s /etc/letsencrypt/ssl-dhparams.pem /etc/nginx/certs/staging.developer.comsave.com.dhparam.pem

docker-gen -notify "nginx -s reload" /app/nginx.tmpl /etc/nginx/conf.d/default.conf
