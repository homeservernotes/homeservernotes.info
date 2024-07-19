---
layout: post
title: "Meeting on July 18"
date: 2024-07-19 20:26:31 +0000
published: true
github_comments_issueid: 27
tags:
---

# Overview
The group met on zoom. Three people attended.

# Topics
* Costs/benefits of running services in proxmox instead of directly on server.
* Review of terraform functionality and contrast to ansible. Terraform is used to build a network of virtual machines running under one or more “umbrellas” (proxmox, aws, azure…). Ansible can be used to install/configure services running on those machines.
* Cloudinit isos. Proxmox docs were endorsed as a good source of info about cloudinit isos as we might use them.
* Suggested minimal starting set of services for our project.
    * Streaming Server (like plex).
    * Photo server
    * NAS
* Tailscale. A participant offered to give a tailscale demo next time.
