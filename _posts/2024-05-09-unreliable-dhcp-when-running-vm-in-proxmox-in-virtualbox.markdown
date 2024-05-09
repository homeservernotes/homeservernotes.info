---
layout: post
title: "Unreliable dhcp when running VM in proxmox in VirtualBox"
date: 2024-05-09 21:43:24 +0000
published: true
github_comments_issueid: "19"
tags:
---

I've been trying to put together a "proxmox in VirtualBox" environment that I can run on my laptop to experiment with.   By and large this has gone OK but I've run into one problem that I have not been able to resolve.   Specifically, a VM created in this proxmox environment does not get allocated a new ip address by the VirtualBox dhcp server.   I can work around this by manually assigning an IP address but my hope was to use this environment to test out this [automated setup system](https://github.com/dmbrownlee/demo-proxmox-terraform) which expects dhcp to work.

I posted a [question on the proxmox forum](https://forum.proxmox.com/threads/dhcp-fails-in-linuxmint-vm-in-proxmox-in-virtualbox-on-ubuntu-22-04.146680/) about this but so far nobody has responded.

At this point I regard the proxmox on Virtualbox environment to be unreliable so I'll probably switch to using a real computer for proxmox.

If anyone reading this knows what the problem is (or might be) please let me know in the comments.




