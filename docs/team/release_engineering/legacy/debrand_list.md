---
title: Rocky Debrand Packages List
---

This is a list of packages that require changes to their material for acceptance in Rocky Linux.  Usually this means there is some text or images in the package that reference upstream trademarks, and these must be swapped out before we can distribute them.

The first items in this list are referenced from the excellent CentOS release notes here:  https://wiki.centos.org/Manuals/ReleaseNotes/CentOS8.1905#Packages_modified_by_CentOS

It is assumed that we will have to modify these same packages.  It is also assumed that these changed packages might not necessarily be debranding.

However, this list is incomplete.  For example, the package **Nginx** does not appear on the list, and still has RHEL branding in the CentOS repos.  We will need to investigate the rest of the package set and find any more packages like this that we must modify.

One way to find said changes is to look for `?centos` tags in the SPEC file, while also looking at the manual debranding if there was any for the `c8` branches.

There will be cases where a search and replace for `?centos` to `?rocky` will be sufficient.

Current patches (for staging) are [here](https://git.rockylinux.org/staging/patch).


## Packages that need debranding changes:

| Package  | Notes | Work Status  |
|:--------|--------------|-------------------------|
| abrt | See [here](https://git.rockylinux.org/staging/patch/abrt) | **DONE** |
| anaconda | See [here](https://git.rockylinux.org/staging/patch/anaconda) | **DONE** |
| apache-commons-net | AppStream module with elevating branch names | NO CHANGES REQUIRED |
| ~~basesystem~~ | (does not require debranding, it is a skeleton package) | NO CHANGES REQUIRED |
| cloud-init | See [here](https://git.rockylinux.org/staging/patch/cloud-init) | **DONE** - NEEDS REVIEW IN GITLAB (Rich Alloway) |
| cockpit | See [here](https://git.rockylinux.org/staging/patch/cockpit) | **DONE** |
| ~~compat-glibc~~ | | NOT IN EL 8 |
| dhcp | See [here](https://git.rockylinux.org/staging/patch/dhcp) | **DONE**, NEEDS REVIEW IN GITLAB (Rich Alloway) |
| firefox | See [here](https://git.rockylinux.org/staging/patch/firefox) -- Still requires a distribution.ini ID | **MOSTLY DONE** (Louis) |
| fwupdate | | NOT STARTED |
| glusterfs | Changes don't appear to be required | NO CHANGES REQUIRED |
| gnome-settings-daemon | No changes required for now. | NO CHANGES REQUIRED |
| grub2 | (secureboot patches not done, just debrand) See [here](https://git.rockylinux.org/staging/patch/grub2) | **DONE**, NEEDS REVIEW IN GITLAB AND SECUREBOOT (Rich Alloway) |
| httpd | See [here](https://git.centos.org/rpms/httpd/c/2f74eecf85362e67c403b7b1386a729da3e5c33d?branch=c8-stream-2.4) | **DONE** |
| initial-setup | See [here](https://git.rockylinux.org/staging/patch/initial-setup) | **DONE** |
| ipa | This is a dual change: Logos and ipaplatform. Logos are taken care of in `rocky-logos` and the `ipaplatform` is taken care of here. See [here](https://git.rockylinux.org/staging/patch/ipa) | **DONE** |
| ~~kabi-yum-plugins~~ | | NOT IN EL 8 |
| kernel | See [here](https://git.centos.org/rpms/kernel/c/20287bd53a5c2e87db2470380271b72ac8a1ed59?branch=c8) for a potential example | NOT STARTED |
| ~~kde-settings~~ | | NOT IN EL 8 |
| libreport | See [here](https://git.rockylinux.org/staging/patch/libreport) | **DONE** |
| oscap-anaconda-addon | See [here](https://git.rockylinux.org/staging/patch/oscap-anaconda-addon) | **DONE** Requires install QA |
| PackageKit | See [here](https://git.rockylinux.org/staging/patch/PackageKit) | **DONE** |
| ~~pcs~~ | | NO CHANGES REQUIRED |
| plymouth | See [here](https://git.rockylinux.org/staging/patch/plymouth) | **DONE** |
| ~~redhat-lsb~~ | | NO CHANGES REQUIRED |
| redhat-rpm-config | See [here](https://git.rockylinux.org/staging/patch/redhat-rpm-config) | **DONE** |
| scap-security-guide | QA is likely required to test this package as it is | NO CHANGES REQUIRED, QA REQUIRED |
| shim | | NOT STARTED |
| shim-signed | | NOT STARTED |
| sos | See [here](https://git.rockylinux.org/staging/patch/sos) | **DONE** |
| subscription-manager | See [here](https://git.rockylinux.org/staging/patch/subscription-manager) | **DONE**, NEEDS REVIEW |
| ~~system-config-date~~ | | NOT IN EL8 |
| ~~system-config-kdump~~ | | NOT IN EL8 |
| thunderbird | See [here](https://git.rockylinux.org/staging/patch/thunderbird) | **DONE** |
| ~~xulrunner~~ | | NOT IN EL 8 |
| ~~yum~~ | | NO CHANGES REQUIRED |
| **(end of CentOS list)**
| nginx | Identified changes, in staging | (ALMOST) **DONE** |

## Packages that need to become other packages:
We will want to create our own versions of these packages.  The full "lineage" is shown, from RHEL -> CentOS -> Rocky (Where applicable)

| Package  | Notes |
|:--------|--------------|
| redhat-indexhtml -> centos-indexhtml -> rocky-indexhtml | [Here](https://git.rockylinux.org/original/rpms/rocky-indexhtml) |
| redhat-logos -> centos-logos -> rocky-logos | [Here](https://git.rockylinux.org/original/rpms/rocky-logos) |
| redhat-release-*  -> centos-release -> rocky-release | [Here](https://git.rockylinux.org/original/rpms/rocky-release) |
| centos-backgrounds -> rocky-backgrounds | Provided by [logos](https://git.rockylinux.org/original/rpms/rocky-logos) |
| centos-linux-repos -> rocky-repos | [Here](https://git.rockylinux.org/original/rpms/rocky-repos) |
| centos-obsolete-packages | [Here](https://git.rockylinux.org/original/rpms/rocky-obsolete-packages) |

## Packages that Exist in RHEL, but not in CentOS
For sake of complete information, here is a list of packages that are in RHEL 8, but do not exist in CentOS 8.  We do not need to worry about these packages:

- insights-client
- Red_Hat_Enterprise_Linux-Release_Notes-8-*
- redhat-access-gui
- redhat-bookmarks
- subscription-manager-migration
- subscription-manager-migration-data
