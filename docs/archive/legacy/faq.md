---
title: Frequently Asked Questions
---
Hello! You were likely directed here as an answer to your question in our Mattermost, IRC channels, or forums. It is likely your question is asked frequently. Below, we have the most common questions we receive and their accompanying answers.

### What license is Rocky Linux released under?

3-Clause BSD

### Where is the "code" and/or build instructions for your docker image?

There is no "code" for the docker image we provide (as of Rocky Linux 8). A rootfs archive is created using imagefactory and extracted within a scratch container.

The docker file is located [here](https://github.com/rocky-linux/sig-cloud-instance-images/blob/Rocky-8.4-x86_64/Dockerfile)

### How is Rocky Linux made?

Skip, a member of Release Engineering, has been spending time doing a write up of how Rocky Linux 8 is currently built, which includes information on the various tools (koji, pungi, MBS, git, et al) and how they all come together. You can view it [here](https://skip.linuxdn.org/blog.html#bloghome)
