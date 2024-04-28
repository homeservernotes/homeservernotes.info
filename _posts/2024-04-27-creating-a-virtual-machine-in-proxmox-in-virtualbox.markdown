---
layout: post
title: "Creating a virtual machine in Proxmox in Virtualbox"
date: 2024-04-27 19:39:24 +0000
published: true
github_comments_issueid: "13"
tags:
---

This post describes the process that I went through to get a virtual machine running in a Proxmox instance running under Virtualbox.  My guess is that not all the steps shown here are optimal or even necessary but I'm leaving them all in just in case.

---------

The first thing that I should mention is that the only version of Proxmox that I was able to get this to work with is Proxmox 8.1-1.   With newer versions of Proxmox I would get "Guru Mediation" messages (basically a Proxmox crash) when booting from all the Linux ISO's that I tried.   This happened with Proxmox 8.1-2 and Proxmox 8.2-1.    Proxmox 8.1-1 is no longer available for download from the Proxmox site but [here is a link to a Proxmox 8.1-1 iso file that I uploaded](https://www.dropbox.com/scl/fi/cbvdqo0vb138dqtr1jwu4/proxmox-ve_8.1-1.iso?rlkey=crvhod61ez88cekuygj7ksjre&st=8w61lmxw&dl=0).

---------
After installing Proxmox 8.1-1 in virtual box, create a NAT network with default settings:
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-15-14.png)

---------
Use the "Create VM" button to create a new virtual machine:
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-20-08.png)

---------
Use the wizard to configure the machine.
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-20-18.png)

---------
Specify an ISO image to boot from (linuxmint used here).    You will need to first upload this to your Proxmox server (forgot to take a picture of the upload).
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-20-32.png)

---------
I set memory to 4096 and defaults for everything else.  Press "Start Now" to boot.
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-22-28.png)

---------
Off we go:
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-23-15.png)

---------
Double click the CD icon to do an install:
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-25-56.png)

---------
Go through the install process.  Pretty much all default values except for timezone.
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-29-00.png)

---------
Restart after "Installation has finished"
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-42-27.png)

---------
We have no internet connection:
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-46-06.png)

---------
So edit connections (right click on the little circle):
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-46-19.png)

---------
Add a connection:
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-46-36.png)

---------
Make up an address ( I chose 26 on the the 10.0.2.X network ). The rest is determined by the network (but still needs to be entered).
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-47-07.png)

---------
Don't forget (like I did) to change "Method" to "Manual" .
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-47-39.png)

---------
The internet is reachable but DNS is not working yet.
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-49-12.png)

---------
Specify DNS server 8.8.8.8 (public DNS server provided by Google):
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-49-41.png)

---------
Still can't ping yahoo.com:
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-50-04.png)

---------
Works after a reboot:
![image tooltip here](/assets/2024-04-27--virtual-machine-in-proxmox-in-virtualbox/Screenshot from 2024-04-27 14-52-09.png)


---------
After creating a single VM, subsequent VM creations connected to the internet without the connection editing needed by the first one .   I don't know why.   So, if you are doing some kind of automated management of a Proxmox in Virtualbox, you might consider creating a single VM by hand before starting the process.

