---
layout: post
title: "Browser Access to Proxmox using Tailscale"
date: 2024-04-23 23:32:36 +0000
published: true
github_comments_issueid: "8"
tags:
---

A proxmox server serves a browser based GUI for configuration.   This gui is accessible on localhost:8006 but there's no easy way to run a browser on the proxmox machine so we use tailscale to serve that port to a different machine.  The tailscale setup process probably doesn't justify a blog post but I'll go through it here anyway.   I'll be using the Virtualbox proxmox instance that I created and [wrote about](/2024/04/21/installing-proxmox-on-virtualbox.html) a couple of days ago to demonstrate.

------------------

The first step is to create an account at [tailscale](https://login.tailscale.com/start) .

------------------


Next, go to the tailscale [linux download](https://tailscale.com/download/linux) page `.   
![image tooltip here](/assets/2024-04-23--proxmox-tailscale/Screenshot from 2024-04-23 16-57-12.png)

------------------
From there copy the shell command that installs tailscale to the shell prompt of your proxmox server and run it:

![image tooltip here](/assets/2024-04-23--proxmox-tailscale/Screenshot from 2024-04-23 16-58-38.png)

------------------
This fails with errors related to apt source repositories.   
![image tooltip here](/assets/2024-04-23--proxmox-tailscale/Screenshot from 2024-04-23 16-59-19.png)

------------------
Comment out out the failing lines in /etc/apt/sources.list.d/ceph.list and /etc/apt/sources.list.d/pve-enterprise.list to fix these:
![image tooltip here](/assets/2024-04-23--proxmox-tailscale/Screenshot from 2024-04-23 17-03-54.png)

------------------
Now the tailscale install should succeed:
![image tooltip here](/assets/2024-04-23--proxmox-tailscale/Screenshot from 2024-04-23 17-06-22.png)

------------------
Per the instructions at the end of the install output, run "tailscale up".
![image tooltip here](/assets/2024-04-23--proxmox-tailscale/Screenshot from 2024-04-23 17-07-15.png)


------------------
After using a browswer to authenticate (per the "tailscale up" output) tailscale will confirm success:
![image tooltip here](/assets/2024-04-23--proxmox-tailscale/Screenshot from 2024-04-23 17-09-57.png)


---------------------
Use the ["tailscale serve"](https://tailscale.com/kb/1242/tailscale-serve) command to serve port 8006 by default:
![image tooltip here](/assets/2024-04-23--proxmox-tailscale/Screenshot from 2024-04-23 17-13-20.png)

---------------------
You will also need to install tailscale on any device that you want to access the Proxmox GUI from.

---------------------
Having installed tailscale both on your proxmox server and on the machine running the browser you should be able to acccess proxmox from anywhere.   Get the appropriate url from your tailscale login.   Having run "tailscale serve", there is no need for port 8006 to be specified on the url in the browser and the connection established is secure:   
![image tooltip here](/assets/2024-04-23--proxmox-tailscale/Screenshot from 2024-04-23 17-20-59.png)

---------------
The tailscale up state should persist through a reboot.  The "tailscale serve" command will also persist due to use of the "--bg" option.

---------------
Using tailscale is not the only option for directing traffic to localhost:8006 on the proxmox server.   However, it's probably as straightforward as any other technique, at least as secure, should work regardless of how your network is configured.  Also, tailscale allows you to reach your proxmox server from anywhere on the internet.   That's not so useful if you're running your proxmox host on a virtual machine that is running on your laptop (as mine is) but if your proxmox server is running on a physical server connected to your home network, then it might be useful to manage it from a remote location.
