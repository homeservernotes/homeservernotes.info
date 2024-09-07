---
layout: post
title: "Jekyll quickstart"
date: 2024-09-06 22:44:26 +0000
published: true
github_comments_issueid: "42"
tags:
---

In the Septemeber 5 meeting we did a walkthrough of how to build a simple website with jekyll.  This post goes through that process.   As a rough overview, the steps are:
* Update your computer with the necessary utilities (npm, node, some other npm related utilities).
* Clone the jekyll/minima repository.
* Prepare the minima repository with the necessary dependencies.
* Run jekyll to either serve or build the site.

In more detail:

# Update your computer as needed.

First bring the OS up to date.   I'm using Ubuntu in this example so the package manager is apt.
```
dev@xela:~/workdir$ sudo apt update -y                                                      
dev@xela:~/workdir$ sudo apt upgrade -y
```

Install the utilities needed to support jekyll:
```
dev@xela:~/workdir$ sudo apt install -y npm ruby-dev ruby-bundler zlib1g-dev
Reading package lists... Done
```

Bring npm and node up to the latest versions:
```
dev@xela:~/workdir$ sudo npm install -g n
added 1 package in 279ms
```

```
dev@xela:~/workdir$ sudo n latest
  installing : node-v22.8.0
       mkdir : /usr/local/n/versions/node/22.8.0
       fetch : https://nodejs.org/dist/v22.8.0/node-v22.8.0-linux-x64.tar.xz
     copying : node/22.8.0
   installed : v22.8.0 (with npm 10.8.2)

dev@xela:~/workdir$ hash -r
dev@xela:~/workdir$ node --version
v22.8.0
dev@xela:~/workdir$ npm --version
10.8.2
```

# Clone the jekyll/minima repository.


This walkthrough uses jekyll/minima which specifies a basic website but the steps should work with any jekyll site, including the [belug.us lookalike](https://github.com/dc25/belug.us) and [this site itself](https://github.com/homeservernotes/homeservernotes.info).

```
dev@xela:~/workdir$ git clone git@github.com:jekyll/minima.git
Cloning into 'minima'...
```

# Prepare the minima repository with the necessary dependencies:

```
dev@xela:~/workdir/minima$ bundle config path 'vendor/bundle' --local
dev@xela:~/workdir/minima$ bundle install
Resolving dependencies...
Fetching gem metadata from https://rubygems.org/............
```
# Use jekyll to build and serve the site:
```
dev@xela:~/workdir/minima$ bundle exec jekyll serve -H 0.0.0.0
Configuration file: /home/dev/workdir/minima/_config.yml
 Theme Config file: /home/dev/workdir/minima/_config.yml
            Source: /home/dev/workdir/minima
       Destination: /home/dev/workdir/minima/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
       Jekyll Feed: Generating feed for posts
                    done in 0.351 seconds.
 Auto-regeneration: enabled for '/home/dev/workdir/minima'
    Server address: http://0.0.0.0:4000
  Server running... press ctrl-c to stop.
[2024-09-06 22:20:52] ERROR `/favicon.ico' not found.
^C^C
```

# Or use jekyll to just build the site:

```
dev@xela:~/workdir/minima$ rm -rf _site/
dev@xela:~/workdir/minima$ bundle exec jekyll build
Configuration file: /home/dev/workdir/minima/_config.yml
 Theme Config file: /home/dev/workdir/minima/_config.yml
            Source: /home/dev/workdir/minima
       Destination: /home/dev/workdir/minima/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
       Jekyll Feed: Generating feed for posts
                    done in 0.446 seconds.
 Auto-regeneration: disabled. Use --watch to enable.
dev@xela:~/workdir/minima$ ls -rd _site/
_site/
dev@xela:~/workdir/minima$
```
# View the site in your browser.

If you use the "bundle exec jekyll serve -H 0.0.0.0" command shown above you should be able to see the site at port 4000 for any IP address the computer presents.   You can also serve the site with a server of your choice after running "bundle exec jekyll build" (also shown above).  The jekyll/minima site should look something like this:
<img src= "{{site.baseurl}}/assets/2024-09-06-jekyll-quickstart/jekyllminima.jpg" alt="your-image-description" style="border: 2px solid grey;">


# Configure as needed:

At this point you can modify the minima content to specify whatever website you want.  This is how the belug.us lookalike was created.  The details of how to do that are beyond the scope of this post.
