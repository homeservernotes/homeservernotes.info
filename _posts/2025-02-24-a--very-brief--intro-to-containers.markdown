---
layout: post
title: "A (very brief) intro to containers"
date: 2025-02-24 18:19:01 -0800
published: true
github_comments_issueid: "58"
tags:
---

## Overview
A container is an isolated runtime environment with limited access to the host machine.  Typically you use this container to run a specific command.   For example, I use a docker container to run plex.    Along with the plex command, the container "contains" all the libraries and system config files (and probably some other stuff too) that Plex needs to run..   This guarantees that Plex will run without any dependency problems and without installing libraries that conflict with *other* things already installed on my computer.   It also makes Plex easy to uninstall: just delete the container.

There are several different container management tools (docker, podman, lxc, ... ) but I'm going to use docker in this email as a generic example of a container manager.

## Getting Started 
If you want to try out containers you can install docker on your linux box.  In ubuntu or other debian based systems you can use apt : "sudo apt install docker.io".   Docker (the organization) provides a nice "hello-world" test which you can run on the command line: "sudo docker run hello-world".   This should result in a multiline hello message in the terminal.   The sudo is required because docker needs to run as root.

The first time you run the hello-world test it will download an "image" which is a starting point for that container.  This will take a few seconds but if you run the test again the image is cached and you should see the response without delay.

To see a list of all the cached images, run "sudo docker images" on the command line.   To see a list of all running containers, run "sudo docker ps".   If you do that after running the hello-world test you should see one cached image and no running containers (because the test is no longer running).

An optional argument to "sudo docker run" is the executable to be run inside the container.  So, for example, to run a shell, to run a shell in a container you could type "docker run -i -t \<image-name\> bash" assuming the named image includes ("contains") bash.  The "-i -t" arguments tell docker that the container needs to be interactive ( -i ) and supply a terminal ( -t ).

If you run "sudo docker run -i -t ubuntu bash" you will get a shell prompt that gives you a way to see what is inside the container.   If you leave the new shell running and (in a different terminal) run "sudo docker ps" you will see the running container.   Once you exit the shell running in the container, "sudo docker ps" will no longer show that container because it is no longer running.

If you run "sudo docker run -i -t ubuntu bash" again you can make whatever changes you like in the container (apt updates, delete files, create new users, whatever).   If you exit the container (ctrl-d in the shell) and start it again, these changes will not be seen because each time, the container starts fresh from the image (ubuntu in this case).   Of course there are ways around this but I'm just focusing on the basics here.

In general, access to the host machine (networking, filesystem, gpu, etc) is granted at run time to the container on an as needed basis.


