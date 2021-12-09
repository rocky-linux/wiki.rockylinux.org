---
title: Special Interest Groups
---

Special Interest Groups are a core piece of the Rocky Linux community, in which
various members of these groups can extend the Enterprise Linux experience, by
way of packages, images, or other community engagement.

For the case of the wiki, Special Interest Groups are recommended not to have
direct wiki pages, but instead maintain their own set of GitLab pages in the form
of a wiki.

This page will serve as informational only on current and proposed SIG's, as
well as information on proposing a SIG.

## Current SIGs

### Some that may be established with sponsors/members

| SIG | Purpose |
|-----|---------|
| Core | Rocky Linux maintainers, packagers, and developers. It is primarily a mix of Release Engineering and Infrastructure |
| AltArch | Maintains alternative architectures that is not directly supported by Rocky Linux |
| Desktop | Supports and maintains the desktop experience for Rocky Linux |
| Legacy | Supports and maintains legacy hardware support for Rocky Linux |
| HPC    | Maintains High Performance Computing support for Rocky Linux |
| Hyperscale | Hyperscale Computing |

### Some that have community interest, but no direct sponsors yet

| SIG | Purpose |
|-----|---------|
| Cloud | Cloud images and infrastructure - May work upstream with Stream for openstack and others as well |
| Leapp | Focuses on the leapp framework to facilitate upgrades between major versions of Rocky |

## SIG Requirements

We expect SIGs to satisfy some basic requirements, such as:

* The group must be related to Rocky, a use-case for Rocky, or related to Enterprise Linux as a whole
* There must be feedback and control into the Rocky community
* All communication as to the work of the SIG should be public - Some matters may have to be private, and as such should be out of band
    * It is expected that each SIG will have a public channel as `SIG/name` in mattermost. Optionally an IRC channel can also be assigned.
* Code produced within the SIG must be compatible with a FOSS license presently used by Rocky - If a new license is wanted, consult with Release Engineering/Core or the `~Legal` channel in mattermost.
* All documentation and information of the SIG should be on a wiki produced in [git](https://git.rockylinux.org).
* All documentation produced within the SIG must be a compatible documentation license
* Groups should be aware/watchful of the direction from the Release Engineering team/Core as it can affect how SIGs operate if they are producing compiled software.

## SIG Wiki

Each SIG should have a wiki that will have documentation for their particular group as well as information on how the group operates. Required information should be as follows:

* An "about" section on the index that explains what the group does/a group description
* Mission Statement
* How to Contribute
* Meeting Information (time, location, other information that they feel is important)
* Policies and Resources, if applicable

## SIG Membership

The following rules apply for SIG membership:

* Mailing lists of SIGs are open and can be joined freely
* SIG members are appointed/approved by SIG sponsors/leaders - The sponsors/leaders typically have write permissions to relevant wikis and git repos
* SIG sponsors/leaders may be asked to be a mailing list moderator
* SIG channels will be public under a name such as `SIG/name` with an optional IRC channel to be bridged.
* Optionally: define if work with CentOS Stream will be applicable for the SIG

## SIG Reporting

SIGs are expected to report at least quarterly, with a brief summary of what they've accomplished. A suggested outline:

* Membership update (members joined or parted, sponsor/leader changes)
* Releases in the current quarter (or previous quarter if no releases)
* General activity or health report
* Issues to address within the SIG
