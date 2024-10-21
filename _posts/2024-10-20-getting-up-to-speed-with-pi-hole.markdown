---
layout: post
title: "Getting up to speed with pi-hole"
date: 2024-10-20 01:56:34 +0000
published: true
github_comments_issueid: "50"
tags:
---

This is a step by step summary of what it was like to install and use pi-hole on a proxmox server serving a small home network.   

## Install in proxmox container

* Created a new container
    * Static IP ( 192.168.8.141 )
    * 2 cpus (may not have been necessary)
    * default settings otherwise

* Started new container
* Used apt update & apt upgrade to bring up to date
* Used apt to install curl
* Used curl to install pi-hole per [instructions on site](https://github.com/pi-hole/pi-hole/#one-step-automated-install)
* Take note of pi-hole password.
* Used ps to verify that pi-hole is running:

```
root@pihole2:~# ps -ef | grep pi
message+     102       1  0 01:45 ?        00:00:00 @dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
pihole       158       1  0 01:45 ?        00:00:01 /usr/bin/pihole-FTL -f
postfix      331     326  0 01:45 ?        00:00:00 pickup -l -t unix -u -c
root         547     537  0 02:05 pts/1    00:00:00 grep --color=auto pi
root@pihole2:~# 
```
* Reboot container and use ps again to verify automatic starting.

## Try it out from a client computer.

* Specify the pi-hole as DNS server by IP address.  Windows example shown below.
<img src= "{{site.baseurl}}/assets/2024-10-20__getting-up-to-speed-with-pi-hole/wireless_ip_settings_for_pihole.jpg" alt="your-image-description" style="border: 2px solid grey;">

* Make sure web browsing still works.
* Access pi-hole control through browser : `https://192.168.8.141/admin`
* Use browser interface to disable/enable blocking.   Try browsing both ways.

## Eliminate the middleman! Try pi-hole with a recursive DNS server.

* Per [these instructions](https://docs.pi-hole.net/guides/dns/unbound/), install and configure unbound.

(install)

```
root@pihole2:~# apt install unbound
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  unbound
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
```
(and configure)
```
root@pihole2:~# cd /etc/unbound/unbound.conf.d/
root@pihole2:/etc/unbound/unbound.conf.d# ls
root-auto-trust-anchor-file.conf
root@pihole2:/etc/unbound/unbound.conf.d# cat > pi-hole.conf
server:
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to yes if you have IPv6 connectivity
    do-ip6: no

    # You want to leave this to no unless you have *native* IPv6. With 6to4 and
    # Terredo tunnels your web browser should favor IPv4 for the same reasons
    prefer-ip6: no

    # Use this only when you downloaded the list of primary root servers!
    # If you use the default dns-root-data package, unbound will find it automatically
    #root-hints: "/var/lib/unbound/root.hints"

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    # IP fragmentation is unreliable on the Internet today, and can cause
    # transmission failures when large DNS messages are sent via UDP. Even
    # when fragmentation does work, it may not be secure; it is theoretically
    # possible to spoof parts of a fragmented DNS message, without easy
    # detection at the receiving end. Recently, there was an excellent study
    # >>> Defragmenting DNS - Determining the optimal maximum UDP response size for DNS <<<
    # by Axel Koolhaas, and Tjeerd Slokker (https://indico.dns-oarc.net/event/36/contributions/776/)
    # in collaboration with NLnet Labs explored DNS using real world data from the
    # the RIPE Atlas probes and the researchers suggested different values for
    # IPv4 and IPv6 and in different scenarios. They advise that servers should
    # be configured to limit DNS messages sent over UDP to a size that will not
    # trigger fragmentation on typical network links. DNS servers can switch
    # from UDP to TCP when a DNS response is too big to fit in this limited
    # buffer size. This value has also been suggested in DNS Flag Day 2020.
    edns-buffer-size: 1232

    # Perform prefetching of close to expired message cache entries
    # This only applies to domains that have been frequently queried
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10
root@pihole2:/etc/unbound/unbound.conf.d# ls
pi-hole.conf  root-auto-trust-anchor-file.conf
root@pihole2:/etc/unbound/unbound.conf.d# 
```

* Start and test the recursive server ("unbound").

```
root@pihole2:/etc/unbound/unbound.conf.d# ps -ef  | grep unb
root        8070     537  0 20:54 pts/1    00:00:00 grep --color=auto unb
root@pihole2:/etc/unbound/unbound.conf.d# service unbound restart
root@pihole2:/etc/unbound/unbound.conf.d# ps -ef  | grep unb
unbound     8091       1  0 20:56 ?        00:00:00 /usr/sbin/unbound -d -p
root        8093     537  0 20:56 pts/1    00:00:00 grep --color=auto unb
root@pihole2:/etc/unbound/unbound.conf.d# dig pi-hole.net @127.0.0.1 -p 5335

; <<>> DiG 9.18.28-0ubuntu0.22.04.1-Ubuntu <<>> pi-hole.net @127.0.0.1 -p 5335
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 55935
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;pi-hole.net.                   IN      A

;; ANSWER SECTION:
pi-hole.net.            300     IN      A       3.18.136.52

;; Query time: 146 msec
;; SERVER: 127.0.0.1#5335(127.0.0.1) (UDP)
;; WHEN: Sun Oct 20 20:56:32 UTC 2024
;; MSG SIZE  rcvd: 56

root@pihole2:/etc/unbound/unbound.conf.d# 
```

* Per [same instructions](https://docs.pi-hole.net/guides/dns/unbound/), set edns-packet-max .  It's not clear (to me at least) why.
```
root@pihole2:/etc/unbound/unbound.conf.d# ls /etc/dnsmasq.d              
01-pihole.conf  06-rfc6761.conf
root@pihole2:/etc/unbound/unbound.conf.d# cat > /etc/dnsmasq.d/99-edns.conf
edns-packet-max=1232
root@pihole2:/etc/unbound/unbound.conf.d#    
```

* Per [same instructions](https://docs.pi-hole.net/guides/dns/unbound/), use browser interface to configure pi-hole to use "unbound" as recursive dns server.

* Browse web from client to test.

* Reboot proxmox container to make sure that pi-hole and unbound both start up automatically.

## Try pi-hole for the rest of the network.

* Log in to your router and configure DNS for the LAN to use the pi-hole.
* NOTE: With this change in place, DNS queries still go the the router by default but then get forwarded to the pi-hole DNS server.
<img src= "{{site.baseurl}}/assets/2024-10-20__getting-up-to-speed-with-pi-hole//router_settings_for_pihole.jpg" alt="your-image-description" style="border: 2px solid grey;">

* Test multiple clients, with and without ad blocking, to make sure the internet is still accessible.  

## How well does it work?

* The Good
    * Chrome & firefox browsers on computer, phone, tablet:  ads blocked.
    * Pinterest app on android tablet: ads blocked.
    * Youtube app on android tablet: ads blocked.
    * Youtube (streaming video with ads) on roku:   many but not all ads blocked.
* The Bad
    * Some videos on cnn.com no longer play with ad blocking enabled.
* The Disappointing
    * Prime video (streaming video with ads) on roku:   ads appear as before.
    * Tubi (streaming video with ads) on roku:   ads appear as before.
