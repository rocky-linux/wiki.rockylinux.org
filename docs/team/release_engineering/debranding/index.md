---
title: Intro to Debranding with Rocky Linux
---

## What is Debranding?

Certain packages in the upstream RHEL/CentOS have logos, trademarks, and other specific text, images, or multimedia that other entities (like the Rocky Enterprise Software Foundation) are not allowed to redistribute.

A visible, simple example is the Apache web server (package httpd).  If you've ever installed it and visited the default web server page, you will see a test page specific to your Linux distro, complete with a "powered by" logo and distro-specific information.  While we are allowed to compile and redistribute the Apache web server software, Rocky Linux is NOT allowed to include these trademarked images or distro-specific text.

We must have an automated process that will strip these assets out and replace them with our own branding upon import into our Git.

## How Rocky Debranding Works

Rocky's method for importing packages from the upstream is a tool called **srpmproc**.

Srpmproc's purpose in life is to:

- Clone PACKAGE from our upstream source: git.centos.org/rpms/PACKAGE or gitlab.com/redhat
- Check if Rocky Linux has any debranding patches available for PACKAGE (under https://git.rockylinux.org/patch/PACKAGE)
- If patch/PACKAGE exists, then read the configuration and patches from that repository and apply them
- Commit the results (patched or not) to https://git.rockylinux.org/rpms/PACKAGE
- Do this for every package until we have a full repository of packages in our Git

## Helping with Debrands

There are 2 tasks involved with debranding: Identifying packages that require debranding and developing patches+configs to debrand the necessary packages.

If you want to help with the latter, please see the [patching guide](patching.md) for examples and a case study. If you find something that you suspect is missing branding, you can also file a [bug report](https://bugs.rockylinux.org) instead.

## Debrand Packages Tracking

A list of packages that need debranding is located in the a metadata file in our git [here](https://git.rockylinux.org/rocky/metadata/-/blob/main/patch.yml). This generally does not track status and is simply a reference on what is debranded, if it's no longer debranded (aka Rocky Linux is upstreamed), and other notes.
