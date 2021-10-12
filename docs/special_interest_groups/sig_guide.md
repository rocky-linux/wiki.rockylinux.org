---
title: SIG Guide
---

Special Interest Groups are a core piece of the Rocky Linux community, in which
various members of these groups can extend the Enterprise Linux experience, by
way of packages, images, or other community engagement.

## Purpose

This page will serve as a guide for establishing SIGs and operational expectations.

## Resources

### Account Services

**URL**: https://accounts.rockylinux.org
**Purpose**: Account Services maintains the accounts for almost all components of the Rocky ecosystem
**Technology**: Noggin used by Fedora Infrastructure
**Contact**: `~Infrastructure` in Mattermost and `#rockylinux-infra` in Libera IRC

### Git

**URL**: https://git.rockylinux.org
**Purpose**: Packages and code for the Rocky Linux ecosystem
**Technology**: GitLab
**Contact**: `~Infrastructure`, `~Development` in Mattermost and `#rockylinux-infra`, `#rockylinux-devel` in Libera IRC

### Mirrors

**URL**: https://mirrors.rockylinux.org
**Purpose**: Users can apply to be a mirror to host Rocky content (SIG or the base operating system)
**Technology**: MirrorManager 2
**Contact**: `~Infrastructure` in Mattermost and `#rockylinux-infra` in Libera IRC

## SIG Process

Anyone in the community can propose or participate in a Special Interest Group. Here are some guidelines related to the working of a SIG.

### Proposal

Creating a new Special Interest Group requires participation from a member of the Rocky teams or a member of the board. A SIG must meet these requirements:

* The group must be related to Rocky or a use-case for Rocky
* There must be feedback and control into the Rocky community
* All communication as to the work of the SIG should be public - Some matters may have to be private, and as such should be out of band

  * It is expected that each SIG will have a public channel as `SIG/name` in mattermost. Optionally an IRC channel can also be assigned.

* Code produced within the SIG must be compatible with a FOSS license presently used by Rocky - If a new license is wanted, consult with Release Engineering/Core.
* All documentation produced within the SIG must be a compatible documentation license
* Groups should be aware/watchful of the direction from the Release Engineering team/Core as it can affect how SIGs operate if they are producing compiled software.
* A member of the SIG should also come from the Core/RelEng team

### Proposal Process

It is up to the requestor to:

* Check and verify that the topic of interest is already covered by an existing Special Interest Group within Rocky or CentOS Stream
* Post an introductory RFC message:
  * As an email to the rocky-devel mailing list and ask for comments
  * As a message to `SIG/general` in mattermost

Upon approval, a Core/RelEng member will request/create initial resources as needed:

  * git.rockylinux.org groups
  * An initial git site
  * groups in Rocky Account Services
  * mail list
  * channel in mattermost + IRC channel as a bridge if requested

### Acceptance 

TBD

## Managing Content

### Importing to Git

### CBS

#### Building in the CBS

#### dist tags

It is expected that your SIG will have a "shorthand" name assigned to you (either by core or yourself). Because of this, it is a requirement that the group project's packages all have it set for the entire scope of the group. For example, if the SIG's name is "Messaging and Communication", the shorthand would be "mc", and the package would be named:

`erlang-22.0.7-1.el8.mc.x86_64.rpm`

### Automated testing

### Release

#### rocky-release packages

It is expected with Special Interest Groups that are delivering packages to have associated release packages that provide:

* Repo file(s) for dnf
* GPG key assosciated with the signing of your packages

During the initial request process, a GPG key is assigned to you in the build system to be used to sign your packages. A release package must be requested to be built and submitted to the extras repository. A request can be opened at git.rockylinux.org/rocky/rocky-linux.
