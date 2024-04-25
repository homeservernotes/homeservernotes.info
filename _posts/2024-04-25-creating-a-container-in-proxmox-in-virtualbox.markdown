---
layout: post
title: "Creating a container in Proxmox in Virtualbox"
date: 2024-04-25 21:58:04 +0000
published: true
github_comments_issueid: "11"
tags:
---

This post will show how to use the web browser interface to create a container in a Proxmox host running under Virtualbox.    In Virtualbox, the network failed to initialize with the default DNS server.   Using a publicly available DNS server (such as 8.8.8.8) avoided this.

---------------------

First, log in to the browser based gui.

---------------------------------
To download a container template, select "local" from the menu on the left, "CT Templates" from the next menu, and click on the "Templates" button (shown highlighted in blue outline):

![image tooltip here](/assets/2024-04-25--container-in-proxmox-in-virtualbox/Screenshot from 2024-04-25 15-29-06.png)

---------------------
Choose a template to use for your container - I used "ubuntu-22.04-standard".

![image tooltip here](/assets/2024-04-25--container-in-proxmox-in-virtualbox/Screenshot from 2024-04-25 15-29-27.png)

---------------------
Watch it download.

![image tooltip here](/assets/2024-04-25--container-in-proxmox-in-virtualbox/Screenshot from 2024-04-25 15-29-51.png)


---------------------
Click on the "Create CT" button.  Up pops a "Create LXC Container" wizard.  Choose a password.


![image tooltip here](/assets/2024-04-25--container-in-proxmox-in-virtualbox/Screenshot from 2024-04-25 15-30-35.png)

---------------------
Use the container template downloaded earlier.

![image tooltip here](/assets/2024-04-25--container-in-proxmox-in-virtualbox/Screenshot from 2024-04-25 15-30-44.png)

---------------------
For IPv4 choose DHCP.

![image tooltip here](/assets/2024-04-25--container-in-proxmox-in-virtualbox/Screenshot from 2024-04-25 15-31-04.png)

---------------------
For DNS servers, choose 8.8.8.8 (or some other publicly available server).

![image tooltip here](/assets/2024-04-25--container-in-proxmox-in-virtualbox/Screenshot from 2024-04-25 15-31-16.png)

---------------------
Everything looks good!  

![image tooltip here](/assets/2024-04-25--container-in-proxmox-in-virtualbox/Screenshot from 2024-04-25 15-31-22.png)

---------------------
"Finish" and wait for "TASK OK".

![image tooltip here](/assets/2024-04-25--container-in-proxmox-in-virtualbox/Screenshot from 2024-04-25 15-31-34.png)

---------------------
Select the new container and press "Start".

![image tooltip here](/assets/2024-04-25--container-in-proxmox-in-virtualbox/Screenshot from 2024-04-25 15-31-47.png)

---------------------
Log in and verify network connectivity.

![image tooltip here](/assets/2024-04-25--container-in-proxmox-in-virtualbox/Screenshot from 2024-04-25 15-32-53.png)


