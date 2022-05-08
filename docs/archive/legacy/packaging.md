---
title: Packaging
---
This page details the packaging efforts for the Rocky Linux project.

## Git Branching

Currently git.c.o has a very specific branch system for packages on the site. This is what we understand so far about it:

| Name      | Description      |
|   --      | --               |
| c8        | "Stable Branch"  |
| c8-stream | "Stable Modules" |
| c8s*      | Stream only      |

With this in mind, our focus should be on the c8 and c8-stream branches. We are currently unsure of the plans for 2022 with RHEL 9's release on how the branches will look or if the git system will change entirely. But for now, this is what we are working with.

## Original Proposal

The original idea was to pull directly from Red Hat. There may be a case where we should still be watching RHEL's releases and try to match them with what's going on with with git.c.o to make sure things are consistent. If they are, git.c.o may be the correct route.

## Repositories

Below will likely be the base repositories for Rocky Linux

| Repo Name | Usage | Enabled by default | Notes |
| -- | -- | -- | -- |
| BaseOS | Base packages | Yes | |
| AppStream | Modularity | Yes | |
| Devel | Devel packages | No | BuildRoot contexts + missing devel packages |
| CodeReady | PowerTools/CodeReady | No |  |
| extras | Extras | Yes | |
| isos | ISO | No | |
| RockyTools | | No | Possibly mix into Devel |

Repositories that are likely SIG's that may be implemented.

| Repo Name |
| -- |
| HighAvailibility |
| cloud |
| configmanagement |
| messaging |
| nfv |
| opstools|
| storage |
| virt |
| desktop |
