---
layout: post
title: "Meeting on May 2"
date: 2024-05-03 19:34:58 +0000
published: true
github_comments_issueid: "15"
tags:
---

The group met on zoom yesterday evening.  Seven people attended.

-----------------

We started off with brief discussions of 
* [Watch Your Lan](https://github.com/aceberg/WatchYourLAN), a "Lightweight network IP scanner with web GUI" (available as a [tteck](https://tteck.github.io/Proxmox/) monitoring package)
* [draw.io](https://www.drawio.com/), "a diagramming or whiteboarding application"
* [Linux Fest Northwest](https://linuxfestnorthwest.org/)
* [proxmox running under virtualbox](https://homeservernotes.info/2024/04/21/installing-proxmox-on-virtualbox.html)
* Different virtualization options ([VirtManager](https://virt-manager.org/), [GnomeBoxes](https://help.gnome.org/users/gnome-boxes/stable/))

-----------------
The major meeting topic was a [truenas](https://www.truenas.com/) lab that showcased the use of [terraform](https://www.terraform.io/) for virtual machine configuration within proxmox.  The lab is demonstrated in [this video](https://rumble.com/v4sq2sl-demo-project-update-2024-05-01.html). Some preliminary context that may be necessary can be found in [this video](https://rumble.com/v4kkjol-demo-project-update-2024-03-21.html) . This Use of terraform is facilitated by the [bpg proxmox plugin](https://registry.terraform.io/providers/bpg/proxmox/latest).   As part of this topic we discussed pros and cons of using ssh to access a truenas server ( a potential security problem in general ).   We also discussed the existence of truenas plugin modules; in particular modules that enable [netboot](https://netboot.xyz/) and [nextcloud](https://nextcloud.com/) functionality.


-----------------
We wrapped up with a discussion of the group's mission.   Some members emphasised the need for simplicity in whatever we end up creating.   We considered the advantages and disadvantages of using proxmox or yunohost as a basis for work.   We discussed what applications/services should be included in a baseline product.

