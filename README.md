# nginx-proxy-letsencrypt-swarm

nginx-proxy-letsencrypt-swarm sets up a container running nginx, [comsave/docker-gen](https://github.com/comsave/docker-gen) and [comsave/docker-swarm-watcher](https://github.com/comsave/docker-swarm-watcher). docker-gen generates reverse proxy configs for nginx and reloads nginx when containers are started and stopped. docker-swarm-watcher listens to all management nodes in a swarm an captures there events and acts accordingly. Ssl certificates are automatically generated, stored and renewed in an s3 compatible file storage. This ensures after node failure the container will rebuild with all it's persisted certificates.

**This project only runs in a swarm on manager nodes.**

## Usage:

Initialize a swarm.

```bash
$ docker swarm init
```

To enable high availability it is advisable to add multiple swarm managers and load balance across them. To promote a swarm node to a swarm manager run the following command on the manager.

```bash
$ docker swarm join-token manager
```


## Docker compose v3

```yml
version: '3.6'

services:
  nginx-proxy:
    image: joeriv/nginx-proxy-letsencrypt-swarm
    ports:
      - "80:80"
      - "443:443"
    environment:
      - S3FS_ENDPOINT=https://s3.amazonaws.com
      - S3FS_ACCESSKEY=<ACCESSKEY>
      - S3FS_SECRETKEY=<SECRETKEY>
      - S3FS_BUCKET=<BUCKETNAME>
      - LETSENCRYPT_EMAIL=<LETSENCRYPTEMAIL>
    deploy:
        placement:
          constraints: [node.role == manager]
    volumes:
      - "/var/run/docker.sock:/tmp/docker.sock:ro"

# docker stack deploy --compose-file=nginx-proxy.yml nginx-proxy

```
