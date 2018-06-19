FROM jwilder/nginx-proxy

RUN wget -q https://dl.eff.org/certbot-auto \
&& chmod a+x ./certbot-auto \
&& mv ./certbot-auto /usr/local/bin/certbot \
&& certbot --install-only --non-interactive

RUN wget -q https://dl.minio.io/client/mc/release/linux-amd64/mc \
&& mv ./mc /usr/local/bin/mc \
&& chmod a+x /usr/local/bin/mc

RUN apt-get update -y \
 && apt-get install -y \
            cron \
            jq \
            curl

COPY ./cron.d/letsencrypt /etc/cron.d/letsencrypt
RUN crontab /etc/cron.d/letsencrypt

COPY ./cron.d/letsencrypt /etc/cron.d/letsencrypt
RUN crontab /etc/cron.d/letsencrypt

COPY ./app /app/

ENTRYPOINT ["/app/comsave/init.sh"]
CMD ["forego", "start", "-r"]
