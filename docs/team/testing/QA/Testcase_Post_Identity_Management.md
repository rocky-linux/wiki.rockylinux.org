---
title: QA:Testcase Identity Management
author: Lukas Magauer
revision_date: 2022-10-08
rc:
  prod: Rocky Linux
  ver:
    - 8
    - 9
  level: Final
---

!!! info "Release relevance"
    This Testcase applies the following versions of {{ rc.prod }}: {% for version in rc.ver %}{{ version }}{% if not loop.last %}, {% endif %}{% endfor %}

!!! info "Associated release criterion"
    This test case is associated with the [Release_Criteria#packages-and-module-installation](9_release_criteria.md#packages-and-module-installation) release criterion. If you are doing release validation testing, a failure of this test case may be a breach of that release criterion.

## Description

Setting up a IdM system (FreeIPA) and using it's functionality leverages not also a lot of the packages in the official repos, it also tests quite a lot of used functions a corporate environment. This installatation will host it's own dns server for more generic testing without relying on the individual infrastructure of the environment.

## Requirements

- A freshly provisioned system (no other functions are allowed on this system except running the IdM services)
- IPv4 network with unmanaged domain name (installer will check for dns servers) and unmanaged reverse dns network (in my case here 10.30.30.0/24 and ipa1.network)
- In the case of this writeup the external dns server has the domain `example.com`, this has to have a entry for `r8-ipa1-dev.example.com` (this could also be replaced by a entry in the `/etc/hosts` file if no external dns server should be involved)

## Setup

1. `dnf module enable idm:DL1`
2. `dnf module install idm:DL1/dns`
3. `ipa-server-install`

    - Do you want to configure integrated DNS (BIND)? [no]: yes
    - Server host name [r8-ipa1-dev.example.com]: r8-ipa1-dev.example.com
    - Please confirm the domain name [ipa1.network]: ipa1.network
    - Please provide a realm name [IPA1.NETWORK]: IPA1.NETWORK
    - Directory Manager password: `<password>`
      Password (confirm): `<password>`
    - IPA admin password: `<other-password>`
      Password (confirm): `<other-password>`
    - Please provide the IP address to be used for this host name: 10.30.30.1
    - Enter an additional IP address, or press Enter to skip: `leave empty`
    - Do you want to configure DNS forwarders? [yes]: yes
    - Do you want to configure these servers as DNS forwarders? [yes]: yes
    - Enter an IP address for a DNS forwarder, or press Enter to skip: `leave empty`
    - Do you want to search for missing reverse zones? [yes]: yes
    - NetBIOS domain name [IPA1]: IPA1
    - Do you want to configure chrony with NTP server or pool address? [no]: yes
    - Enter NTP source server addresses separated by comma, or press Enter to skip: `leave empty`
    - Enter a NTP source pool address, or press Enter to skip: pool.ntp.org
    - Continue to configure the system with these values? [no]: yes

4. `firewall-cmd --add-service={freeipa-4,dns} --permanent`
5. `firewall-cmd --add-service={freeipa-4,dns}`

## How to test

1. Make sure Kerberos works, by running `kinit admin` and `klist`
2. Make sure the webfrontend is reachable and login works
3. Furthermore you can also attach another system (DNS + connecting via SSSD)

## Expected Results

After installation all services should be available and work correctly.

{% include 'testing/qa_testcase_bottom.md' %}
