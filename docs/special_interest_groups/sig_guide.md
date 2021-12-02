---
title: SIG Guide
---

Special Interest Groups are a core piece of the Rocky Linux community, in which
various members of these groups can extend the Enterprise Linux experience, by
way of packages, images, or other community engagement.

# Purpose

This page will serve as a guide for establishing SIGs and operational expectations.

# Resources

## Account Services

**URL**: https://accounts.rockylinux.org
**Purpose**: Account Services maintains the accounts for almost all components of the Rocky ecosystem
**Technology**: Noggin used by Fedora Infrastructure
**Contact**: `~Infrastructure` in Mattermost and `#rockylinux-infra` in Libera IRC

## Git

**URL**: https://git.rockylinux.org
**Purpose**: Packages and code for the Rocky Linux ecosystem
**Technology**: GitLab
**Contact**: `~Infrastructure`, `~Development` in Mattermost and `#rockylinux-infra`, `#rockylinux-devel` in Libera IRC

## Mirrors

**URL**: https://mirrors.rockylinux.org
**Purpose**: Users can apply to be a mirror to host Rocky content (SIG or the base operating system)
**Technology**: MirrorManager 2
**Contact**: `~Infrastructure` in Mattermost and `#rockylinux-infra` in Libera IRC

# SIG Process

Anyone in the community can propose or participate in a Special Interest Group. Here are some guidelines related to the working of a SIG.

## Proposal

Creating a new Special Interest Group requires participation from a member of the Rocky teams or a member of the board. A SIG must meet these requirements:

* The group must be related to Rocky or a use-case for Rocky
* There must be feedback and control into the Rocky community
* All communication as to the work of the SIG should be public - Some matters may have to be private, and as such should be out of band

  * It is expected that each SIG will have a public channel as `SIG/name` in mattermost. Optionally an IRC channel can also be assigned.

* Code produced within the SIG must be compatible with a FOSS license presently used by Rocky and [upstream](https://fedoraproject.org/wiki/Licensing:Main?rd=Licensing#SoftwareLicenses) - If a new license is wanted, consult with Release Engineering/Core or `~Legal` in Mattermost.
* All documentation produced within the SIG must be a compatible documentation license
* Groups should be aware/watchful of the direction from the Release Engineering team/Core as it can affect how SIGs operate if they are producing compiled software.
* A member of the SIG should also come from the Core/RelEng team, in the case that the SIG produces packages for use on a Rocky system.

## Proposal Process

It is up to the requestor to:

* Check and verify that the topic of interest is already covered by an existing Special Interest Group within Rocky or CentOS Stream
* Post an introductory RFC message:
  * As an email to the rocky-devel mailing list and ask for comments or...
  * As a message to `SIG/general` in mattermost

Upon approval, a Core/RelEng member will request/create initial resources as needed:

  * git.rockylinux.org groups
  * An initial git site
  * groups in Rocky Account Services
  * mail list
  * channel in mattermost + IRC channel as a bridge if requested

## Acceptance 

TBD

# Managing Content

This section goes over how to manage content in git and the community build system.

## Importing to Git

Each Special Interest Group will have a subgroup under `SIG` in git. This subgroup will have additional subgroups, `src`, `rpms`, `modules`. This is the default layout. Additional subgroups can be made at the root of the SIG group.

### rpms

This area is specifically used for rpm sources (spec file, patches, light text files). The expected format is:

* `SOURCES/...` -- light text files, scripts, patches, etc can come here (eg ones not in a tar ball)
* `SPECS/name.spec` -- Your spec file comes here - note it should only be one spec file
* `.name.metadata` -- Required, lists your source archives or otherwise that will be in lookaside. Empty if there are no sources to pull from lookaside.

The metadata file format is expected to me:

```
SHA256SUM_STRING SOURCES/some_name
```

The left column is generally a hashed sum of the archive. This *is* the name of the file in lookaside. The right side is where the archive will be the location and name of where it will be copied to. For example, the `ipa` package source name is a sum in lookaside, and during processing, it will be renamed and copied to `SOURCES/freeipa-4.9.6.tar.gz`:

```
b7b91082908db35e4acbcd0221b8df4044913dc1 SOURCES/freeipa-4.9.6.tar.gz
```

### modules

This area is specifically used for modularity. If you plan on maintaining multiple versions of a package and want to use modularity, this is the place to do it. The branch names *should always match* with rpms, especially when there are multiple versions. See the `branch` section in this document for more information.

The name of the module does not necessarily have to match the actual package or package names. For example, the idm module. There is no package named `idm`, but each package as part of the module have the correct branch names as referenced in the source yaml for the module.

The format expected:

* `SOURCES/modulemd.src.txt` -- This is the initial module yaml data that will be transformed name.yaml. See [this](https://git.rockylinux.org/staging/modules/idm/-/blob/r8-stream-client/SOURCES/modulemd.src.txt) for an example.
* `.name.metadata` - Just like rpms, a metadata file is required, even though it will be empty.

As of this writing, the `name.yaml` file generated in the root may be done by the Rocky Automation account.

### src

This area is specifically used for having the source of the rpm. This means that instead of uploading directly to S3, sources can be managed within a repository that matches the name of an rpm in the `rpms` group, by using dist-git/src-git. This is an optional group and does not have to be used. These are subject to the correct branch names template.

### Branch Names

This is **important**. **main is NOT an acceptable branch name under any cirumstances.**

You **must** follow the correct branch name format for your package to be used in the CBS. You must use this format:

```
rX-SIG-PKG_QUALIFIER[-OPTIONAL_VERSION]
```

Let's break it down:

* `X` will the rocky major version. For example, `r8`
* `SIG` will be your SIG name - For example, if it's one word, `storage` could be used. If it's a multi-word, abbreviate it. For example, `Messaging and Communication` could just be `mc`.
* `PKG_QUALIFIER` is the name of or the group of packages that you plan on building. For example, `gluster`. Gluster is more than one package, so each rpm repo would have this in the branch name.
* `OPTIONAL_VERSION` is straight forward. If you have multiple versions, you can put a version here.

Here's full examples using this format:

```
r8-storage-gluster-9
r8-mc-ejabberd
```

The top one says this is for Rocky Linux 8, storage sig, gluster packages, version 9. It implies there may be a version 10 at some point or there may be a version 8 that is/was there. It also implies there will be different repos per version, so a user could use the gluster 9 repo even though there may be a 10 version.

The bottom one says this is for Rocky Linux 8, the `mc` sig, and the package(s) are for ejabberd, with no specific version listed as it will be continuously updated.

## Importing to S3

TBD

## CBS (community build system)

### Building in the CBS

### dist tags

It is expected that your SIG will have a "shorthand" name assigned to you (either by core or yourself). Because of this, it is a requirement that the group project's packages all have it set for the entire scope of the group. For example, if the SIG's name is "Messaging and Communication", the shorthand would be "mc", and the package would be named:

`erlang-22.0.7-1.el8.mc.x86_64.rpm`

Some single word SIGs can be abbreviated too. Like `hyperscale` can become `hs`.

## Automated testing

## Release

### rocky-release packages

It is expected with Special Interest Groups that are delivering packages to have associated release packages that provide:

* Repo file(s) for dnf
* GPG key assosciated with the signing of your packages

During the initial request process, a GPG key is assigned to you in the build system to be used to sign your packages. A release package must be requested to be built and submitted to the extras repository. A request can be opened at git.rockylinux.org/rocky/rocky-linux.

Note:  The Special Interest Group cannot submit a key nor can they have access to the private key.
