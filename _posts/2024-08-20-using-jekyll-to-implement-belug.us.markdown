---
layout: post
title: "Using jekyll to implement belug.us"
date: 2024-08-20 18:21:06 +0000
published: true
github_comments_issueid: "39"
tags:
---

In the August 15 meeting one of the topics was static site generators.   We discussed what it would take to implement [belug.us](https://belug.us) or something similar using a static site generator.  As an exercise/demonstration, I created a site similar to belug.us using jekyll.  I did this by forking [jekyll/minima](https://github.com/jekyll/minima) as [belug.us](https://github.com/dc25/belug.us) and editing it until I was happy with the [results](https://dc25.github.io/belug.us/).

The following steps resulted in a site resembling the [belug.us site](https://belug.us/).


* Clone repo to belug.us (on local machine).   Run jekyll server to monitor changes along the way.
* Change site name in _config.yml file to "Bellevue Linux Users Group"
* Change index.md layout (in front matter) from home layout to page layout.   This gets blog posts off of front page.
* Create about.md, faq.md and meetings.md as copies of about.md.   Change title and permalink in frontmatter.  Add both to _config.yml
* Cut and pasted content from belug.us to the appropriate markdown files (index.md, about.md, faq.md & meetings.md).
* Add screen.css (downloaded from belug.us site) to _sass directory as screen.sccs. Include this file from minima/custom-styles.scss
* Add images bg_large.jpg and bg_grad.png (downloaded from belug.us site) to assets/img directory.
* Introduce two new divs in _layouts/base.html with class "content" and class "container" .   These classes are referenced from screen.css.   With these divs in place, the site starts to look like belug.us
* Other minor adjustments to markdown and css to improve look & feel.
* Added _data/meetings.yml to hold meeting dates.

You can see the resulting page [here](https://dc25.github.io/belug.us).   It's not identical to [belug.us](https://belug.us) but it's pretty close.  Most of the content is contained in these four markdown (and one data) files:

* [index.md](https://raw.githubusercontent.com/dc25/belug.us/main/index.md)
* [about.md](https://raw.githubusercontent.com/dc25/belug.us/main/about.md)
* [meetings.md](https://raw.githubusercontent.com/dc25/belug.us/main/meetings.md)
* [faq.md](https://raw.githubusercontent.com/dc25/belug.us/main/faq.md)
* [meetings.yml](https://raw.githubusercontent.com/dc25/belug.us/main/_data/meetings.yml)

My intention for this demo was to minimize changes made after cloning the jekyll/minima repository so I left some content in the repository that could be deleted.  

