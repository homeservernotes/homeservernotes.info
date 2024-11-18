---
layout: post
title: "Today I Learned:  tailscale keys expire after 180 days"
date: 2024-11-17 16:02:30 -0800
published: true
github_comments_issueid: "52"
tags:
---

After using tailscale for (I assume) 180 days, one of my nodes stopped responding through the tailscale domain name.   I logged in to the tailscale dashboard and saw that the key for that node had expired and needed to be refreshed.  Tailscale documentation says that this happens after 180 days.   Here's the [relevant documentation](https://tailscale.com/kb/1028/key-expiry).

