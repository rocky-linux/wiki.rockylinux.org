---
title: Getting Started
---

Contributing to Rocky Linux should be easy and straight forward for any user
who wishes to participate or would like to contribute in any way. This could
be through a Special Interest Group, or it could just be to the core Rocky
Linux distribution.

## Purpose

This page goes over the basic steps to signing up for an account with our
Rocky Account Services and other basics with interacting with the Rocky
ecosystem.

## Start Guide

This section will go over the very basics of signing up for an account
and filling in basic information in Rocky Account Services.

### Creating an Account

Creating and managing your Rocky account starts at Rocky Account Services.

* Go to the [Rocky Account Services](https://accounts.rockylinux.org) page and click the register tab
* Fill in the necessary boxes presented, such as user name, first and last name, and email address, and click "register"
* You will receive an activation email. Activate your account.
* Login to your account on the [Rocky Account Services](https://accounts.rockylinux.org) page

### Profile Information

When you login, you will be on your profile. Click "Edit Profile" below your
email address to make changes to your profile.

It is highly recommended that you fill out the following information on the
"Profile" tab:

* Locale
* Timezone
* Chat nicknames (if applicable)
* Your github/gitlab username

By default, if your email address has an account on [libravatar](https://www.libravatar.org),
you will automatically have a profile picture assigned. If you do not, you can create one
but clicking the "Change Avatar" button in the profile tab.

It is highly recommended that you fill out the "SSH & GPG Keys" tab. Your ssh
keys should sync to both the [Rocky Linux GitLab](https://git.rockylinux.org) and
[RESF Git Service](https://git.resf.org).

It is highly recommended that you add an OTP to your account.

### Signing Agreements

While editting your profile, there is an "Agreements" tab with all of the current
agreements for Rocky. It is highly recommended that the following is reviewed
and signed:

* Rocky Open Source Contributor Agreement
* Rocky Linux GitLab Contributor Agreement

See the [details](#details) section for more information.

### Requesting Access to Groups/SIGs

In general, the baseline steps to requesting access comes down to this:

* Create your account in RAS
* Fill out your profile
* Sign the appropriate agreements
* Find the group or groups you wish to join and find the sponsors

  * Check out the [Special Interest Group](../special_interest_groups/index.md) page
  * Check out the [IRC and Chat Page](irc.md) page

* Contact the sponsor directly or send a message to appropriate channel for the group

Each group/SIG will have different procedures for becoming part of the groups/SIGs
within Rocky Account Services. Most groups will require agreement(s) to be
signed, others may be on a request basis. Each group should have "sponsors"
that can be contacted with information on joining the groups. They can be
contacted in the [mattermost](https://chat.rockylinux.org).

Some sponsors may have additional documents they'll send you from the main wiki
or the SIG wiki that will detail the procedure they expect you to follow.

## Details

This section will go over a more detailed overview of various aspects of the
Rocky Account Services as well as pieces of infrastructure you may interact
with.

### Agreements

Agreements in Rocky Account Services are there to show that you understand
and agree to the terms in how you are expected to use Rocky-related services.

You will find 100% of the time, you will be required to sign at least one of
the agreements, and that's the `Rocky Open Source Contributor Agreement`. If
you plan on utilizing git.rockylinux.org or git.resf.org (as most contributors
will), signing of the `Rocky Git Contributor Agreement` is a requirement.

Before a sponsor or a team leader will add you to a group, they will have the
ability to check your profile to verify that you have signed the appropriate
agreements before proceeding. In the event your profile is set to private, this
information may be requested from Core/RelEng. If you do not or cannot agree to
the terms, you will not be able to contribute to Rocky within its own ecosystem.
Even so, this this does not stop you from contributing to github repositories at
both the Rocky Linux github organization repositories of the RESF github
organization repositories.

## Pull Requests

Should have:

* All commits GPG signed
* Head repo either branched from or rebased onto the development branch
* Any applicable Rocky Account Services agreements signed

{% include "releng/resources_bottom.md" %}
