---
layout: post
title: "Dynamic DNS for DigitalOcean"
date: 2024-08-09 20:41:22 -0700
published: true
github_comments_issueid: "31"
tags:
---

[Here](https://github.com/dc25/digitalocean_dyndns.git) is a bash script to keep a DigitalOcean DNS A record pointed back at your home internet.   It depends on curl and jq, both of which should be available through most package managers if you don't have them installed already.

To use it, you will need a domain that uses Digitalocean name servers and a Digitalocean API token.   [Per DigitalOcean](https://docs.digitalocean.com/products/networking/dns/details/pricing/), this functionality is avaliable at no cost.   I did have to give them credit card information.

The script expects the domain whose "A" record will be updated to be in the file "DIGITALOCEAN_DOMAIN" and the API token to be in the file "DIGITALOCEAN_TOKEN".

The script expects 1 or 0 arguments on the command line. If 1 argument is given, the the IP address given as command line argument will be saved in the "A" record.  Otherwise the script will use "curl" to retrieve the public IP address:

```
dave@driver:/tmp$ curl -4 icanhazip.com 2> /dev/null
50.245.151.169
dave@driver:/tmp$
```

If the script completes successfully, it will save its IP value.   The next time the script runs, it will check the current IP value against the previous IP value and exit if they are the same.  This prevents repeat calls to the DigitalOcean API with the same values.

To use the script, clone the repository, create the files DIGITALOCEAN_DOMAIN and DIGITALOCEAN_TOKEN and run the script:

```
dave@driver:~$
dave@driver:~$ git clone https://github.com/dc25/digitalocean_dyndns.git
Cloning into 'digitalocean_dyndns'...
remote: Enumerating objects: 9, done.
remote: Counting objects: 100% (9/9), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 9 (delta 3), reused 5 (delta 0), pack-reused 0
Receiving objects: 100% (9/9), done.
Resolving deltas: 100% (3/3), done.
dave@driver:~$ cd digitalocean_dyndns/
dave@driver:~/digitalocean_dyndns$
dave@driver:~/digitalocean_dyndns$ ls
dyndns.bash
dave@driver:~/digitalocean_dyndns$  cat > DIGITALOCEAN_DOMAIN
cgull.tech
dave@driver:~/digitalocean_dyndns$ cat > DIGITALOCEAN_TOKEN
dop_v1_f5b0685c95f896e55e64df50d2f108704c391c34cda8310ad229eede609ba928
dave@driver:~/digitalocean_dyndns$
dave@driver:~/digitalocean_dyndns$ ./dyndns.bash
deleting existing A record for cgull.tech
adding new A record for cgull.tech with value : 50.245.151.169
update worked so saving arguments "50.245.151.169" in /home/dave/repeat_check/dyndns.bash
dave@driver:~/digitalocean_dyndns$
dave@driver:~/digitalocean_dyndns$ ./dyndns.bash
previous update was also with argument: "50.245.151.169" so exiting now to avoid duplicate work.
dave@driver:~/digitalocean_dyndns$
```

Use cron to automate running on regular basis (once per minute shown in transcript below):


```
dave@driver:/tmp$ crontab -l
* *  * * *   /home/dave/digitalocean_dyndns/dyndns.bash > /tmp/dyndns.bash.out
dave@driver:/tmp$ date
Mon Aug 12 09:50:24 AM PDT 2024
dave@driver:/tmp$ ls dyndns.bash.out
ls: cannot access 'dyndns.bash.out': No such file or directory
dave@driver:/tmp$ date
Mon Aug 12 09:51:09 AM PDT 2024
dave@driver:/tmp$ ll dyndns.bash.out
-rw-rw-r-- 1 dave dave 195 Aug 12 09:51 dyndns.bash.out
dave@driver:/tmp$ cat !$
cat dyndns.bash.out
deleting existing A record for cgull.tech
adding new A record for cgull.tech with value : 50.245.151.169
update worked so saving arguments "50.245.151.169" in /home/dave/repeat_check/dyndns.bash
dave@driver:/tmp$
dave@driver:/tmp$ date
Mon Aug 12 09:52:07 AM PDT 2024
dave@driver:/tmp$ cat dyndns.bash.out
previous update was also with argument: "50.245.151.169" so exiting now to avoid duplicate work.
dave@driver:/tmp$
```
