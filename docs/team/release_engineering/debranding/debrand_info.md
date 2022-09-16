---
title: Debranding Information
---

This page goes over the methodology and some packages that require changes to their material for acceptance in Rocky Linux. Usually this means there is some text or images in the package that reference upstream trademarks, and these must be swapped out before we can distribute them.

CentOS had a wiki page at one point where it was documented, but it wasn't always up to date. For example, the package **nginx** did not appear on their list, and still had RHEL branding in the CentOS repos. As a result, this forced us to do a deeper investigation into what needs to be changed or altered.

There are a few ways we've determined some of the changes:

* Packages don't build because ID is not `centos`, `rhel`, or `fedora`
* Packages have `?centos` tags in the SPEC file to differentiate from Fedora or RHEL
* Some packages in git.centos.org have an automatic debranding message - This won't be as helpful for 9 and beyond
* RHEL assets were appearing in the installed package(s)

When we need to make changes, it can possibly be one or more of these things:

* URL's should change from Red Hat to a Rocky page (if applicable)
* URL's that are being patched to be Red Hat should be removed (systemd in 8 is an example of this)
* `?centos` is changed to `?rocky`, but this isn't always consistent or sufficient
* Assets need to be changed

    * Exceptions come when there is a file being requested from the logos package - We generally have symlinks to deal with this

* Some patches must be made to the source code or spec file
* Packages are built against an "override" release package that uses `ID="rhel"` in `/etc/os-release` to force a build to pose as RHEL (older versions of dotnet and chrony are an example of this)

Current patches (for staging) are [here](https://git.rockylinux.org/staging/patch).

## Packages that need debranding changes:

There is a metadata file that helps track this information for us. It can be located [here](https://git.rockylinux.org/rocky/metadata/-/blob/main/patch.yml) and is separated by section and branch.

In essence, the file goes over these sections:

* `build_patch` -> Packages that may have needed patches to build properly in our environment
* `dnt` or **D**o **N**ot **T**ouch -> These should not be modified or changed
* `custom` -> Custom packages not provided by upstream but can be useful in obsoleting packages or providing some functionality
* `plus` -> Packages that are modified versions of what's in the base or built by normal means but not shipped by Red Hat
* `previous` -> Packages that may have been patched before for debranding or building - They are left as a reference
* `provides` -> Common provides for release, logos, and other rocky/system specific packages
* `override_required` -> Requires an "override" release package to build properly
* `spec_change_only` -> Requires only spec changes to remove functionality that is RHEL specific
* `debrand` -> Packages that are changed/patched to either remove Red Hat references, replace them, or add Rocky Linux as a supported distribution

    * Some of these packages will always need to be changed, on a minor or major release schedule.
    * Some are potentially upstreamed so then they are no longer patched by us (sos is an example)
    * Some packages may still need modification, even if upstreamed (anaconda is an example)

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
