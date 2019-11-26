FROM golang

# install docker-swarm-watcher
RUN cd $GOPATH/src \
 && wget -q -O docker-swarm-watcher.tar.gz https://github.com/comsave/docker-swarm-watcher/archive/0.2.1.tar.gz  \
 && tar xvzf docker-swarm-watcher.tar.gz \
 && cd docker-swarm-watcher* \
 && go get -d -v ./... \
 && go install -v ./... \
 && go build ./... \
 && chmod a+x ./docker-swarm-watcher* \
 && mv ./docker-swarm-watcher* /bin/docker-swarm-watcher \
 && rm -rf $GOPATH/src/*

 # install docker-gen
RUN cd $GOPATH/src \
  && wget -q -O docker-gen.tar.gz https://github.com/comsave/docker-gen/archive/0.7.6.2.tar.gz  \
  && tar xvzf docker-gen.tar.gz \
  && cd docker-gen* \
  && go get -d -v ./... \
  && go install -v ./... \
  && go build ./... \
  && chmod a+x ./docker-gen* \
  && mv ./docker-gen* /bin/docker-gen \
  && mv ./templates/nginx.tmpl /tmp/nginx.tmpl \
  && mv ./templates/nginx-behind-proxy.tmpl /tmp/nginx-behind-proxy.tmpl \
  && rm -rf $GOPATH/src/*

FROM jwilder/nginx-proxy

RUN rm -f $(which docker-gen)

# copy over files from golang build
COPY --from=0 /bin/docker-swarm-watcher /bin/docker-swarm-watcher
COPY --from=0 /bin/docker-gen /bin/docker-gen
COPY --from=0 /tmp/nginx.tmpl /app/nginx.tmpl
COPY --from=0 /tmp/nginx-behind-proxy.tmpl /app/nginx-behind-proxy.tmpl

# install certbot
RUN wget -q https://dl.eff.org/certbot-auto \
&& chmod a+x ./certbot-auto \
&& mv ./certbot-auto /usr/local/bin/certbot \
&& certbot --install-only --non-interactive

# install minio s3 client
RUN wget -q https://dl.minio.io/client/mc/release/linux-amd64/mc \
&& mv ./mc /usr/local/bin/mc \
&& chmod a+x /usr/local/bin/mc

RUN apt-get update -y \
 && apt-get install -y \
            cron \
            jq \
            curl \
            procps

COPY ./cron.d/letsencrypt /etc/cron.d/letsencrypt
RUN crontab /etc/cron.d/letsencrypt

COPY ./templates/nginx.conf.tmpl /etc/nginx/nginx.conf

COPY ./app /app/

ENTRYPOINT ["/app/comsave/entrypoint.sh"]
CMD ["forego", "start", "-r"]
