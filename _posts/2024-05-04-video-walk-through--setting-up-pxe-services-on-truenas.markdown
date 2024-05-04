---
layout: post
title: "Video walk-through: Setting up PXE services on TrueNAS"
date: 2024-05-04 18:29:13 +0000
published: true
github_comments_issueid: "17"
tags:
---

Setting up a network boot server makes reinstallation easy and, since you may have many boot files to serve up including installation ISO images, storing the files on your NAS and hosting the PXE services from there makes sense.  The netboot.xyz helm chart is a simple install on TrueNAS and the only other step is to configure your DHCP server to hand out the boot server and filename in DHCP responses (adding two lines in our VyOS config).

Although it is simple to get up and running, [this walkthrough video](https://rumble.com/v4t59be-setting-up-netboot.xyz-service-on-truenas-scale.html) highlights a few pitfalls, the file locations behind the scenes, using dhcpdump for debugging, and customizing the boot menus to boot files from your local NAS rather than across the internet (faster).  For fun, the demonstration shows you how you can use this to network install your Proxmox nodes which, since this is a virtual lab, results in running virutal Proxmox in Proxmox.  All that, and it is still less than an hour.


--
