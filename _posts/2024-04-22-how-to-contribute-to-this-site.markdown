---
layout: post
title: "How to Contribute to This Site"
date: 2024-04-22 22:19:43 +0000
published: true
# github_comments_issueid: "create an issue and specfiy the issue id here"
tags:
---

Contribute a new page of content as follows....

------------------
First, log in to github as yourself and fork [the github repo for this site](https://github.com/homeservernotes/homeservernotes.info).   I'm assuming basic knowledge of github here.

------------------
Then clone your fork to your local directory:

![image tooltip here](/assets/2024-04-22--contributing/Screenshot from 2024-04-22 15-15-58.png)

------------------
Then execute the following podman command in the cloned directory:
![image tooltip here](/assets/2024-04-22--contributing/Screenshot from 2024-04-22 15-17-07.png)

------------------
This will start two tmux windows.  In one, a server will be running.  The other is available for content creation.
![image tooltip here](/assets/2024-04-22--contributing/Screenshot from 2024-04-22 15-17-19.png)


------------------
In a browser, go to localhost:4000 to see the content served:
![image tooltip here](/assets/2024-04-22--contributing/Screenshot from 2024-04-22 15-18-40.png)


------------------
Use "rake" to create a new page:
![image tooltip here](/assets/2024-04-22--contributing/Screenshot from 2024-04-22 15-19-53.png)

------------------
Refresh the browser window to see the new page:
![image tooltip here](/assets/2024-04-22--contributing/Screenshot from 2024-04-22 15-20-07.png)


------------------
Use vim to edit the new page ( find it in the _posts subdirectory ):
![image tooltip here](/assets/2024-04-22--contributing/Screenshot from 2024-04-22 15-21-38.png)

------------------
Use the browser to check your work.
![image tooltip here](/assets/2024-04-22--contributing/Screenshot from 2024-04-22 15-22-12.png)

------------------
Make additional edits as needed.

------------------
When you're done editing, exit the podman container and use git add, git commit, git push to upload your edits to github.


![image tooltip here](/assets/2024-04-22--contributing/Screenshot from 2024-04-22 16-00-49.png)

------------------
From inside your browser go to github and make a pull (merge) request to move the changes to the homeservernotes account.


------------------

Wait for the changes to be merged.   ( I'll try to repond to pull requests ASAP ).
