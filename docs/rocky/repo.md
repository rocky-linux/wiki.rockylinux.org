---
title: Rocky Linux Repositories
---

There are several repositories that are provided by Rocky Linux and may differ between major releases. There are also community approved repositories as well, installable typically from the extras repository.

## About 'enabled' and 'disabled' repository configuration files

Please read `man 5 dnf.conf`, in particular the section of `enabled` under the `REPO` section. A line containing `enabled=0` or `enabled=1` will disable or enable a repository. This can also be modified using `dnf config-manager --set-enabled` or `--set-disabled`. When this is done, it is recommended to run `dnf clean all`.

## Version Policy

During a minor release lifecycle as a package receives updates, the previous version will coexist in the repositories to allow a user to downgrade in case of a regression or other use cases (such as security only updates). Upon new minor release, all previous updates/versions that are *not* the latest are not carried over.

Rocky Linux 9 does not currently support this policy.

## Base Repositories

Each major release has a set of repositories that come default with the distribution. Below is a list of common repositories for each major release. As of October 12, 2021, "Rocky 9" is projected information based on CentOS Stream 9.

| Repository       | Rocky 8 | Rocky 9 | Enabled |
|------------------|---------|---------|---------|
| BaseOS           | Yes     | Yes     | Yes     |
| AppStream        | Yes     | Yes     | Yes     |
| PowerTools       | Yes     | No      | No      |
| CRB              | No      | Yes     | No      |
| HighAvailability | Yes     | Yes     | No      |
| ResilientStorage | Yes     | Yes     | No      |

### Notes on: CRB

CRB is "Code Ready Builder" - PowerTools was a carryover from CentOS. Based on information from CentOS Stream 9, we will be listing it as CRB going forward in Rocky 9.

### Notes on: Lack of "updates" repo

In older major versions, it was normal to have an "updates" repo. Fedora for example still follows this. However, in EL8, EL9, and likely so on, there is no "updates" repository. This means all updates happen as is in the same repository. So if `bash` receives an update, it will land in `baseos` as there is no updates repository.

## Extra Repositories

There are extra repositories offered by Rocky Linux.

| Repository       | Rocky 8 | Rocky 9 | Enabled |
|------------------|---------|---------|---------|
| Extras           | Yes     | Yes     | Yes     |
| Plus             | Yes     | Yes     | No      |
| RT (real time)   | Yes     | Yes     | No      |
| NFV              | Yes     | TBD     | No      |
| SAP / SAP HANA   | No      | TBD     | No      |
| Devel / devel    | Yes     | Yes     | No      |
| rockyrpi         | Yes\*   | Yes\*   | No      |

### Notes on: Extras

This repository contains packages that provide some additional functionality to Rocky without breaking upstream compatibility. For example, `rpaste` used for sending logs, configuration, or system information to our paste bin.

These are not tested by upstream nor available in the upstream product.

### Notes on: Plus

This repository contains packages that either A) replace a core component via patched functionality, B) build a component that was originally exclusive for one architecture (eg open-vm-tools built for x86_64 but not aarch64 in Rocky 8) or C) providing packages that were built but not traditionally provided by upstream.

Packages that fall under A and B will have a `.plus` added to their version tag. These are not tested nor available in the upstream product.

### Notes on: rockyrpi

The rockyrpi repository is being/has been moved to a SIG repository. It'll no longer be found in the base Rocky Linux repository directories.

## Vault

Previous releases, including ISOs and other images, are typically moved into a vault area of our tier 0 mirror once a new minor release version is available for at least a week. The vault can be found [here](https://dl.rockylinux.org/vault/rocky).

Note that these versions are not supported and not recommended for general use.

## Community Approved Repositories

As with Enterprise Linux and Fedora, there are additional community approved repositories for Rocky Linux. Below are repositories that are approved by Rocky Linux as well as the community.

| |
| - |
| **Extra Packages for Enterprise Linux (EPEL)** - [EPEL](http://fedoraproject.org/wiki/EPEL) is by for the most commonly used repository for Enterprise Linux. EPEL provides rebuilds of Fedora packages for every supported enterprise linux. Packages in this repository do not replace the base. You can install EPEL by running `dnf install epel-release` and the package will be installed from the extras repository. The package will automatically have EPEL enabled. Support for EPEL can be found in `#epel` on Libera. |
| **Community Enterprise Linux Repository (ELRepo)** - [ELRepo](http://elrepo.org/) focuses on newer kernels and kmod driver packages to enhance hardware support for EL8 and beyond. This includes display, filesystem, network, storage drivers. You can install the necessary repo files by running `dnf install elrepo-release`. Note that the kernel repositories will have to be enabled. |
| **RPM Fusion** - [RPM Fusion](https://rpmfusion.org/) provides software that the Fedora Project or Red Hat does not want to ship in Enterprise Linux and Fedora. These repositories do rely on EPEL. The policy is to **not** replace EPEL nor base packages. The free repository can be installed by running `dnf install rpmfusion-free-release`. |
| **Remi Repository** - [Remi](http://rpms.remirepo.net/) maintains a large collection of RPMs, including latest versions of PHP, among other things. His FAQ can be found [here](http://blog.remirepo.net/pages/English-FAQ). This is a collection of repositories. Using the `-safe` series of repositories will ensure that nothing from the base will be replaced or overwritten. However, be aware that these repositories do **not** play well with other third party repositories. You will need to use caution as you enable more repositories on your system. |
| **GhettoForge** - [GhettoForge](http://ghettoforge.org/) provides packages not in other third party repositories. Packages that overwrite the base would be in the `gf-plus` repository. Please see [usage](http://ghettoforge.org/index.php/Usage) for more information. |
| **Upstream centos-release-*** - In the extras repository, there are `centos-release-*` packages that provide additional repositories from the Special Interest Groups of CentOS. As they are available in extras and should work on Rocky Linux, they are considered approved and community supported. |
