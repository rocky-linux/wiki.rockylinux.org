---
title: Rocky Linux Repositories
---

There are several repositories that are provided by Rocky Linux and may differ between major releases. There are also community approved repositories as well, installable typically from the extras repository.

## About 'enabled' and 'disabled' repository configuration files

Please read `man 5 dnf.conf`, in particular the section of `enabled` under the `REPO` section. A line containing `enabled=0` or `enabled=1` will disable or enable a repository. This can also be modified using `dnf config-manager --set-enabled` or `--set-disabled`. When this is done, it is recommended to run `dnf clean all`.

## Base Repositories

Each major release has a set of repositories that come default with the distribution. Below is a list of common repositories for each major release.

| Repository       | Rocky 8 | Rocky 9 | Enabled |
|------------------|---------|---------|---------|
| BaseOS           | Yes     | Yes     | Yes     |
| AppStream        | Yes     | Yes     | Yes     |
| PowerTools / CRB | Yes     | Yes     | No      |
| HighAvailability | Yes     | Yes     | No      |
| ResilientStorage | Yes     | Yes     | No      |

Note: CRB is "Code Ready Builder" - PowerTools was a carryover from CentOS. Based on information from CentOS Stream 9 (as of October 12, 2021), it may or may not be named CRB in Rocky 9, so it is listed as such for now.

## Extra Repositories

There are extra repositories offered by Rocky Linux.

| Repository       | Rocky 8 | Rocky 9 | Enabled |
|------------------|---------|---------|---------|
| Extras           | Yes     | Yes     | Yes     |
| Plus             | Yes     | Yes     | No      |
| RT (real time)   | Yes     | Yes     | No      |
| NFV              | Yes     | N/A     | No      |
| Devel            | Yes     | Yes     | No      |
| rockyrpi         | Yes     | Yes     | No      |

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
