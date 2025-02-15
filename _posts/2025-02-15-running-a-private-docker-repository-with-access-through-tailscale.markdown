---
layout: post
title: "Running a private docker repository with access through tailscale"
date: 2025-02-15 01:02:36 +0000
published: true
github_comments_issueid: "54"
tags:
---

This a summary of the steps I went through to get a private container (docker/podman) repository running on a home server with access through URL's provided by tailscale.   There's nothing original written here but it took me a while to figure it out and I wanted to collect it in one place.

I've been using docker compose to manage my server so I looked online for a suitable docker-compose.yaml file.   I found one in [this github repository](https://github.com/wshihadeh/docker-registry) which I cloned to my local machine.   I changed the volumes for data and certs to map to directories on the host and changed the port mapping from 5000:5000 to 443:5000 and changed the tls certificate files to files created by me.

The end result looked like this:

```
version: '3.7'

networks:
  registry:
    external: false

services:

  registry:
    container_name: "registry_web"
    image: registry:2.6
    ports:
      - 443:5000
    environment:
      REGISTRY_HTTP_ADDR: :5000
      REGISTRY_HTTP_TLS_CERTIFICATE: /certs/MyCert.crt
      REGISTRY_HTTP_TLS_KEY: /certs/MyPrivate.key
      REGISTRY_STORAGE: filesystem
      REGISTRY_STORAGE_DELETE_ENABLED: 'true'
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /var/lib/registry
    volumes:
      - /mnt/d1/docker-registry/data:/var/lib/registry
      - /mnt/d1/docker-registry/certs:/certs
      - ./config/config.yml:/etc/docker/registry/config.yml
    restart: always
    logging:
      driver: "json-file"
      options:
        "max-size": "10m"
        "max-file": "5"
    networks:
      - registry
```


To create the ssl certificate, I followed [these instructions](https://www.brainbytez.nl/tutorials/linux-tutorials/create-a-self-signed-wildcard-ssl-certificate-openssl/) which worked perfectly and almost verbatim.   The only change that I made was to specify a wild card representation of my tailscale url family in the openssl.ss.cnf file.

I had to specify MyCert.crt and MyPrivate.key in the docker-compose file (see above) and I had to use update-ca-certificates to register MyCert.crt on the client machine as shown [here](https://superuser.com/a/719047).   I may have rebooted the client at this point.    Of course this would have to be done on every client.   I believe this is necessary because the certificate is not signed by a higher authority.

Now, after running ```docker compose up``` in the directory containing the compose file, I can tag local images with the tailscale url for the server and then push them to the server.   An image that resides on the server can be run with either podman or docker.

To run tailscale on the server I use ```sudo tailscale up --accept-dns=false``` to avoid the clever tailscale DNS tricks.   They *are* clever and useful but I found them to cause problems when running a docker container on the server that needs to access the internet.   This may or may not affect this particular project but I think it's a good practice generally.   This is only for the server - clients do need the DNS cleverness.



