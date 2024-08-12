---
layout: post
title: "walkthrough: \"Steadfast Self-Hosting: Rapid-Rise Personal Cloud\""
date: 2024-08-12 12:59:52 -0700
published: true
# github_comments_issueid: "create an issue and specfiy the issue id here"
tags:
---
The book "Steadfast Self-Hosting: Rapid-Rice Personal Cloud" is a guide to setting up your own personal home server.  I found the book to be easy to read, educational, and entertaining.  

The book has a [companion website](https://selfhostbook.com) where you can learn more about the book and buy it if you want to.   I purchased the book and I encourage you to also.

The rest of this post is a summary of my experience with the home server setup process outlined in the book.   

The server that I used was a repurposed Dell Latitude E5430 with 16GB RAM, 2TB SSD and an I5 processor, running Ubuntu Server 24.04 (installed from ISO just a couple of days ago). The book also calls for an "admin machine".  For this I used a VirtualBox virtual machine running Ubuntu Desktop 24.04 under a Windows host.  The purpose of the admin machine is to remotely configure the server.

The Steadfast system expects you to have registered a DNS domain and chosen a DNS "provider" for that domain. The domain that I purchased for this post was "cgull.tech" and I chose DNS provider, DigitalOcean, which provides the necessary nameservers and API access at no cost.   Thank you, DigitalOcean

After this process is complete the end result should be a server with the services, Nextcloud, Jellyfin, Wallabag, Watchtower, and Scratch installed.  Local (LAN) access to these services is enabled by default.  General internet access can be enabled for any/all of these services.

# Setting up the domain (cgull.tech).

According to the Steadfast book, the Steadfast tools also work with these DNS providers: "Duck DNS" "Namecheap", "DigitalOcean", and "Route 53".   The screenshots below walk through the process of setting up DigitalOcean as a DNS provider.   

From the DigitalOcean website, create an API access token.   Record this for later use:
<img src= "{{site.baseurl}}/assets/2024-08-12-walkthrough---steadfast-self-hosting--rapid-rise-personal-cloud/do_create_token.png"  alt="your-image-description" style="border: 2px solid grey;">

Also from the DigitalOcean website, Go to "Manage DNS on DigitalOcean" (shown below);
<img src= "{{site.baseurl}}/assets/2024-08-12-walkthrough---steadfast-self-hosting--rapid-rise-personal-cloud/do_manage_dns.png"  alt="your-image-description" style="border: 2px solid grey;">

Enter your domain (cgull.tech in my case).
<img src= "{{site.baseurl}}/assets/2024-08-12-walkthrough---steadfast-self-hosting--rapid-rise-personal-cloud/do_add_domain.png"  alt="your-image-description" style="border: 2px solid grey;">

DigitalOcean initially creates three NS records.  These will also need to be entered at your registrar (where you purchased the domain) :
<img src= "{{site.baseurl}}/assets/2024-08-12-walkthrough---steadfast-self-hosting--rapid-rise-personal-cloud/do_dns_records.png"  alt="your-image-description" style="border: 2px solid grey;">

At your DNS registrar enter the same nameservers shown in NS records by the DNS provider (DigitalOcean).   The registrar that I used was ionos.com so I had to leave DigitalOcean and log in to ionos.com:
<img src= "{{site.baseurl}}/assets/2024-08-12-walkthrough---steadfast-self-hosting--rapid-rise-personal-cloud/ionos_custom_name_servers.png"  alt="your-image-description" style="border: 2px solid grey;">


After this is done "dig" can be used on the command line to verify that the name servers have been updated :

```
dave@driver:/tmp$ dig  +nocmd cgull.tech ns +noall +answer
cgull.tech.             1644    IN      NS      ns1.digitalocean.com.
cgull.tech.             1644    IN      NS      ns3.digitalocean.com.
cgull.tech.             1644    IN      NS      ns2.digitalocean.com.
```

This DNS setup is required for the Steadfast setup script (provision.sh) to generate encryption certificates and is the bare minimum DNS configuration needed for the setup script to succeed.
Later in the process some additional DNS records will be added to direct internet traffic to the server. 

# Setting up the admin machine.

Note that this is the admin machine - not the server.  

The following changes to /etc/hosts and .ssh configuration can be found in the "SSH setup" section in the Steadfast book.   

The Steadfast tools use the name, "mario_server" to refer to the server.  This is configured by editing /etc/hosts on the admin machine.  I use git to record changes made to my /etc directory.   In the transcript below I'm using git to show changes made in /etc/hosts.


```
root@driver:/etc# git diff hosts
root@driver:/etc#
root@driver:/etc# cat hosts
127.0.0.1 localhost
127.0.1.1 driver

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
root@driver:/etc# cat >> hosts

# Adding the following per Steadfast self hosting book:
192.168.8.247  mario_server
root@driver:/etc# git diff hosts
diff --git a/hosts b/hosts
index 974c68f..53a31d7 100644
--- a/hosts
+++ b/hosts
@@ -7,3 +7,6 @@ fe00::0 ip6-localnet
 ff00::0 ip6-mcastprefix
 ff02::1 ip6-allnodes
 ff02::2 ip6-allrouters
+
+# Adding the following per Steadfast self hosting book:
+192.168.8.247  mario_server
root@driver:/etc# cat hosts
127.0.0.1 localhost
127.0.1.1 driver

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

# Adding the following per Steadfast self hosting book:
192.168.8.247  mario_server
root@driver:/etc#
```

Use ping to confirm that the server is accessible:


```
dave@driver:/etc$
dave@driver:/etc$ ping mario_server
PING mario_server (192.168.8.247) 56(84) bytes of data.
64 bytes from mario_server (192.168.8.247): icmp_seq=1 ttl=64 time=3.76 ms
64 bytes from mario_server (192.168.8.247): icmp_seq=2 ttl=64 time=5.15 ms
64 bytes from mario_server (192.168.8.247): icmp_seq=3 ttl=64 time=3.59 ms
^C
--- mario_server ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2005ms
rtt min/avg/max/mdev = 3.589/4.165/5.150/0.699 ms
dave@driver:/etc$
```


Configure ssh to to access the server as the appropriate user.

```
dave@driver:~$ cd .ssh
dave@driver:~/.ssh$ ls
authorized_keys  id_rsa  id_rsa.pub
dave@driver:~/.ssh$ cat > config
Host mario_server
  User dave
dave@driver:~/.ssh$
dave@driver:~/.ssh$ ssh mario_server
The authenticity of host 'mario_server (192.168.8.247)' can't be established.
ED25519 key fingerprint is SHA256:MV3EfXxBMcLuCZRsGkOHJdjaUUrwFZMJB567+wiRRp4.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'mario_server' (ED25519) to the list of known hosts.
dave@mario_server's password:
Welcome to Ubuntu 24.04 LTS (GNU/Linux 6.8.0-39-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.
Last login: Mon Aug  5 22:23:39 2024 from 192.168.8.146
dave@demoserver:~$
```


Copy the public half of your ssh-key pair to the server to enable login without a password.




```
dave@driver:~$ ssh-copy-id mario_server
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/dave/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
dave@mario_server's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'mario_server'"
and check to make sure that only the key(s) you wanted were added.

dave@driver:~$ ssh mario_server
Welcome to Ubuntu 24.04 LTS (GNU/Linux 6.8.0-39-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.
Last login: Mon Aug  5 22:33:17 2024 from 192.168.8.155
dave@demoserver:~$
```



# Provisioning the server.

The following process can be found in the "Provision server" section in the Steadfast book.   

The first thing to do is to clone the source repo from github: 
```
dave@driver:~$ git clone  https://github.com/meonkeys/shb.git
Cloning into 'shb'...
remote: Enumerating objects: 4726, done.
remote: Counting objects: 100% (1076/1076), done.
remote: Compressing objects: 100% (318/318), done.
remote: Total 4726 (delta 763), reused 1047 (delta 744), pack-reused 3650
Receiving objects: 100% (4726/4726), 21.86 MiB | 893.00 KiB/s, done.
Resolving deltas: 100% (3160/3160), done.
dave@driver
```


The provision script depends on ansible so install ansible:


```
dave@driver:~/shb/mario/ansible$ sudo apt install ansible
Reading package lists... 
```

Run the provision script.    It creates a config file to be filled out.

```
dave@driver:~/shb/mario/ansible$ ./provision.sh
You don't have a config file. I'll create one for you now.

Please edit '/home/dave/shb/mario/ansible/config' and re-run this script.
dave@driver:~/shb/mario/ansible$
```

So far, no changes have been made on the server.  The provision.sh script needs some parameters to be set in the config file (as called for in the previous transcript).   

# Configuration

I had to set 7 variables in the config file.    The "DO_AUTH_TOKEN" came from DigitalOcean (as shown earlier in this post).

```
# Specify your DNS provider here.
# Must be ONE of namecheap, digitalocean, route53, or duckdns.
# This and the corresponding provider-specific variables below are only used for directly manipulating DNS records to pass the DNS challenge for obtaining HTTPS encryption certs.
export DNS_API_PROVIDER='digitalocean'

### DigitalOcean API credentials ###
# If you specified digitalocean for DNS_API_PROVIDER above, enter real values in this section. Otherwise leave blank.
export DO_AUTH_TOKEN='dop_v1_5ad0fe8761a27e996c249999999999999999999999d70874fabc5c5a64482eef'

# Notification email for certificate errors / expirations.
# Use a value here matching what you use with your DNS API provider.
# You may receive emails from Let's Encrypt at this address.
export DNS_RESOLVER_EMAIL='example@example.com'

# A domain name you own, or at least one you control.
# Services will be named using subdomains, e.g. wallabag.example.com, jellyfin.example.com
# Note: domain names are not case-sensitive.
# Warning: Changing this later may be difficult.
export MARIO_DOMAIN_NAME='cgull.tech'

# Required to squelch a Nextcloud warning.
# Pick your code from https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements .
# See https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/config_sample_php_parameters.html?highlight=phone#user-experience
export DEFAULT_PHONE_REGION='US'

# Your server's time zone.
# Must correspond with an available timezone data file in /usr/share/zoneinfo on your server.
# For example, if you are in Seattle, use 'America/Los_Angeles', short for /usr/share/zoneinfo/America/Los_Angeles
# Note that 'US/Pacific' is no longer valid.
# Leaving this is 'Etc/Zulu' is fine too.
export TZ='America/Los_Angeles'

# Value to use for the `lan-only` middleware, which is enabled by default.
# This is a range of IP addresses in CIDR notation.
# See https://en.wikipedia.org/wiki/CIDR#CIDR_notation
# The default value assumes LAN addresses match 192.168.1.*
export LAN_ONLY_ALLOWED='192.168.8.0/24'

```
With the config file filled out, run provision.sh again.  The "BECOME" password is your password on the server to be provisioned and should only be prompted for one time.  

```
dave@driver:~/shb/mario/ansible$ ./provision.sh
BECOME password:

PLAY [all] *******************************************************************************************************************************************************************************************************

TASK [base : Configure apt cache] ********************************************************************************************************************************************************************************
ok: [mario_server]

TASK [base : Install packages] ***********************************************************************************************************************************************************************************
changed: [mario_server]

TASK [base : Set timezone] ***************************************************************************************************************************************************************************************
[WARNING]: Module remote_tmp /root/.ansible/tmp did not exist and was created with a mode of 0700, this may cause issues when running as another user. To avoid this, create the remote_tmp dir with the correct
permissions manually
changed: [mario_server]

TASK [base : Enable UFW] *****************************************************************************************************************************************************************************************
changed: [mario_server]

TASK [base : Disable logging] ************************************************************************************************************************************************************************************
changed: [mario_server]

TASK [base : Allow SSH] ******************************************************************************************************************************************************************************************
changed: [mario_server]

TASK [base : Allow insecure HTTP traffic] ************************************************************************************************************************************************************************
changed: [mario_server]

TASK [base : Allow secure HTTP traffic] **************************************************************************************************************************************************************************
changed: [mario_server]

TASK [base : Allow passwordless sudo] ****************************************************************************************************************************************************************************
changed: [mario_server]

TASK [base : increase UDP read buffer limits] ********************************************************************************************************************************************************************
changed: [mario_server]

TASK [base : increase UDP write buffer limits] *******************************************************************************************************************************************************************
changed: [mario_server]

TASK [docker : Install packages] *********************************************************************************************************************************************************************************
changed: [mario_server]

TASK [docker : Enable service] ***********************************************************************************************************************************************************************************
ok: [mario_server]

TASK [services : Create root-owned service directories] **********************************************************************************************************************************************************
changed: [mario_server] => (item=/data)
changed: [mario_server] => (item=/data/nextcloud)
changed: [mario_server] => (item=/data/nextcloud/db)
changed: [mario_server] => (item=/data/nextcloud/root)
changed: [mario_server] => (item=/data/traefik)
changed: [mario_server] => (item=/data/traefik/etc)
changed: [mario_server] => (item=/data/wallabag)
changed: [mario_server] => (item=/root/ops)
changed: [mario_server] => (item=/root/ops/jellyfin)
changed: [mario_server] => (item=/root/ops/nextcloud)
changed: [mario_server] => (item=/root/ops/scratch)
changed: [mario_server] => (item=/root/ops/scratch/custom)
changed: [mario_server] => (item=/root/ops/traefik)
changed: [mario_server] => (item=/root/ops/wallabag)
changed: [mario_server] => (item=/root/ops/watchtower)

TASK [services : Process and sync service configs] ***************************************************************************************************************************************************************
changed: [mario_server] => (item={'src': 'ops/jellyfin/compose.yml', 'dest': '/root/ops/jellyfin/compose.yml'})
changed: [mario_server] => (item={'src': 'ops/nextcloud/compose.yml', 'dest': '/root/ops/nextcloud/compose.yml'})
changed: [mario_server] => (item={'src': 'ops/scratch/compose.yml', 'dest': '/root/ops/scratch/compose.yml'})
changed: [mario_server] => (item={'src': 'ops/scratch/custom/Dockerfile', 'dest': '/root/ops/scratch/custom/Dockerfile'})
changed: [mario_server] => (item={'src': 'ops/scratch/custom/webpack.config.js', 'dest': '/root/ops/scratch/custom/webpack.config.js'})
changed: [mario_server] => (item={'src': 'ops/traefik/compose.yml', 'dest': '/root/ops/traefik/compose.yml'})
changed: [mario_server] => (item={'src': 'ops/wallabag/compose.yml', 'dest': '/root/ops/wallabag/compose.yml'})
changed: [mario_server] => (item={'src': 'ops/watchtower/compose.yml', 'dest': '/root/ops/watchtower/compose.yml'})

TASK [services : Create jellyfin group] **************************************************************************************************************************************************************************
changed: [mario_server]

TASK [services : Create jellyfin user] ***************************************************************************************************************************************************************************
changed: [mario_server]

TASK [services : Create jellyfin-owned directories] **************************************************************************************************************************************************************
ok: [mario_server] => (item=/data/jellyfin/home)
changed: [mario_server] => (item=/data/jellyfin/config)

TASK [services : Create Wallabag-owned directories] **************************************************************************************************************************************************************
changed: [mario_server] => (item=/data/wallabag/images)
changed: [mario_server] => (item=/data/wallabag/main)
changed: [mario_server] => (item=/data/wallabag/main/db)

TASK [services : Create Wallabag db] *****************************************************************************************************************************************************************************
changed: [mario_server]

TASK [services : Create Nextcloud-owned shared media directories] ************************************************************************************************************************************************
changed: [mario_server] => (item=/data/shared/media/video)
changed: [mario_server] => (item=/data/shared/media/music)

TASK [services : increase inotify limits] ************************************************************************************************************************************************************************
changed: [mario_server]

TASK [services : Check if Nextcloud config file exists] **********************************************************************************************************************************************************
ok: [mario_server]

TASK [services : Install PHP lint script] ************************************************************************************************************************************************************************
changed: [mario_server]

TASK [services : Add phone region to Nextcloud config] ***********************************************************************************************************************************************************
skipping: [mario_server]

TASK [services : Define arbitrary maintenance window] ************************************************************************************************************************************************************
skipping: [mario_server]

TASK [services : Install docker-compose shortcut script] *********************************************************************************************************************************************************
changed: [mario_server]

TASK [services : Install dc Bash completion] *********************************************************************************************************************************************************************
changed: [mario_server]

RUNNING HANDLER [base : timedatectl set-timezone] ****************************************************************************************************************************************************************
changed: [mario_server]

PLAY RECAP *******************************************************************************************************************************************************************************************************
mario_server               : ok=27   changed=24   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

dave@driver:~/shb/mario/ansible$
```
# Working with services

Two additional DNS records will be required to direct traffic to the server: an "A" record to assign a name to your public IP address (this will use cgull.tech) and a wildcard "CNAME" record to alias subdomains of cgull.tech to cgull.tech.   

Use curl as follows to get your public IP address:

```
dave@driver:/tmp$ curl -4 icanhazip.com 2> /dev/null
71.212.123.198
```

<img src= "{{site.baseurl}}/assets/2024-08-12-walkthrough---steadfast-self-hosting--rapid-rise-personal-cloud/do_more_dns_records.png"  alt="your-image-description" style="border: 2px solid grey;">

It may take some time for these entries to propagate through the internet buy once they do, you should be able to use dig to confirm that DNS is correctly configured:

```
dave@driver:/tmp$ dig @1.1.1.1 +nocmd traefik.cgull.tech  +noall +answer
traefik.cgull.tech.     43200   IN      CNAME   cgull.tech.
cgull.tech.             1800    IN      A       71.212.123.198
dave@driver:/tmp$
```

These DNS entries are enough to direct traffic to your public facing home internet router.   To get to the server will require a port forwarding rule on the router. All traffic to the server goes through https so port 443 needs to be forwarded:

<img src= "{{site.baseurl}}/assets/2024-08-12-walkthrough---steadfast-self-hosting--rapid-rise-personal-cloud/port_forward.png"  alt="your-image-description" style="border: 2px solid grey;">

The Steadfast services are accessed through a "reverse proxy service" called "traefik".    Once the DNS records and port forwarding rules are in place, you should be able to log in to the mario_server and start the traefik service.   Steadfast supplies a script on the server, "dc" which can be used to interact with services through docker ( see the "Start Services" and "Start reverse proxy" sections in the Steadfast book for details ) :

```
dave@driver:/tmp$ ssh mario_server
Welcome to Ubuntu 24.04 LTS (GNU/Linux 6.8.0-40-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.
Last login: Sun Aug 11 13:47:41 2024 from 192.168.8.148
dave@demoserver:~$ ps -ef | grep traef
dave        2791    2781  0 13:49 pts/0    00:00:00 grep --color=auto traef
dave@demoserver:~$ dc traefik up -d
+ sudo docker compose --file /root/ops/traefik/compose.yml up -d
[+] Running 1/2
 ⠼ Network traefik_default            Created                                                                                                                                                                0.4s
 ✔ Container traefik-reverse-proxy-1  Started                                                                                                                                                                0.3s
dave@demoserver:~$ ps -ef | grep traef
root        2965    2945  9 13:49 ?        00:00:00 traefik traefik --api.insecure=true --providers.docker=true --providers.docker.network=traefik_default --providers.docker.exposedbydefault=false --accesslog=false --log.level=INFO --entrypoints.web.address=:80 --entrypoints.websecure.address=:443 --entrypoints.websecure.http3 --entrypoints.web.http.redirections.entrypoint.scheme=https --entrypoints.web.http.redirections.entrypoint.to=websecure --certificatesresolvers.myresolver.acme.dnschallenge=true --certificatesresolvers.myresolver.acme.dnschallenge.provider=digitalocean --certificatesresolvers.myresolver.acme.email=bhivedotlive@gmail.com --certificatesresolvers.myresolver.acme.storage=/etc/traefik/acme.json --global.checknewversion=false --global.sendanonymoususage=false
dave        3019    2781  0 13:49 pts/0    00:00:00 grep --color=auto traef
dave@demoserver:~$
```

Once the service is running, you can use "https://traefik.cgull.tech" to access the gui through a browser on the same LAN as the server.
Note the icon to the left of the traefik.cgull.tech URL indicating that the connection is secure.   This confirms that the automatic creation of the Security Certificate succeeded.

<img src= "{{site.baseurl}}/assets/2024-08-12-walkthrough---steadfast-self-hosting--rapid-rise-personal-cloud/traefik.png"  alt="your-image-description" style="border: 2px solid grey;">

Once traefik starts, other services can also be started in the same way.   For example, nextcloud can be started as follows:

```
dave@demoserver:~$ dc nextcloud up -d
+ sudo docker compose --file /root/ops/nextcloud/compose.yml up -d
[+] Running 3/4
 ⠧ Network nextcloud            Created                                                                                                                                                                      0.8s
 ✔ Container nextcloud-redis-1  Started                                                                                                                                                                      0.7s
 ✔ Container nextcloud-db-1     Started                                                                                                                                                                      0.6s
 ✔ Container nextcloud-app-1    Started      
```

Once the nextcloud service is running, it can be accessed in the local lan through "https://cloud.cgull.tech"

<img src= "{{site.baseurl}}/assets/2024-08-12-walkthrough---steadfast-self-hosting--rapid-rise-personal-cloud/nextcloud.png"  alt="your-image-description" style="border: 2px solid grey;">

The DNS entries are enough to allow access to these services from anywhere on the net but the Steadfast configuration includes a filter, "lan-only", which limits internet connections to the local LAN.   This filter is enabled on a per service basis but can be removed.   To do this, remove "lan-only" from the appropriate compose.yml file (as shown below for nextcloud) and run the provision.sh script again.

Diffs show "lan-only" removed from compose.yml (on admin machine):

```
dave@driver:~/shb$ git diff
diff --git a/mario/ansible/roles/services/templates/ops/nextcloud/compose.yml b/mario/ansible/roles/services/templates/ops/nextcloud/compose.yml
index 496ca7a..5335d61 100644
--- a/mario/ansible/roles/services/templates/ops/nextcloud/compose.yml
+++ b/mario/ansible/roles/services/templates/ops/nextcloud/compose.yml
@@ -18,7 +18,7 @@ services:
       - "traefik.http.routers.nc-https.entrypoints=websecure"
       - "traefik.http.routers.nc-https.rule=Host(`cloud.{% raw %}{{ lookup('env', 'MARIO_DOMAIN_NAME') {% endraw %} }}`)"
       - "traefik.http.routers.nc-https.tls.certresolver=myresolver"
-      - "traefik.http.routers.nc-https.middlewares=nc-head,nc-redir,lan-only"
+      - "traefik.http.routers.nc-https.middlewares=nc-head,nc-redir"
       - "traefik.http.middlewares.nc-head.headers.stsSeconds=155520011"
       - "traefik.http.middlewares.nc-head.headers.stsIncludeSubdomains=true"
       - "traefik.http.middlewares.nc-head.headers.stsPreload=true"
dave@driver:~/shb$

```

After making this change and running provision.sh, "https://cloud.cgull.tech" should be accessible from the general internet.


