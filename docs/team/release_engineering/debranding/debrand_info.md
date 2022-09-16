---
title: Debranding Information
---

This page goes over the methodology and some packages that require changes to their material for acceptance in Rocky Linux. Usually this means there is some text or images in the package that reference upstream trademarks, and these must be swapped out before we can distribute them.

CentOS had a wiki page at one point where it was documented, but it wasn't always up to date. For example, the package **nginx** did not appear on their list, and still has RHEL branding in the CentOS repos. As a result, this forced us to do a deeper investigation into what needs to be changed or altered.

There are a few ways we've determined some of the changes:

* Packages don't build because ID is not `centos`, `rhel`, or `fedora`
* Packages have `?centos` tags in the SPEC file to differentiate from Fedora or RHEL
* Some packages in git.centos.org have an automatic debranding message - This won't be as helpful for 9 and beyond

When we need to make changes, it can possibly be one or more of these things:

* URL's should change from Red Hat to a Rocky page (if applicable)
* URL's that are being patched to be Red Hat should be removed (systemd is an example of this)
* `?centos` is changed to `?rocky`, but this isn't always consistent or sufficient
* Assets need to be changed

    * Exceptions come when there is a file being requested from the logos package - We generally have symlinks to deal with this

* Some patches must be made to the source code or spec file

Current patches (for staging) are [here](https://git.rockylinux.org/staging/patch).

## Packages that need debranding changes:

There is a metadata file that tracks this for us. It can be located [here](https://git.rockylinux.org/rocky/metadata/-/blob/main/patch.yml). The section in particular is called `debrand`.

## Packages that need to become other packages:

There is a metadata file that tracks this for us. It can be located [here](https://git.rockylinux.org/rocky/metadata/-/blob/main/patch.yml). The section in particular is called `provides`.

This is for example, `redhat-logos` or `system-logos` is provided or "becomes" `rocky-logos`.

## Packages that Exist in RHEL, but do not exist in most derivatives
For sake of complete information, here is a list of packages that are in RHEL, but may not exist in derivatives.  We do not need to worry about these packages:

- insights-client
- Red_Hat_Enterprise_Linux-Release_Notes-8-*
- redhat-access-gui
- redhat-bookmarks
- rhc
- rhc-worker-playbook
- subscription-manager-migration
- subscription-manager-migration-data
