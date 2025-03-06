---
layout: post
title: "walk-through: DNS server running in docker container"
date: 2025-03-06 12:58:27 -0800
published: true
github_comments_issueid: "62"
tags:
---

## Overview

This post will demonstrate a simple but useful example of a container.   

## Motivation

[Episode 581 of the changelog podcast](https://changelog.com/podcast/581), features an interview with [Paul Vixie](https://en.wikipedia.org/wiki/Paul_Vixie), a contributor to both [the design and implementation of several DNS protocol extensions](https://www.internethalloffame.org/inductee/paul-vixie/).  In this interview, Vixie advocates running and using a DNS server locally on your personal computer:


<img src= "{{site.baseurl}}/assets/2025-03-06-walk-through--dns-server-running-in-docker-container/vixieQuote.jpg" alt="your-image-description" style="border: 2px solid grey;">

This post goes through the process of using [Docker](https://docker.com) to build an image that contains the [unbound dns server](https://www.nlnetlabs.nl/projects/unbound/about/) built from source and run that image as a background process on your local machine.

## Setting up

First, install [docker](https://docker.com) and [docker compose](https://docs.docker.com/compose/) on your computer.  This walk-through uses [git](https://git-scm.com/) too so install that if necessary.   For example, on Ubuntu, use apt:

```
hs@vbox:~$ sudo apt install docker.io docker-compose-v2 git -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
... lots of output removed ...
hs@vbox:~$
```

## Get the related source files from github:

```
hs@vbox:~$ git clone https://github.com/homeserversample/docker-unbound-source.git
Cloning into 'docker-unbound-source'...
remote: Enumerating objects: 44, done.
remote: Counting objects: 100% (44/44), done.
remote: Compressing objects: 100% (31/31), done.
remote: Total 44 (delta 14), reused 39 (delta 9), pack-reused 0 (from 0)
Receiving objects: 100% (44/44), 6.25 KiB | 2.08 MiB/s, done.
Resolving deltas: 100% (14/14), done.
hs@vbox:~$

```

This repository includes:
* A Dockerfile file which specifies how to build the image from source.
* A docker-compose.yaml file which specifies how to run the image.
* A localhost.conf file that specifies the configuration for unbound.
* An empty unbound.log file which unbound will write logging output to.

Note that the docker compose file contains the following line:
```
    build: .
```

This line directs docker compose to build the image based on the Dockerfile in the current directory if the image does not already exist.

## Start the unbound server.

In the "docker-unbound-source" repo, type ```sudo docker compose up```.   This will run unbound inside a container per the specifications in docker-compose.yaml.   If needed (the first time only), docker will build the image per the specifications in Dockerfile.

```
hs@vbox:~$ cd docker-unbound-source/
hs@vbox:~/docker-unbound-source$ sudo docker compose up
[+] Building 128.4s (16/19)                                                                                                                                          docker:default
 => [unbound internal] load build definition from Dockerfile                                                                                                                   0.0s
 => => transferring dockerfile: 664B                                                                                                                                           0.0s
 => [unbound internal] load metadata for docker.io/library/ubuntu:latest                                                                                                       1.2s
 => [unbound internal] load .dockerignore                                                                                                                                      0.0s
 => => transferring context: 2B                                                                                                                                                0.0s
 => [unbound  1/16] FROM docker.io/library/ubuntu:latest@sha256:72297848456d5d37d1262630108ab308d3e9ec7ed1c3286a32fe09856619a782                                               2.4s

...deleted lengthy transcript...

 => => writing image sha256:06bafa09419dc2324070786743d42435fe75c6eec9d82faf9bc6df9ddfbdb876                                                                                   0.0s
 => => naming to docker.io/library/docker-unbound-source-unbound                                                                                                               0.0s
[+] Running 1/1
 ✔ Container docker-unbound-source-unbound-1  Created                                                                                                                          0.2s
Attaching to unbound-1

```

# Take note of running docker container.

At this point the unbound DNS server should be running in a docker container on your system.   In a new window, use ```sudo docker ps``` to list the running containers:
```
hs@vbox:~$ sudo docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED         STATUS         PORTS     NAMES
9dfb2d3cf895   docker-unbound-source-unbound   "unbound -d -c /conf…"   7 minutes ago   Up 7 minutes             docker-unbound-source-unbound-1
hs@vbox:~$
```

## Use dig to test the DNS server

Unbound should be listening for DNS queries on the localhost network interface for the computer that it is running on.  Use dig (in a new terminal) to verify this:
```
hs@vbox:~$
hs@vbox:~$ dig @127.0.0.1 google.com

; <<>> DiG 9.18.30-0ubuntu0.24.04.2-Ubuntu <<>> @127.0.0.1 google.com
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43916
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             267     IN      A       142.251.211.238

;; Query time: 1 msec
;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
;; WHEN: Fri Feb 28 15:37:37 PST 2025
;; MSG SIZE  rcvd: 55

hs@vbox:~$
```

Note that the SERVER is reported to be 127.0.0.1#53.   This is the address/port that the unbound server listens on.

## Make localhost the default DNS server 

At this point, unbound is running and responding to local DNS queries but is not (yet) the default DNS service for this computer.  If you use dig *without* specifying a server to use you can see that the default server is not 127.0.0.1:53 .   In my case it is 127.0.0.53:53 :
```
hs@vbox:~$ dig google.com

; <<>> DiG 9.18.30-0ubuntu0.24.04.2-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 11243
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             85      IN      A       142.251.211.238

;; Query time: 8 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Fri Feb 28 15:57:05 PST 2025
;; MSG SIZE  rcvd: 55

hs@vbox:~$

```

How to change the default DNS server will vary from one machine to another.   On a Ubuntu 24.04 computer I deleted the existing /etc/resolv.conf link and recreated /etc/resolve.conf as a file specifying 127.0.0.1 as my DNS server with 1.1.1.1 as an alternate server in case something goes wrong with the containerized unbound:


```
hs@vbox:~$ cd /etc
hs@vbox:/etc$ ls -la resolv.conf
lrwxrwxrwx 1 root root 39 Apr 24  2024 resolv.conf -> ../run/systemd/resolve/stub-resolv.conf
hs@vbox:/etc$ sudo su
root@vbox:/etc# cp resolv.conf  resolv.conf.sav
root@vbox:/etc# rm resolv.conf
root@vbox:/etc# cat > resolv.conf << DONE
> nameserver 127.0.0.1
nameserer 1.1.1.1
options edns0 trust-ad
search lan
DONE
root@vbox:/etc#
root@vbox:/etc#
root@vbox:/etc# exit
exit
hs@vbox:/etc$
hs@vbox:/etc$ cat resolv.conf
nameserver 127.0.0.1
nameserer 1.1.1.1
options edns0 trust-ad
search lan
hs@vbox:/etc$
```

## Use dig again to verify that the default server is now localhost:


```
hs@vbox:/etc$ dig google.com

; <<>> DiG 9.18.30-0ubuntu0.24.04.2-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16543
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             300     IN      A       142.251.211.238

;; Query time: 14 msec
;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
;; WHEN: Fri Feb 28 16:09:35 PST 2025
;; MSG SIZE  rcvd: 55

```

## Running the containerized unbound as a background service

If the unbound server is still running, you can close it gracefully with a ctrl-c in the terminal that it is running in:

```
[+] Running 1/1
 ✔ Container docker-unbound-source-unbound-1  Created                                                                                                   0.1s
Attaching to unbound-1
^CGracefully stopping... (press Ctrl+C again to force)
[+] Stopping 1/0
 ✔ Container docker-unbound-source-unbound-1  Stopped                                                                                                                          0.1s
canceled
hs@vbox:~/docker-unbound-source$

```

If you like, you can use dig again to verify that the server is no longer functioning:
```
hs@vbox:/etc$ dig google.com
;; communications error to 127.0.0.1#53: connection refused
;; communications error to 127.0.0.1#53: connection refused
;; communications error to 127.0.0.1#53: connection refused

; <<>> DiG 9.18.30-0ubuntu0.24.04.2-Ubuntu <<>> google.com
;; global options: +cmd
;; no servers could be reached
hs@vbox:/etc$ cat resolv.conf
nameserver 127.0.0.1
nameserer 1.1.1.1
options edns0 trust-ad
search lan
hs@vbox:/etc$
```

Note that my backup server didn't run either due to a typo in ```/etc/resolv.conf``` ( "nameserver" spelled wrong on second line ).


After fixing the typo ```dig google.com``` uses the 1.1.1.1 DNS server and gives the expected result:

```
hs@vbox:/etc$ dig google.com
;; communications error to 127.0.0.1#53: connection refused
;; communications error to 127.0.0.1#53: connection refused
;; communications error to 127.0.0.1#53: connection refused

; <<>> DiG 9.18.30-0ubuntu0.24.04.2-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 63053
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             107     IN      A       142.251.33.78

;; Query time: 27 msec
;; SERVER: 1.1.1.1#53(1.1.1.1) (UDP)
;; WHEN: Fri Feb 28 16:22:14 PST 2025
;; MSG SIZE  rcvd: 55

hs@vbox:/etc$
```
To run the containerized unbound DNS server as a background sevice, add a ```-d``` argument to the ```docker compose up``` command used earlier:

```
hs@vbox:~/docker-unbound-source$ sudo docker compose up -d
[+] Running 1/1
 ✔ Container docker-unbound-source-unbound-1  Started                                                                                                                          0.2s
hs@vbox:~/docker-unbound-source$
hs@vbox:~/docker-unbound-source$ sudo docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS          PORTS     NAMES
bce4cc48eb8a   docker-unbound-source-unbound   "unbound -d -c /conf…"   50 minutes ago   Up 23 seconds             docker-unbound-source-unbound-1
hs@vbox:~/docker-unbound-source$
```

Note the use of ```docker ps``` to verify that the container is running.

You can use dig again (not shown here) to verify that unbound is functioning.   

At this point, the docker system should restart the containerized unbound automatically after a reboot.

To shutdown the container, use ```docker compose down``` in the same directory as the docker-compose.yaml file:

```
hs@vbox:~$ pwd
/home/hs
hs@vbox:~$ cd docker-unbound-source/
hs@vbox:~/docker-unbound-source$ ls
conf  docker-compose.yaml  Dockerfile  log
hs@vbox:~/docker-unbound-source$ sudo docker compose down
[+] Running 1/1
 ✔ Container docker-unbound-source-unbound-1  Removed                                                                                                                          0.1s
hs@vbox:~/docker-unbound-source$
hs@vbox:~/docker-unbound-source$
hs@vbox:~/docker-unbound-source$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
hs@vbox:~/docker-unbound-source$
hs@vbox:~/docker-unbound-source$
```

Note the use of ```docker ps``` to verify that the container is no longer running.

Use ```docker compose up -d``` to start the containerized unbound server back up.

At this point you can leave the unbound server running to "listen on the loopback address" for DNS queries (as Paul Vixie suggested) or restore the computer to the original settings:

```
hs@vbox:~$ cd /etc
hs@vbox:/etc$ sudo su
root@vbox:/etc# cp resolv.conf resolv.conf.save2
root@vbox:/etc# ln -s ../run/systemd/resolve/stub-resolv.conf resolv.conf
ln: failed to create symbolic link 'resolv.conf': File exists
root@vbox:/etc# rm resolv.conf
root@vbox:/etc# ln -s ../run/systemd/resolve/stub-resolv.conf resolv.conf
root@vbox:/etc# diff resolv.conf resolv.conf.save
root@vbox:/etc#
exit
hs@vbox:/etc$ dig google.com

; <<>> DiG 9.18.30-0ubuntu0.24.04.2-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 47738
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             63      IN      A       142.250.217.78

;; Query time: 8 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Fri Feb 28 16:44:46 PST 2025
;; MSG SIZE  rcvd: 55

hs@vbox:/etc$

```

Note the use of dig again to confirm that the original settings have been successfully restored.
