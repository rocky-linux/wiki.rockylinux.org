---
title: Module-build-service "mbs" setup
---

# Overview

This how-to is WIP and based on https://pagure.io/fm-orchestrator

The setup is as follows:
* Currently we are testing mbs 2.32
* CentOS-8 installed
* Firewall allowing communication between the hosts
* Public network for access and private network for koji, psql and kerberos communication between hosts
* mbs.gnulab.org/10.10.10.4 hosts mbs and fedmsg
* SSL is setup for web facing services using let's encrypt and there is a directory services setup, you need to sort this one out


# Installing mbs and fedmsg

!!!THIS IS A QUICK GUIDE FOR TESTING ONLY!!!
* Currently we are installing using pip from the source, however the latest version is available at: https://copr.fedorainfracloud.org/coprs/nalika/rockylinux-tools/packages/
* Enable the current temp rockylinux-tools repo by running ```dnf copr enable nalika/rockylinux-tools```
* Install the needed packages: ```dnf install epel-release -y && dnf install fedmsg python3-gssapi git httpd mod_ssl python3-mod_wsgi python3-solv python3-pungi python3-psycopg2 mod_auth_gssapi -y```
```
git clone https://pagure.io/fm-orchestrator.git
cd fm-orchestrator
git checkout v2.32.0
pip3 install .

```
## Starting fedmsg
We need fedmsg-hub and fedmsg-relay to get things up and running "as far as I can tell" but I disable fedora's incoming messages and message signing
* Edit **/etc/fedmsg.d/endpoints.py** and comment out ```"tcp://hub.fedoraproject.org:9940"```
* Edit **/etc/fedmsg.d/module_build_service.py** as following "leave everything else as is":
```
            # "tcp://stg.fedoraproject.org:9940"
        ]
    },
    # Start of code signing configuration
    'sign_messages': False,
    'validate_signatures': False,
```
* Edit **/etc/fedmsg.d/ssl.py** and make sure validate_signatures is set to false
```
config = dict(
    sign_messages=False,
    validate_signatures=False,
```
* Edit **/etc/fedmsg.d/base.py** and set the ```topic_prefix="org.gnulab"``` and ```environment="prod"```
* Start fedmsg-hub and fedmsg-relay service
```
systemctl enable fedmsg-hub --now
systemctl enable fedmsg-relay --now
```
## Apache configuration for mbs-frontend
* Create a new file **/etc/httpd/conf.d/mbs.conf** with the following:
```
<IfModule mod_ssl.c>
<VirtualHost *:443>
  ServerName mbs.gnulab.org
  WSGIDaemonProcess mbs user=mbs group=mbs threads=5
    WSGIScriptAlias / /etc/module-build-service/mbs.wsgi
  WSGIPassAuthorization on
    <Directory /etc/module-build-service>
        WSGIProcessGroup mbs
        WSGIApplicationGroup %{GLOBAL}
        Require all granted
    </Directory>
    <Location />
        AuthType GSSAPI
        AuthName "GSSAPI Single Sign On Login"
        GssapiCredStore keytab:/etc/koji.keytab
        Require valid-user
    </Location>


SSLCertificateFile /etc/letsencrypt/live/mbs.gnulab.org/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/mbs.gnulab.org/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
</IfModule>
```
* Create the wsgi file **/etc/module-build-service/mbs.wsgi** as follows:
```
import logging
logging.basicConfig(level=logging.DEBUG)
from module_build_service import app as application
```
## Kerberos settings
* Make sure that **/etc/krb5.conf** as the correct realm and settings as following:
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
## General mbs's setup
* Create mbs user and set a password for it as following:
```
useradd mbs
passwd mbs
```
* Fix the permissions for **/etc/module-build-service/** to mbs:
```chown -R mbs:mbs /etc/module-build-service/```
## Postgresql configuration
I am using the same database server for koji which is hosted on koji.gnulab.org
* Create the required access by editing **/var/lib/pgsql/data/pg_hba.conf** as the following:
```
# IPv4 local connections:
host    mbs             mbs             10.10.10.4/32           md5
host    all             all             127.0.0.1/32            ident
```
* Edit **/var/lib/pgsql/data/postgresql.conf** to allow listening on network
```listen_addresses = 'localhost,10.10.10.2'```
* Create mbs pgsql user and database
```
createuser --no-superuser --no-createrole --no-createdb mbs
createdb -O mbs mbs
psql  -c "alter user mbs with encrypted password 'mysupersecretepasswordmbs';"
```
* Restart pgsql ```systemctl restart postgresql```
# mbs configuration
* Edit **/etc/module-build-service/koji.conf** as the follows:
```
[koji]

;configuration for koji cli tool

;url of XMLRPC server
server = https://koji.gnulab.org/kojihub

;url of web interface
weburl = https://koji.gnulab.org/koji

;url of package download site
topurl = https://koji.gnulab.org/
authtype = kerberos
krb_rdns = false
use_fast_upload = true

[staging]
server = https://koji.gnulab.org/kojihub
weburl = https://koji.gnulab.org/koji
topurl = https://koji.gnulab.org/
authtype = kerberos
krb_rdns = false
use_fast_upload = true
```
* Edit **/etc/module-build-service/config.py** as follows:
```
# -*- coding: utf-8 -*-
# SPDX-License-Identifier: MIT
from os import environ, path

# FIXME: workaround for this moment till confdir, dbdir (installdir etc.) are
# declared properly somewhere/somehow
confdir = path.abspath(path.dirname(__file__))
# use parent dir as dbdir else fallback to current dir
dbdir = path.abspath(path.join(confdir, "..")) if confdir.endswith("conf") else confdir


class ProdConfiguration(object):
    DEBUG = True
    # Make this random (used to generate session keys)
    SECRET_KEY = "74d9e9f9cd40e66fc6c4c2e9987dce48df3ce98542529126"
    #SQLALCHEMY_DATABASE_URI = "sqlite:///{0}".format(path.join(dbdir, "module_build_service.db"))
    SQLALCHEMY_DATABASE_URI = 'postgresql://mbs:mysupersecretepasswordmbs@koji.gnulab.org/mbs'
    SQLALCHEMY_TRACK_MODIFICATIONS = True
    # Where we should run when running "manage.py run" directly.
    HOST = "0.0.0.0"
    PORT = 5000

    # Global network-related values, in seconds
    NET_TIMEOUT = 120
    NET_RETRY_INTERVAL = 30

    #DISTGITS = {"git+https://git.centos.org": ("git clone {repo_path}", "get_sources.sh")}
    SYSTEM = "koji"
    MESSAGING = "fedmsg"  # or amq
    MESSAGING_TOPIC_PREFIX = ["org.gnulab.prod"]
    KOJI_CONFIG = "/etc/module-build-service/koji.conf"
    KOJI_PROFILE = "koji"
    ARCHES = ["x86_64"]
    ALLOW_ARCH_OVERRIDE = False
    KOJI_REPOSITORY_URL = "https://koji.gnulab.org/kojifiles/repos"
    KOJI_TAG_PREFIXES = ["module", "scrmod"]
    KOJI_ENABLE_CONTENT_GENERATOR = True
    CHECK_FOR_EOL = False
    PDC_URL = "https://pdc.fedoraproject.org/rest_api/v1"
    PDC_INSECURE = False
    PDC_DEVELOP = True
    SCMURLS = ["git+https://git.centos.org/", "https://git.centos.org/"]
    YAML_SUBMIT_ALLOWED = False

    # How often should we resort to polling, in seconds
    # Set to zero to disable polling
    POLLING_INTERVAL = 600

    # Determines how many builds that can be submitted to the builder
    # and be in the build state at a time. Set this to 0 for no restrictions
    NUM_CONCURRENT_BUILDS = 5

    ALLOW_CUSTOM_SCMURLS = False

    RPMS_DEFAULT_REPOSITORY = "git+https://git.centos.org/rpms/"
    RPMS_ALLOW_REPOSITORY = False
    #RPMS_DEFAULT_CACHE = "http://pkgs.fedoraproject.org/repo/pkgs/"
    RPMS_ALLOW_CACHE = False

    MODULES_DEFAULT_REPOSITORY = "git+https://git.centos.org/modules/"
    MODULES_ALLOW_REPOSITORY = False
    MODULES_ALLOW_SCRATCH = True
    ALLOW_ONLY_COMPATIBLE_BASE_MODULES = True


    ALLOWED_GROUPS_TO_IMPORT_MODULE = set()

    # Available backends are: console and file
    LOG_BACKEND = "file"

    # Path to log file when LOG_BACKEND is set to "file".
    LOG_FILE = "/tmp/module_build_service.log"

    # Available log levels are: debug, info, warn, error.
    LOG_LEVEL = "debug"

    # Allow stream override
    ALLOW_STREAM_OVERRIDE_FROM_SCM = True

    # Settings for Kerberos
    KRB_KEYTAB = "/etc/mbs.keytab"
    KRB_PRINCIPAL = "mbs@GNULAB.ORG"

    # AMQ prefixed variables are required only while using 'amq' as messaging backend
    # Addresses to listen to
    AMQ_RECV_ADDRESSES = [
        "amqps://messaging.mydomain.com/Consumer.m8y.VirtualTopic.eng.koji",
        "amqps://messaging.mydomain.com/Consumer.m8y.VirtualTopic.eng.module_build_service",
    ]
    # Address for sending messages
    AMQ_DEST_ADDRESS = \
        "amqps://messaging.mydomain.com/Consumer.m8y.VirtualTopic.eng.module_build_service"
    AMQ_CERT_FILE = "/etc/module_build_service/msg-m8y-client.crt"
    AMQ_PRIVATE_KEY_FILE = "/etc/module_build_service/msg-m8y-client.key"
    AMQ_TRUSTED_CERT_FILE = "/etc/module_build_service/Root-CA.crt"

    # Disable Client Authorization
    NO_AUTH = False
    AUTH_METHOD = "kerberos"
    LDAP_URI = "ldap://koji.gnulab.org"
    LDAP_GROUPS_DN = "ou=group,dc=gnulab,dc=org"
    ADMIN_GROUPS = {"packageradmin"}
    ALLOWED_GROUPS = {"packager"}
    KOJI_CG_DEVEL_MODULE = True
    KOJI_PROXYUSER = True
    REBUILD_STRATEGY = 'only-changed'
    REBUILD_STRATEGY_ALLOW_OVERRIDE = True
    KOJI_CG_BUILD_TAG_TEMPLATE = "{}-modular-updates-candidate"
    KOJI_CG_DEFAULT_BUILD_TAG = "modular-updates-candidate"
    # Extra options set for newly created Koji tags
    KOJI_TAG_EXTRA_OPTS = {
        "mock.package_manager": "dnf",
        # This is needed to include all the Koji builds (and therefore
        # all the packages) from all inherited tags into this tag.
        # See https://pagure.io/koji/issue/588 and
        # https://pagure.io/fm-orchestrator/issue/660 for background.
        "repo_include_all": True,
        # Has been requested by Fedora infra in
        # https://pagure.io/fedora-infrastructure/issue/7620.
        # Disables systemd-nspawn for chroot.
        "mock.new_chroot": 0,
        # Works around fail-safe mechanism added in DNF 4.2.7
        # https://pagure.io/fedora-infrastructure/issue/8410
        "mock.yum.module_hotfixes": 1,
    }
    # DEFAULT_DIST_TAG_PREFIX = 'module_'
```
* Create the logging file **/tmp/module_build_service.log** and set the correct permission:
```
touch /tmp/module_build_service.log
chown mbs:fedmsg /tmp/module_build_service.log
chmod 664 /tmp/module_build_service.log
```
* Restart services : 
```
systemctl restart fedmsg-hub
systemctl restart fedmsg-relay
systemctl restart httpd
```
# Testing the module build service
We will need to create a few tags for this to work, so on the koji admin machine, run the following commands:
* Creating tags:
```
koji add-tag module-centos-8.2.0-build
koji add-tag module-centos-8.3.0-build
```
* Adding the external mirrors for the build tags:
```
koji add-external-repo -m bare -t module-centos-8.2.0-build module-cent-8.2-baseos-external http://mirror.centos.org/centos-8/8.3.2011/BaseOS/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.2.0-build module-cent-8.2-appstream-external http://mirror.centos.org/centos-8/8.3.2011/AppStream/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.2.0-build module-cent-8.2-devel-external http://mirror.centos.org/centos-8/8.3.2011/Devel/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.2.0-build module-cent-8.2-ha-external http://mirror.centos.org/centos-8/8.3.2011/HighAvailability/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.2.0-build module-cent-8.2-pt-external http://mirror.centos.org/centos-8/8.3.2011/PowerTools/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.2.0-build module-cent-8.2-cp-external http://mirror.centos.org/centos-8/8.3.2011/centosplus/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.2.0-build module-cent-8.2-cr-external http://mirror.centos.org/centos-8/8.3.2011/cr/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.2.0-build module-cent-8.2-extras-external http://mirror.centos.org/centos-8/8.3.2011/extras/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.2.0-build module-cent-8.2-fasttrack-external http://mirror.centos.org/centos-8/8.3.2011/fasttrack/\$arch/os
koji add-external-repo -m bare -t module-centos-8.2.0-build module-cent-8.2-debuginfo-external http://debuginfo.centos.org/8/\$arch/
koji add-external-repo -m bare -t module-centos-8.2.0-build module-cent-8.2-sheriflocalrepo-external https://koji.gnulab.org/localrepo/\$arch/
koji add-external-repo -m bare -t module-centos-8.3.0-build module-cent-8.3-baseos-external http://mirror.centos.org/centos-8/8.3.2011/BaseOS/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.3.0-build module-cent-8.3-appstream-external http://mirror.centos.org/centos-8/8.3.2011/AppStream/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.3.0-build module-cent-8.3-devel-external http://mirror.centos.org/centos-8/8.3.2011/Devel/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.3.0-build module-cent-8.3-ha-external http://mirror.centos.org/centos-8/8.3.2011/HighAvailability/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.3.0-build module-cent-8.3-pt-external http://mirror.centos.org/centos-8/8.3.2011/PowerTools/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.3.0-build module-cent-8.3-cp-external http://mirror.centos.org/centos-8/8.3.2011/centosplus/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.3.0-build module-cent-8.3-cr-external http://mirror.centos.org/centos-8/8.3.2011/cr/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.3.0-build module-cent-8.3-extras-external http://mirror.centos.org/centos-8/8.3.2011/extras/\$arch/os/
koji add-external-repo -m bare -t module-centos-8.3.0-build module-cent-8.3-fasttrack-external http://mirror.centos.org/centos-8/8.3.2011/fasttrack/\$arch/os
koji add-external-repo -m bare -t module-centos-8.3.0-build module-cent-8.3-debuginfo-external http://debuginfo.centos.org/8/\$arch/
koji add-external-repo -m bare -t module-centos-8.3.0-build module-cent-8.3-sheriflocalrepo-external https://koji.gnulab.org/localrepo/\$arch/
```
* Add mbs user:
```
koji add-user mbs
```
* Fix the content generating for koji
On Koji server, run the follwing commands
```
koji call addBType module
koji grant-cg-access mbs module-build-service --new
```

Now, on mbs server, we will need to do the following:
* Upgrade mbs db ```mbs-manager db upgrade``
* Download the platform modules ```git clone https://git.centos.org/modules/platform```
* Switch to the needed branche and loading it
```
git branch -a
git checkout c8-stream-el8.2.0
mbs-manager import_module platform.yaml
git checkout c8-stream-el8.3.0
mbs-manager import_module platform.yaml
```
* Create the module build json file, for example **redis.json**
```
  {
	"scmurl": "https://git.centos.org/modules/redis.git?#f042b198bcbc0fe410be219f27cd041deea7bcc3",
	"branch": "c8-stream-5"
  }
```
* Generate your kerberos ticket ```kinit snagy```
* Submit the job ``` curl -X POST -H "Content-Type: application/json" -u : --negotiate -d @redis.json https://mbs.gnulab.org/module-build-service/1/module-builds/```
* Check Tasks on koji
