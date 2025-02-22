---
layout: post
title: "Running a private docker repository with access through tailscale"
date: 2025-02-15 01:02:36 +0000
published: true
github_comments_issueid: "54"
tags:
---

This a summary of the steps I went through to get a private container (docker/podman) repository running on a home server with access through URL's provided by tailscale.   There's nothing original written here but it took me a while to figure it out and I wanted to collect it in one place.

I've been using docker compose to manage my server so I looked online for a suitable docker-compose.yaml file.   I found one in [this github repository](https://github.com/wshihadeh/docker-registry) which I cloned to my local machine.   I changed the volumes for data and certs to map to directories on the host and changed the tls certificate files to files created by me.

The end result looked like this:

```
networks:
  registry:
    external: false

services:

  registry:
    container_name: "registry_web"
    image: registry:2.6
    ports:
      - 5000:5000
    environment:
      REGISTRY_HTTP_ADDR: :5000
      REGISTRY_HTTP_TLS_CERTIFICATE: /certs/cert.crt
      REGISTRY_HTTP_TLS_KEY: /certs/cert.key
      REGISTRY_STORAGE: filesystem
      REGISTRY_STORAGE_DELETE_ENABLED: 'true'
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /var/lib/registry
    volumes:
      - ./data:/var/lib/registry
      - ./certs:/certs
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
To create the ssl certificate, I used ```tailscale cert``` per [these instructions](https://tailscale.com/kb/1153/enabling-https) to create ```cert.crt``` and ```cert.key```

I had to specify ```cert.crt``` and ```cert.key``` in the docker-compose file (see above).

Now, after running ```docker compose up``` in the directory containing the compose file, I can tag local images with the tailscale url for the server and then push them to the server.   An image that resides on the server can be run with either podman or docker.

To run tailscale on the server I use ```sudo tailscale up --accept-dns=false``` to avoid the clever tailscale DNS tricks.   They *are* clever and useful but I found them to cause problems when running a docker container on the server that needs to access the internet.   This may or may not affect this particular project but I think it's a good practice generally.   This is only for the server - clients do need the DNS cleverness.



