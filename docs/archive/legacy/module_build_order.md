---
title: Module Build Order
---

**Analysis of when to build the various modules:**

Modules consist of packages, some which require building non-modular packages (or even other modules) first.
This is an attempt to group modules with a build order list, to ensure all the packages in a given stream will build.


<br />

**Methodology**:
This list is produced by comparing a list of raw packages in a module, and the lists of succeeding packages in the build order pass lists.

When all the packages in a module complete their build, we take a note of the last/latest package to build, and which build pass that was.

The module should be built with the packages in that build pass, as that is when all packages are guaranteed to complete. (all dependencies fulfilled)


<br />

## Module Build Order List
(These modules have all their packages building successfully, and they will build properly in the listed build pass/batch)

**Build Pass 1:**
- 389-ds : 1
- freeradius : 1
- go-toolset : 1
- httpd : 1
- mailman : 1
- mercurial : 1
- perl-App-cpanminus : 1
- perl-DBD-MySQL : 1
- perl-DBD-Pg : 1
- perl-DBD-SQLite : 1
- perl-DBI : 1
- perl-FCGI : 1
- perl-YAML : 1
- php : 1
- python36 : 1
- redis : 1
- squid : 1
<br />

**Build Pass 2:**
- inkscape : 2
- javapackages-runtime : 2

<br />

**Build Pass 3:**
- gimp : 3

<br />

**Build Pass 4:**
- ant : 4
- mod-auth-openidc : 4
- postgresql : 4

<br />

**Build Pass 6:**
- mariadb : 6

<br />

**Build Pass 9:**
- mysql : 9
- parfait : 9
- perl-IO-Socket-SSL : 9
- perl-libwww-perl : 9


<br />

## Unsure Modules
(These modules still have packages failing, so we are not 100% sure which build pass they should go in)
```
container-tools : unsure
idm  : 6...?
javapackages-tools : 9+
jmc : 9+
llvm-libs : 1, but i686 packages failed (should be ok w/ MBS?)
maven : 9+
nginx : 2?  (only 1 version not building)
nodejs : almost nothing built yet
perl : 10+ (most built by 9)
pki-core : 8+ (just a few failing)
pki-deps : 10+ (just a few failing)
python27 : 4 (just a couple docs pkgs missing)
python38-devel : 1 (1 pkg failing)
python38 : 2 (1 pkg failing)
rhncfg : ?
ruby : ?
satellite-5-client : ?
scala : 10+ (1 pkg failing)
swig : ?
virt-devel : 10+ (1 pkg failing)
```

<br />

## Broken Modules
(These modules have NO packages completing their build, or very few.  They require more investigation)
```
389-directory-server : N/A (investigate?)
avocado : N/A (?)
cobbler : N/A
dwm
libselinux-python.txt
libuv
mariadb-devel (?)
nextcloud
rust-toolset
subversion
varnish
zabbix
```
