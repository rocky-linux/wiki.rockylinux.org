---
title: Special Interest Groups
---

Special Interest Groups are a core component of the Rocky Linux community, in
which various members of these groups can extend the Enterprise Linux experience,
by way of packages, images, and/or other community engagement.

For the case of this wiki, Special Interest Groups are recommended not to have
direct wiki pages, but instead maintain their own wiki pages, maintained at
the [RESF Git Service](https://git.resf.org).

This page serves simply as an overview to Special Interest Groups. See the
[SIG Guide](sig_guide/index.md) for specific information such as proposing a SIG,
content management, and much more.

## Special Interest Group Requirements

We expect SIGs to satisfy some basic requirements, such as:

* The group should be related to Rocky Linux, a use-case for Rocky Linux or Enterprise Linux, or related to Enterprise Linux as a whole
* There must be feedback and control into the Rocky Linux community
* All communication as to the work of the SIG should be public - Some matters may have to be private, and as such should be out of band
    * It is expected that each SIG will have a public channel as `SIG/name` in mattermost. Optionally an IRC or Matrix channel can also be assigned.
* Code produced within the SIG must be compatible with a FOSS license presently used by Rocky Linux - If a new license is wanted, consult with Release Engineering/Core or the `~Legal` channel in mattermost.
* All documentation and information of the SIG should be on a wiki produced in the [RESF Git Service](https://git.resf.org).
* All documentation produced within the SIG must be a compatible documentation license
* Groups should be aware/watchful of the direction from the Release Engineering team/Core as it can affect how SIGs operate if they are producing compiled software.

## Special Interest Group Wiki

Each SIG should have a wiki that will have documentation for their particular group as well as information on how the group operates. Required information should be as follows:

* An "about" section on the index that explains what the group does/a group description
* Mission Statement
* How to Contribute / Onboarding Process
* Meeting Information (time, location, other information that they feel is important)
* Policies and Resources, if applicable

## SIG Membership and Participation

The following rules apply for SIG membership:

* Mailing lists of SIGs are open and can be joined freely
* SIG members are appointed/approved by SIG sponsors/leaders - The sponsors/leaders typically have write permissions to relevant wikis and git repos
* SIG sponsors/leaders may be asked to be a mailing list moderator
* SIG channels will be public under a name such as `SIG/name` with an optional IRC and Matrix channel to be bridged.
* Optionally: define if work with CentOS Stream will be applicable for the SIG

## SIG Reporting

SIGs are expected to report at least quarterly, with a brief summary of what they've accomplished. A suggested outline:

* Membership update (members joined or parted, sponsor/leader changes)
* Releases in the current quarter (or previous quarter if no releases)
* General activity or health report
* Issues to address within the SIG

## Joining a Special Interest Group

Joining an established Special Interest Group should be simple. Each SIG will
have its own process and outlines. Please see sponsors or other members of the
Special Interest Group you're interested in if a wiki or other documentation
is not available.

## Current Special Interest Groups

This section goes over the current SIGs that may have sponsors and are active or has community interest.

### Some that may be established with sponsors/members

| SIG                                          | Purpose                                                                                                                                                   |
|----------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Cloud](https://sig-cloud.rocky.page/)       | Cloud images and infrastructure - May work upstream with Stream for openstack and others as well.                                                         |
| [AltArch](https://sig-altarch.rocky.page/)   | Maintains alternative architectures or devices (such as the raspberry pi) that are not directly supported by Rocky Linux                                  |
| Desktop                                      | Supports and maintains the desktop experience for Rocky Linux                                                                                             |
| Embedded                                     | Embedded Systems                                                                                                                                          |
| [Kernel](https://sig-kernel.rocky.page/)     | Maintains kernels (such as mainline or other long term support) and drivers                                                                               |
| Legacy                                       | Supports and maintains legacy hardware support for Rocky Linux                                                                                            |
| [HPC](https://sig-hpc.rocky.page/)           | Maintains High Performance Computing support for Rocky Linux                                                                                              |
| Hyperscale                                   | Hyperscale Computing                                                                                                                                      |
| [Security](https://sig-security.rocky.page/) | Extra security features and security-hardened override packages (replacing those from the main distribution) for Rocky Linux and other EL distros         |

### Some that have community interest, but no direct sponsors yet

| SIG                                         | Purpose                                                                                          |
|---------------------------------------------|--------------------------------------------------------------------------------------------------|
| [Database](https://sig-database.rocky.page) | Databases of all shapes, sizes, and use cases                                                    |
| [AI](https://sig-ai.rocky.page/)            | Rocky Linux Ecosystem for AI, ML, Data Science & BigData.                                        |
| Leapp                                       | Focuses on the leapp framework to facilitate upgrades between major versions of Rocky            |

{% include "releng/resources_bottom.md" %}
