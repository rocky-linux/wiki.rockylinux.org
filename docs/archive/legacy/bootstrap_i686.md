---
title: Bootstrap i686
---

Koji, by default, does not build packages as multiarch, it expects a i686 repo/buildroot as that is what **mock** expects. It appears that it requires a 32 bit bootstrap to start off. However, Enterprise Linux 8 does **not** have a 32 bit repo. To get around this, packages have to be bootstrapped using at least Fedora 28 (and Fedora 29 for couple of instances).

## Setup

### Install Mock and Configuration

Install mock...

```
% yum install epel-release
% yum install mock createrepo_c httpd -y
% useradd rpmbuild
% usermod -aG mock rpmbuild
```

Add a proper mock configuration...

```
% cat >> /etc/mock/rocky-8-i686.cfg << "EOF"
# A lot of these values do not matter as they will be overridden later
# with koji's mock settings
config_opts['root'] = 'rocky-8-i686'
config_opts['target_arch'] = 'i686'
config_opts['legal_host_arches'] = ('i386', 'i486', 'i586', 'i686', 'x86_64',)
config_opts['chroot_setup_cmd'] = 'install bash bzip2 coreutils cpio diffutils system-release findutils gawk gcc gcc-c++ grep gzip info make patch redhat-rpm-config rpm-build sed shadow-utils tar unzip util-linux which xz'
config_opts['dist'] = 'el8'  # only useful for --resultdir variable subst
config_opts['macros']['%dist'] = ".el8"
config_opts['%centos_ver'] = "8"
config_opts['macros']['%centos_ver'] = "8"
config_opts['macros']['%rhel'] = "8"
config_opts['macros']['%el8'] = "1"
config_opts['macros']['%redhat'] = "8"
config_opts['macros']['%_vendor'] = "redhat"
config_opts['macros']['%_vendor_host'] = "redhat"
config_opts['macros']['%_host'] = "i686-redhat-linux-gnu"
config_opts['macros']['%vendor'] = "Rocky Linux"
config_opts['macros']['%packager'] = "Louis Abel <label@rockylinux.org>"
#config_opts['package_manager'] = 'yum'

# no ccache in base repo
#config_opts['plugin_conf']['ccache_enable'] = False
#config_opts['plugin_conf']['yum_cache_enable'] = False

config_opts['yum.conf'] = """
[main]
cachedir=/var/cache/yum
keepcache=1
debuglevel=2
reposdir=/dev/null
logfile=/var/log/yum.log
retries=20
obsoletes=1
gpgcheck=0
assumeyes=1
syslog_ident=mock
syslog_device=

exclude=*.x86_64 

# We are using Fedora 28 or 29 as our bases. 28 is what we use mainly. There are
# a few cases where I needed 29 instead, but they were far and few between.

# In majority of builds now with the current bootstrap, Fedora is rarely used.
# Even though this is the case, we still need to exclude specific packages as
# they have epochs or dnf decides to use Fedora instead for whatever reason.

[base_29]
name=fedora 29 base
baseurl=https://archives.fedoraproject.org/pub/archive/fedora-secondary/releases/29/Everything/i386/os/
enabled=0
gpgcheck=0
cost=2000
exclude=gcc*,fedora-release*,gdbm-devel,gdbm,gdbm-libs,python3-libs,unbound*,gnutls*,python*,generic-release,fedora-repos,fedora-gpg-keys,perl*

[updates_29]
name=fedora 29 updates
baseurl=https://archives.fedoraproject.org/pub/archive/fedora-secondary/updates/29/Everything/i386/
enabled=0
gpgcheck=0
cost=2000
exclude=gcc*,fedora-release*,gdbm-devel,gdbm,gdbm-libs,python3-libs,unbound*,gnutls*,python*,generic-release,fedora-repos,fedora-gpg-keys,perl*

[base_28]
name=fedora 28 base
baseurl=https://archives.fedoraproject.org/pub/archive/fedora-secondary/releases/28/Everything/i386/os/
enabled=1
gpgcheck=0
cost=2000
priority=99
exclude=gcc*,fedora-release*,gdbm-devel,gdbm,gdbm-libs,python3-libs,unbound*,gnutls*,python*,generic-release,fedora-repos,fedora-gpg-keys,perl*

[updates_28]
name=fedora 28 updates
baseurl=https://archives.fedoraproject.org/pub/archive/fedora-secondary/updates/28/Everything/i386/
enabled=1
gpgcheck=0
cost=2000
priority=99
exclude=gcc*,fedora-release*,gdbm-devel,gdbm,gdbm-libs,python3-libs,unbound*,gnutls*,python*,generic-release,fedora-repos,fedora-gpg-keys,perl*

# These aren't ever used, but it doesn't hurt to have them here disabled.
[modular]
name=fedora 28 modular
baseurl=https://archives.fedoraproject.org/pub/archive/fedora-secondary/releases/28/Modular/i386/os/
enabled=0
gpgcheck=0
cost=2500

[modular_updates]
name=fedora 28 modular updates
baseurl=https://archives.fedoraproject.org/pub/archive/fedora-secondary/updates/28/Modular/i386/
enabled=0
gpgcheck=0
cost=2500

# Sometimes I enable this, but usually I just copy what's there into /reqs and
# createrepo.
[i686]
name=i686 only
baseurl=file:///var/www/html/src/i686
enabled=0
gpgcheck=0
cost=1000

# Everything we're building into a single repo. This has higher priority.
[recursive]
name=recursive
baseurl=file:///var/www/html/src/reqs
enabled=1
gpgcheck=0
cost=1000
priority=1
module_hotfixes=0
"""
```

### Setup the recursive repo

So we can create an empty repo so mock/dnf is ok with that. However, that won't cut everything. We need a couple RPM's first. We can pull the noarch packages that centos has right now to get us started.

```
% mkdir -p /var/www/html/src/{reqs,logs,mirror,hidden}

# Pull required RPM's
% wget http://mirror.centos.org/centos/8.3.2011/AppStream/x86_64/os/Packages/redhat-rpm-config-123-1.el8.noarch.rpm

# Generate repo data
% createrepo /var/www/html/src/reqs
```

### Pull required hidden deps

We still need some hidden dependencies. And a lot of these can be built without a problem after the above has been setup. Below is a list, which can be found on our [temporary copr](https://copr.fedorainfracloud.org/coprs/nalika/rockylinux-tools/packages/). You should download the source RPM's and build them.

You won't find a rocky-logos or rocky-release in copr. However you may find them in our koji. Highly recommended downloading them from [koji](https://kojidev.rockylinux.org) and building them.

```
-rw-r--r-- 1 root root    569161 Apr  7 04:09 atf-0.20-11.el8.src.rpm
-rw-r--r-- 1 root root   2198827 Apr  7 04:01 fonttools-3.28.0-2.el8.src.rpm
-rw-r--r-- 1 root root    670398 Apr  7 04:34 kyua-0.13-1.el8.src.rpm
-rw-r--r-- 1 root root 149325484 Mar 15 22:41 libabigail-1.4-2.el8.src.rpm
-rw-r--r-- 1 root root    500728 Apr  7 04:19 lutok-0.4-10.el8.src.rpm
-rw-r--r-- 1 root root   1107360 Aug  7  2020 nspr-4.25.0-2.el8_2.src.rpm
-rw-r--r-- 1 root root 143424626 Apr  8 06:56 nss-3.53.1-17.el8.src.rpm
-rw-r--r-- 1 root root    100839 Mar 14 22:38 pam_wrapper-1.0.7-1.el8.src.rpm
-rw-r--r-- 1 root root    149272 Dec 21 03:56 polkit-gnome-0.106-0.2.20170423gita0763a2.el8.src.rpm
-rw-r--r-- 1 root root   1507527 Mar 15 17:38 rocky-logos-83.0-1.el8.src.rpm
-rw-r--r-- 1 root root     23678 Apr  9 04:04 rocky-release-8.3-5.el8.src.rpm
-rw-r--r-- 1 root root   3527211 Apr  7 03:52 ttfautohint-1.8.1-3.el8.src.rpm
```

### Optional: Pull all the sources from the vault

You may need to pull all the sources from the vault. I used [httrack](https://rocky.shootthej.net/src/custom/httrack-3.49.2-8.el8.x86_64.rpm) to do this. Note that the link may die and you may need to build it yourself.

Another thing is, after I pulled down the sources, I deleted all the old stuff and moved all the module packages.

```
% cd /var/www/html/src/mirror
# -sN 0 helps ignore robots
% httrack https://vault.centos.org/8.3.2011/BaseOS/Source/SPackages/ -sN 0
% httrack https://vault.centos.org/8.3.2011/AppStream/Source/SPackages/ -sN 0
% httrack https://vault.centos.org/8.3.2011/HighAvailability/Source/SPackages/ -sN 0
% httrack https://vault.centos.org/8.3.2011/PowerTools/Source/SPackages/ -sN 0

# Now we need to move some things
% mv vault.centos.org/8.3.2011/BaseOS/Source/SPackages/ BaseOS
% mv vault.centos.org/8.3.2011/AppStream/Source/SPackages/ AppStream
% mv vault.centos.org/8.3.2011/HighAvailability/Source/SPackages/ HighAvailability
% mv vault.centos.org/8.3.2011/PowerTools/Source/SPackages/ PowerTools
% rm -rf vault.centos.org index.html

# I don't want to build modules. I'm doing that in koji, so instead, I'm moving them away.
% mkdir modules
% find . -type f -regextype sed -regex '.*module.*\.rpm' -exec mv {} modules/ \;

# Now I need to remove all the old stuff
# You can use repomanage on directories that are not actual repos and it will operate properly.
% for x in AppStream BaseOS HighAvailability PowerTools ; do rm $(repomanage --keep=1 ${x}) ; done
```

### Actually build

I have a kind of hacky script that takes care of this for me. You can feed it one at a time.

```
# ~/bin/build-a-rpm
#!/bin/bash
PACKAGE=$1
LOGDIR=/var/www/html/src/logs/${NAME//.src.rpm/}
MOCKDIR=/var/lib/mock/rocky-8-i686
mock -r rocky-8-i386 $1

if [ $? -eq 0 ]; then
  rm ${MOCKDIR}/result/*.src.rpm
  cp ${MOCKDIR}/result/*.rpm /var/www/html/src/reqs
  createrepo /var/www/html/src/reqs
  echo $1 >> /tmp/DONE
else
  mkdir ${LOGDIR}
  cp ${MOCKDIR}/result/*.log ${LOGDIR}
  echo $1 >> /tmp/FAIL
fi
```

```
% build-a-rpm /var/www/html/src/mirror/BaseOS/tar-1.30-5.el8.src.rpm
```
