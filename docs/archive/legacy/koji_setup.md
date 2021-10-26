---
title: Koji setup
---

# Overview

This how-to is WIP and based on https://docs.pagure.org/koji/

The setup is as follows:
* CentOS-8 installed
* Firewall allowing communication between the hosts
* Public network for access and private network for koji and kerberos communication between hosts
* koji.gnulab.org/10.10.10.2 hosts koji, kojiweb, koji-hub,kojira, kerberos server, kerberos workstation "for testing"
* builder1.gnulab.org/10.10.10.3 hosts kojid building daemon and kerberos workstation "for testing"
* Your location machine should have kerberos workstation as well and a browser configured to use kerberos
* SSL is setup for web facing services using let's encrypt, you need to sort this one out


# Getting kerberos up and running

!!!THIS IS A QUICK GUIDE FOR TESTING ONLY!!!

You will need to install kerberos for this setup, however I assume IPA will be in place and will be used

On the koji.gnulab.org machine do the following:
* Install he needed packages:
```dnf install krb5-server.x86_64 krb5-workstation.x86_64 -y```
* Edit **/etc/krb5.conf** to look like that
```
# To opt out of the system crypto-policies configuration of krb5, remove the
# symlink at /etc/krb5.conf.d/crypto-policies which will not be recreated.
includedir /etc/krb5.conf.d/

[logging]
    default = FILE:/var/log/krb5libs.log
    kdc = FILE:/var/log/krb5kdc.log
    admin_server = FILE:/var/log/kadmind.log

[libdefaults]
    dns_lookup_realm = false
    ticket_lifetime = 24h
    renew_lifetime = 7d
    forwardable = true
    rdns = false
    pkinit_anchors = FILE:/etc/pki/tls/certs/ca-bundle.crt
    spake_preauth_groups = edwards25519
    default_realm = GNULAB.ORG
    default_ccache_name = KEYRING:persistent:%{uid}

[realms]
 GNULAB.ORG = {
     kdc = koji.gnulab.org
     admin_server = koji.gnulab.org
 }

[domain_realm]
 .gnulab.org = GNULAB.ORG
 gnulab.org = GNULAB.ORG

```
Where GNULAB.ORG is your realm
* Create kerberos DB and create your super secrete password for the DB:
```kdb5_util create -s```
* Edit kerberos ACL **/var/kerberos/krb5kdc/kadm5.acl** to look as follows:
```
*/admin@GNULAB.ORG	*
```
* Create the local admin:
```kadmin.local -q "addprinc admin/admin"```
* Start you services:
```systemctl enable krb5kdc --now && systemctl enable kadmin --now```

## The principles

koji needs few principles in kerberos for authentication as follows:


- host/kojihub@GNULAB.ORG: Used by the koji-hub server when communicating with the koji client
- HTTP/kojiweb@GNULAB.ORG: Used by the koji-web server when performing a negotiated Kerberos authentication with a web browser. This is a service principal for Apache’s mod_auth_gssapi.
- koji/kojiweb@GNULAB.ORG: Used by the koji-web server during communications with the koji-hub. This is a user principal that will authenticate koji-web to Kerberos as “koji/kojiweb@GNULAB.ORG”. Koji-web will proxy the mod_auth_gssapi user information to koji-hub (the ProxyPrincipals koji-hub config option).
- koji/kojira@GNULAB.ORG: Used by the kojira server during communications with the koji-hub
- compile/builder1.gnulab.org@GNULAB.ORG: Used on builder1 to communicate with the koji-hub. This is a user principal that will authenticate koji-builder to Kerberos as “compile/builder1.gnulab.org@GNULAB.ORG”. Each builder host will have its own unique Kerberos user principal to authenticate to the hub.
- snagy@GNULAB.ORG: for my testing and package owner
- HTTP/koji.gnulab.org@GNULAB.ORG: to allow the client to use HTTP "I am not sure"

And we can start creating the needed principles:
* run ```kadmin.local``` then the following:
```
addprinc host/kojihub@GNULAB.ORG
addprinc HTTP/kojiweb@GNULAB.ORG
addprinc koji/kojiweb@GNULAB.ORG
addprinc koji/kojira@GNULAB.ORG
addprinc HTTP/koji.gnulab.org@GNULAB.ORG
addprinc snagy@GNULAB.ORG
addprinc kojiadmin@GNULAB.ORG
```

* Now we will need to create keytab, keytab is used for non-password auth, also I guess once you do that, you won't be able to use passwords, but that is okay since most of those are services principals, not that you can use multiple files if you need to, run ```kadmin.local``` and then:
```
	ktadd	-k /etc/koji.keytab host/kojihub@GNULAB.ORG
	ktadd	-k /etc/koji.keytab HTTP/kojiweb@GNULAB.ORG
	ktadd	-k /etc/koji.keytab koji/kojira@GNULAB.ORG
	ktadd	-k /etc/koji.keytab koji/kojiweb@GNULAB.ORG
	ktadd	-k /etc/koji.keytab HTTP/koji.gnulab.org@GNULAB.ORG
```
* Validation done by running ```klist -k -t /etc/koji.keytab```
* Run change permissions: ```chmod 644 /etc/koji.keytab```
```
root# klist -k -t /etc/koji.keytab
Keytab name: FILE:/etc/koji.keytab
KVNO Timestamp           Principal
---- ------------------- ------------------------------------------------------
   2 12/19/2020 15:00:53 koji/kojira@GNULAB.ORG
   2 12/19/2020 15:00:53 koji/kojira@GNULAB.ORG
   2 12/19/2020 15:01:08 koji/kojiweb@GNULAB.ORG
   2 12/19/2020 15:01:08 koji/kojiweb@GNULAB.ORG
   2 12/19/2020 15:01:14 HTTP/kojiweb@GNULAB.ORG
   2 12/19/2020 15:01:14 HTTP/kojiweb@GNULAB.ORG
   2 12/19/2020 15:01:20 host/kojihub@GNULAB.ORG
   2 12/19/2020 15:01:20 host/kojihub@GNULAB.ORG
   2 12/19/2020 15:38:52 HTTP/koji.gnulab.org@GNULAB.ORG
   2 12/19/2020 15:38:52 HTTP/koji.gnulab.org@GNULAB.ORG

```

# Setting up koji echosystem
We will start by setting up the DB, koji-hub, kojiweb and then kojira
## The Database
On the main server koji.gnulab.org, do the following:
* We need to install postgreqsl: ```dnf install postgresql-server -y```
* Init postgresql db: ```postgresql-setup --initdb --unit postgresql```
* Start the service: ```systemctl enable postgresql --now```
* Adding Koji user:
```
useradd koji
passwd koji
```
and set a random complex password
* Lets create koji DB user:
```
su - postgres
createuser --no-superuser --no-createrole --no-createdb koji
createdb -O koji koji
psql -c "alter user koji with encrypted password 'mysupercomplexpassword';"
```
* Let's setup koji: ```dnf install koji -y```
* load the DB into postgresql:
	```
  su - koji
  psql koji koji < /usr/share/doc/koji*/docs/schema.sql
  ```
* Postgresql permissions
Since my koji server lives with the postgresql, I am using socket communication instead of TCP/IP
* Edit **/var/lib/pgsql/data/pg_hba.conf** as follows "Order is important":
```
# "local" is for Unix domain socket connections only
local	koji		koji					trust
local   all             all                                     peer
```
* Reload postgresql: ```systemctl reload postgresql```
* Create koji authenticiation for kerberos:
```
su - koji

psql <<EOF
with user_id as (
insert into users (name, status, usertype) values ('kojiadmin', 0, 0) returning id
)
insert into user_krb_principals (user_id, krb_principal) values (
(select id from user_id),
'kojiadmin@GNULAB.ORG');
EOF
```
* Give the user admin permissions:
```
	su - koji
	psql
	koji=> select * from users;
	koji=> insert into user_perms (user_id, perm_id, creator_id) values ("id of user inserted above", 1, "id of user inserted above");
```
## /mnt/koji and NFS
* Create the koji file system skeleton:
* Setup NFS and apache : ```dnf install nfs-utils httpd -y```
```
cd /mnt
mkdir koji
cd koji
mkdir {packages,repos,work,scratch,repos-dist}
chown apache.apache *
```
* Start the service: ```systemctl enable --now nfs-server```
* Edit **/etc/exports** as follows:
```
/mnt/koji 10.10.10.3(ro,sync,no_all_squash,root_squash)
```
* Export the filesystem: ```exportfs -ra```
* View current state: ```exportfs -v```
* On the client install the NFS client packages: ```dnf install nfs-utils nfs4-acl-tools -y```
* Create the local dir: ```mkdir /mnt/koji```
* Mount the NFS: ```mount -t nfs 10.10.10.2:/mnt/koji /mnt/koji```

## Kojihub
* Install kojihub ```dnf install koji-hub mod_ssl -y```
* Enable postgresql sweep function: ```systemctl enable --now koji-sweep-db.timer```
* Enable kerberos auth in **/etc/httpd/conf.d/kojihub.conf** by uncomment the section below as follows:
```
# uncomment this to enable authentication via GSSAPI
 <Location /kojihub/ssllogin>
         AuthType GSSAPI
         AuthName "GSSAPI Single Sign On Login"
         GssapiCredStore keytab:/etc/koji.keytab
         Require valid-user
 </Location>
```
* koji-hub configurations as follows in **/etc/koji-hub/hub.conf**:
```
[hub]

DBName = koji
DBUser = koji
KojiDir = /mnt/koji
AuthPrincipal = host/kojihub@GNULAB.ORG
AuthKeytab = /etc/koji.keytab
ProxyPrincipals = koji/kojiweb@GNULAB.ORG
HostPrincipalFormat = compile/%s@GNULAB.ORG
LoginCreatesUser = On
KojiWebURL = https://koji.gnulab.org/koji
NotifyOnSuccess = True
```
* Install selinux policyutils: ```dnf install policycoreutils-python-utils -y```
* Lets fix some selinux stuff:
```
	setsebool -P allow_httpd_anon_write=1
	setsebool -P httpd_can_network_connect 1
	setsebool -P httpd_use_nfs=1
	semanage fcontext -a -t public_content_rw_t "/mnt/koji(/.*)?"
	restorecon -r -v /mnt/koji
  ```
## Configure koji cli client
* edit **/etc/koji.conf** as follows:
```
[koji]

server = https://koji.gnulab.org/kojihub
weburl = https://koji.gnulab.org/koji
topurl = https://koji.gnulab.org/
topdir = /mnt/koji
authtype = kerberos
krb_rdns = false
plugins = runroot
use_fast_upload = yes
```
* restart httpd: ```systemctl restart httpd```
* Test by running the following on koji server:
	* kinit -p kojiadmin@GNULAB.ORG
	* koji moshimoshi
```
[root@koji ~]# kinit -p kojiadmin@GNULAB.ORG
Password for kojiadmin@GNULAB.ORG:
[root@koji ~]# koji moshimoshi
hylô, kojiadmin!

You are using the hub at https://koji.gnulab.org/kojihub
Authenticated via GSSAPI
```
## Kojiweb
* Install kojiweb: ```dnf install koji-web -y```
* Edit **/etc/httpd/conf.d/kojiweb.conf** to allow kerberos:
```
# uncomment this to enable authentication via Kerberos
 <Location /koji/login>
     AuthType GSSAPI
     AuthName "Koji Web UI"
     GssapiCredStore keytab:/etc/koji.keytab
     Require valid-user
     ErrorDocument 401 /koji-static/errors/unauthorized.html
 </Location>

```
* Edit Kojiweb configuration **/etc/kojiweb/web.conf**
```
[web]
SiteName = koji

KojiHubURL = https://koji.gnulab.org/kojihub
KojiFilesURL = https://koji.gnulab.org/kojifiles

WebPrincipal = koji/kojiweb@GNULAB.ORG
WebKeytab = /etc/koji.keytab
WebCCache = /var/tmp/kojiweb.ccache
KrbService = koji.gnulab.org
KrbServerRealm = GNULAB.ORG
LoginTimeout = 72
Secret = asdasdf12313ewdasfq234f
LibPath = /usr/share/koji-web/lib
LiteralFooter = True
```
* restart apache: ```systemctl reload httpd```
## Setting up the builder / kojid / koji-builder
This will configuration will be on the building node(s)

* Install koji-builder: ```dnf install koji-builder -y```
* Edit **/etc/kojid/kojid.conf** as follows:
```
[kojid]

topdir=/mnt/koji
workdir=/tmp/koji
server=https://koji.gnulab.org/kojihub
topurl=https://koji.gnulab.org/kojifiles
; those are for building package from git.c.o and Mustafa's git
allowed_scms=git.centos.org:/*:off:get_sources.sh gitlab.rockylinux.bycrates.org:/*:off:/bin/sh,/usr/bin/srpmproc_wrapper
host_principal_format=compile/%s@GNULAB.ORG
```
On koji main server, run the following commands:
* Add the new builder:  ```koji add-host builder1.gnulab.org  x86_64```
* Add the createrepo channel: ```koji add-host-to-channel builder1.gnulab.org createrepo```
* I did adjust the capacity since it is a small machine: ```koji edit-host --capacity=8 builder1.gnulab.org```
* Note, by default kojid uses DNS to talk to koji-hub, so you need to have SRV record in your DNS as follows:
```
_kerberos._udp    IN SRV  10 100 88 kerberos.GNULAB.ORG.
```
* Kojid looks for **/etc/kojid/kojid.keytab** by default, so you need to create a file with compile principle as above and place it in the right location on builder node(s)
```
kadmin.local
addprinc compile/builder1.gnulab.org@GNULAB.ORG
ktadd -k /tmp/kojid.keytab compile/builder1.gnulab.org@GNULAB.ORG
```
On the builder node, restart kojid: ```systemctl enable kojid --now```

## Kojira

* Install koji-utils: ```dnf install koji-utils -y```
* Add kojira user and give it permission for repo
```
koji add-user koji/kojira
koji grant-permission repo koji/kojira
```
* Edit **/etc/kojira/kojira.conf** as following:
```
[kojira]

server=https://koji.gnulab.org/kojihub
topdir=/mnt/koji
logfile=/var/log/kojira.log
principal = koji/kojira@GNULAB.ORG
keytab = /etc/koji.keytab
```
* Start Kojira service: ```systemctl enable kojira --now```

# Koji bootstrapping

I went with the external repo method to bootstrap the setup, so I added external repos and create the following tags and targets, this work is based on: https://docs.pagure.org/koji/external_repo_server_bootstrap/

On the main node, run the following:
* Add your final dist tag: ```koji add-tag dist-rocky8```
* Create the build tag:
```koji add-tag --parent dist-rocky8 --arches "x86_64" -x mock.yum.module_hotfixes=1 dist-rocky8-build```

* Add the external repos, I hard coded the ARCH, but you can use \$arch instaed of x86_64 in the repo URL:
```
koji add-external-repo -m bare -t dist-rocky8-build centos-8-baseos-external http://mirror.centos.org/centos-8/8.3.2011/BaseOS/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-appstream-external http://mirror.centos.org/centos-8/8.3.2011/AppStream/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-devel-external http://mirror.centos.org/centos-8/8.3.2011/Devel/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-ha-external http://mirror.centos.org/centos-8/8.3.2011/HighAvailability/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-pt-external http://mirror.centos.org/centos-8/8.3.2011/PowerTools/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-cp-external http://mirror.centos.org/centos-8/8.3.2011/centosplus/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-cr-external http://mirror.centos.org/centos-8/8.3.2011/cr/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-extras-external http://mirror.centos.org/centos-8/8.3.2011/extras/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-fasttrack-external http://mirror.centos.org/centos-8/8.3.2011/fasttrack/\$arch/os
koji add-external-repo -m bare -t dist-rocky8-build centos-8-debuginfo-external http://debuginfo.centos.org/8/\$arch/
```
* I also created a small package for centospkg-minimal and srpmproc and create local repo, so adding that too: 
```
koji add-external-repo -m bare -t dist-rocky8-build centos-8-local-repo-external https://koji.gnulab.org/localrepo/\$arch/
```
* Add the targets: ```koji add-target dist-rocky8 dist-rocky8-build dist-rocky8```
* Create the bootstrapping groups for build and srpm-build
```
koji add-group dist-rocky8-build build
koji add-group dist-rocky8-build srpm-build
```
* Add the bootstrapping packages:
```
koji add-group-pkg dist-rocky8-build build bash buildsys-macros-el8 bzip2 centos-release centpkg-minimal coreutils cpio diffutils findutils gawk gcc gcc-c++ grep gzip info make module-build-macros patch redhat-rpm-config rpm-build scl-utils-build sed shadow-utils tar unzip util-linux which xz git srpmproc
koji add-group-pkg dist-rocky8-build srpm-build bash buildsys-macros-el8 centos-release centpkg-minimal git redhat-rpm-config rpm-build scl-utils-build shadow-utils system-release srpmproc
```
* Regenerating the repos ```koji regen-repo dist-rocky8-build```

# Running a test

I ran the following test to build package from git.centos.org:

```koji add-user snagy```
```koji add-pkg --owner snagy dist-rocky8 python36``` "need to check if this is needed"
```
koji build dist-rocky8 'git+https://git.centos.org/git/rpms/python36.git?#f900ab6403fbd9c22e59f5d463fee210b3278fb3'
```
*  Results at: https://koji.gnulab.org/koji/taskinfo?taskID=321
