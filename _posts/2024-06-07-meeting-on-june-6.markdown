---
layout: post
title: "Meeting on June 6"
date: 2024-06-07 20:29:26 +0000
published: true
github_comments_issueid: "23"
tags:
---
## Overview
The group met on zoom.  Ten people attended.   

## Topics
* One of the participants was unable to access some files on a truenas server from a Windows machine.   The meeting started out with a discussion about what might be causing these access problems.     
* We eventually diagnosed the problem as a Windows permissions problem perhaps caused by the files in question being created by one user and then accessed by a different user.
* The solution that we arrived at was to use Windows to recursively change the file permissions to allow access.
* The fix worked but is not perfect.   Ideally the permissions used to read and write the files should work without any changes after the fact.
* This concern led to a discussion about differences between Linux and Windows file permissions, owner/group/other (on Linux), Access Control List's (aka ACL's) on Windows, ACL's on Linux(!), ACL's on Samba, etc.

