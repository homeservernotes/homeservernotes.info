---
layout: post
title: "Installing Proxmox on Virtualbox"
date: 2024-04-21 20:15:46 +0000
published: true
github_comments_issueid: "3"
tags:
---

The purpose of this post is to document how to install Proxmox on Virtualbox.   The TLDR is that everything works as expected except that I found the default DNS IP address to be somewhat unreliable so I ended up using a public DNS IP address ( 8.8.8.8 ) instead.

I found the following references to be useful:

- [the proxmox wiki](https://pve.proxmox.com/wiki/Proxmox_VE_inside_VirtualBox)
- [How to Install Proxmox VE on VirtualBox? \| Step by Step](https://getlabsdone.com/how-to-install-proxmox-ve-on-virtualbox-step-by-step/)

------

I started with 61G of available disk space.   It turned out that I only needed about 4G .

![image tooltip here](/assets/2024-04-21--proxmox-vbox/Screenshot from 2024-04-20 14-35-15.png)

------
8GB of RAM and 4 CPU's.   Within the "green zone" indicated by Virtualbox.
![image tooltip here](/assets/2024-04-21--proxmox-vbox/Screenshot from 2024-04-20 14-36-08.png)

-----------
120GB of disk - probably overkill but without pre-allocation it should be fine.
![image tooltip here](/assets/2024-04-21--proxmox-vbox/Screenshot from 2024-04-20 14-36-14.png)

------
Specify the proxmox iso as optical drive:
![image tooltip here](/assets/2024-04-21--proxmox-vbox/Screenshot from 2024-04-21 13-50-09.png)


-----------
NAT network as suggested in [the proxmox wiki](https://pve.proxmox.com/wiki/Proxmox_VE_inside_VirtualBox).

![image tooltip here](/assets/2024-04-21--proxmox-vbox/Screenshot from 2024-04-20 14-36-34.png)

----------
"Enable Nested" is off by default and greyed out so some cmd line action is needed to turn it on as specified [here (thank you!)](https://getlabsdone.com/how-to-install-proxmox-ve-on-virtualbox-step-by-step/)
![image tooltip here](/assets/2024-04-21--proxmox-vbox/Screenshot from 2024-04-20 14-36-50.png)

----------
Aforementioned cmd line action :
![image tooltip here](/assets/2024-04-21--proxmox-vbox/Screenshot from 2024-04-20 14-38-12.png)

----------
Voila!
![image tooltip here](/assets/2024-04-21--proxmox-vbox/Screenshot from 2024-04-20 14-37-19.png)

----------
Now reboot and install .  I used "Terminal UI" which probably was a mistake because screen shots came out badly (as you can see below).
![image tooltip here](/assets/2024-04-21--proxmox-vbox/VirtualBox_proxmox_20_04_2024_14_38_33.png)

----------
Mostly I took the defaults or what seemed like the obvious choice.

For example, I used the entire disk (obviously)...
![image tooltip here](/assets/2024-04-21--proxmox-vbox/VirtualBox_proxmox_20_04_2024_14_39_30.png)

----------
...and the local timezone...
![image tooltip here](/assets/2024-04-21--proxmox-vbox/VirtualBox_proxmox_20_04_2024_14_39_55.png)

----------
...but for DNS server address, I specified 8.8.8.8, a public DNS address provided by Google.   I spent some time trying to get the default to work but eventually gave up and used 8.8.8.8.   YMMV
![image tooltip here](/assets/2024-04-21--proxmox-vbox/VirtualBox_proxmox_20_04_2024_14_41_13.png)

----------
Here's the full specification:
![image tooltip here](/assets/2024-04-21--proxmox-vbox/VirtualBox_proxmox_20_04_2024_14_41_34.png)


----------
Install took 5 or 10 minutes ( I didn't time it ).
![image tooltip here](/assets/2024-04-21--proxmox-vbox/VirtualBox_proxmox_20_04_2024_14_42_07.png)

----------
Reboot, then power off to unmount the proxmox ISO.
![image tooltip here](/assets/2024-04-21--proxmox-vbox/VirtualBox_proxmox_20_04_2024_14_44_20.png)

----------
We no longer need the ISO so unmount it.
![image tooltip here](/assets/2024-04-21--proxmox-vbox/Screenshot from 2024-04-20 14-45-10.png)

----------
ISO is gone.
![image tooltip here](/assets/2024-04-21--proxmox-vbox/Screenshot from 2024-04-20 14-45-20.png)


----------
Reboot, log in as root, ping yahoo.com to verify network and working DNS.   
![image tooltip here](/assets/2024-04-21--proxmox-vbox/Screenshot from 2024-04-21 13-06-48.png)

----------
Back in the shell, df shows that we now have about 3.5G less than starting out.   Note that this matches the virtual machine usage.
![image tooltip here](/assets/2024-04-21--proxmox-vbox/Screenshot from 2024-04-20 14-51-15.png)


----------
At this point, there's still more to do including using the proxmox browser interface, creating virtual machines, creating containers but I'm going to stop here and save that for a later post.  Thank you for reading.
