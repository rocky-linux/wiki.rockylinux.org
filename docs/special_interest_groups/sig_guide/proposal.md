---
title: Proposing a SIG
---

This page goes over proposing a Special Interest Group for the Rocky ecosystem.
Anyone can propose or participate in a Special Interest Group.

## Proposal

Creating a new Special Interest Group requires participation from a member of the Rocky teams or a member of the board. A SIG must meet these requirements:

* The group must be related to Rocky or a use-case for Rocky or Enterprise Linux as a whole
* There must be feedback and control into the Rocky community
* All communication as to the work of the SIG should be public - Some matters may have to be private, and as such should be out of band

    * It is expected that each SIG will have a public channel as `SIG/name` in mattermost. Optionally an IRC channel can also be assigned.

* Code produced within the SIG must be compatible with a FOSS license presently used by Rocky and [upstream](https://docs.fedoraproject.org/en-US/legal/) - If a new license is wanted and is not available in the upstream list, consult with Release Engineering/Core or `~Legal` in Mattermost.
* All documentation produced within the SIG must be a compatible documentation license
* Groups should be aware/watchful of the direction from the Release Engineering team/Core as it can affect how SIGs operate if they are producing compiled software.
* A member of the SIG should also come from the Core/RelEng team, in the case that the SIG produces packages for use on a Rocky system.

## Proposal Process

It is up to the requestor to:

* Check and verify that the topic of interest is already covered by an existing Special Interest Group within Rocky or CentOS Stream
* Post an introductory RFC message:

    * As an email to the rocky-devel mailing list and ask for comments or...
    * As a message to `SIG/general` in mattermost

Upon approval, a Core/RelEng member will request/create initial resources as needed at the [SIG/Core Tracker](https://git.resf.org/sig_core/meta/issues) using a predefined template:

  * RESF Git Service organization is created (git.resf.org)
  * Rocky Linux GitLab groups are created (git.rockylinux.org) if applicable
  * groups in Rocky Account Services
  * mail list
  * channel in mattermost + IRC channel as a bridge if requested
  
A copy of the proposal or another version of it that is related to the original request should be in the request.

## Acceptance

TBD

{% include "releng/resources_bottom.md" %}
