---
title: Git Guidelines
---

This document covers how the Rocky Enterprise Software Foundation (RESF) handles the use of Git in the ecosystem for the RESF and its projects such as Rocky Linux. It contains information about how various teams and the community interact and work with Git, as well as expectations and requirements.

## Contact Information
| | |
| - | - |
| **Owner** | Release Engineering (SIG/Core) / Infrastructure |
| **Mattermost Contacts** | `@label` `@mustafa` `@skip77` `@sherif` `@pgreco` `@neil` `@tgo` |
| **Mattermost Channels** | `~development` `~infrastructure` |
| **IRC Channels** | `#rockylinux-devel` `#rockylinux-infra` |
| **IRC Contacts** | `Sokel` `neil` `tg` |

## General Information

Git is a core component of the Rocky Linux build ecosystem, RESF projects, and thus a mode of the development process for the distribution and available software.

**Gitea** is used for the RESF, its projects, its code, mirrored repositories, and potentially other components.

**GitLab** is the software currently used to storing mostly RPM spec files, patches, configurations for debranding/modification to packages, as well as some scripts/utilities. Generally source code does not live here with the exception of src-git scenarios.

**GitHub** is used for the RESF and Rocky Linux project organizations, which may contain branding, scripts/tools/utilities, or a handful of other useful code (such as ansible). There may also be forks of upstream projects (such as mock) to handle upstreaming changes to the Fedora Project (like EPEL).

## Expectations

This section goes over the expectations of using a Git service.

### General Expectations

Most of this information is covered in our `Git Contributor Agreement`, which generally covers the RESF Git Service and Rocky Linux GitLab. However, we are duplicating the information here for all readers.

* Moderation is enforced - As is done in the Rocky Linux Mattermost chat, it is important to mind your language and word choice whether in Git issues or the Bug Tracker.
* A valid GPG key must be uploaded and used to sign your commits - Signed commits, as a general rule are recommended. Expect that most projects will have unsigned commits disabled.
* Do not treat git as an issue tracker - All issues for Rocky Linux should be tracked at our Bug Tracker. As of this writing, issues are opened for build issues.
* Do not perform your work or changes on a system that is owned by your employer.
* Creating personal projects are discouraged (see exceptions)
* Ensure that your software or work are of a valid open source license (see related links above)

### Do's and Do not's

Below are a list of do's and do not's as part of our Git, whether some are duplicated information above or below this subsection. They are placed here for further emphasis.

DO:

* Fork repositories and create pull requests where needed
* Ensure software/source code brought into the Git services are of a [valid open source license](https://fedoraproject.org/wiki/Licensing:Main?rd=Licensing#SoftwareLicenses)
* Upload a valid GPG key and sign your commits

DON'T:

* Treat any Git service as a Rocky Linux issue tracker
* Create personal projects under your namespace (see exceptions)
* Perform your work or changes on a system that is owned by your employer

### Exceptions

Exceptions to personal projects under your namespace would be for code that will be utilized in some way for the Rocky ecosystem, whether directly, indirectly (e.g., for people.rocky). This can also be the case of using Peridot as a COPR-like service.

## Source Code (for SIGs or other software)

To be populated.

## SIG Groups + Projects

This section covers SIG groups and projects that exist within the Rocky Linux git service. SIGs may have RPM specs, scripts, or even their own software. The sections below will cover the format and expectations of these groups and projects.

### General Overview

A SIG is a **S**pecial **I**nterest **G**roup(s). SIGs are smaller groups within the Rocky community that focus on a small set of issues or exist solely for the awareness or focus on topics. This section does not cover the requirements of a SIG's existence.

It is typical that a SIG may end up having repositories with packages that can add-on to a Rocky Linux system. However, some SIGs do not function in this manner. In the case that they do function in this manner, they will typically have a section in Rocky Linux GitLab under the SIG group.

A SIG will always have an organization at the RESF Git Service.

### Structure (Packaging)

Using the [RPM Structure](#current-rpm-structure) as a guide, the general idea is the same. A `patch` group may not be needed, but could be useful. An example of how a SIG could set up their group could be like this:

```
.
└── SIG
    └── messaging
        ├── modules
        ├── rpms
        │   └── somemq
        └── somemq
```

In this example, source code for the software `somemq` would be under the `messaging` subgroup under `SIG`. And then an RPM spec for that software, for that SIG, would sit under `rpms` as expected. However, you can further organize this further if you wish.

```
.
└── SIG
    └── messaging
        ├── modules
        ├── rpms
        │   └── somemq
        └── sources
            └── somemq
```

This isn't a strict requirement, but could be good for organization purposes.

### Access to a SIG Group

SIG group access is typically obtained by contacting a sponsor (as found in Account Services) and requesting access to be a part of the SIG. Once you have been added to the group as well as the `gitusers` group, you will be able to do work within the SIG.

## Other Groups

Other groups generally will not exist in the Rocky GitLab instance. Rather, they will (and should) exist in the RESF Gitea instance instead. These groups could contain repos for:

* A team's source code
* A team's set of tools or scripts
* Other miscellanous metadata

Examples of groups would be:

* Infrastructure -> This group contains repositories related for rocky infrastructure
* releng -> Release Engineering repositories and code
* sig_core -> Core Special Interest Group specifically for code and items related to Rocky Linux development and infrastructure

## RPM System

This section goes over the RPM system, such as importing, patching, and how it ultimately gets built into a binary RPM. This happens on [git.rockylinux.org](https://git.rockylinux.org).

### Current RPM Structure

The current RPM structure is designed to allow the orchestrator tool to import sources and then patch them accordingly if required. It also allows AppStream modules to be supported and manageable with their required YAML files.

There are four primary groups:

* **original**: contains RPM spec data that are from Rocky, such as release and logos
* **staging**: contains RPM spec data for the staging channel, such as testing the tools in that they operate and function correctly, and to test the build process.
* **release**: contains RPM spec data for the release channel, which would be the actual release that users will consume.

```
.
├── original
│   ├── modules
│   ├── patch
│   └── rpms
├── release
│   ├── modules
│   ├── patch
│   └── rpms
└── staging
    ├── modules
    ├── patch
    └── rpms
```

Each group has three subgroups:

* **modules** group is used to store repos that hold YAML files. The YAML files define the module that will exist in the AppStream repository.

* **patch** group is used to hold the configuration for **distrobuild** to pick up and patch or perform other tasks as it pertains to the RPM.

* **rpms** group is used as the final output/import of the RPM spec file and patches after it has been patched (if applicable) and is then used/picked up to build the SRPM and send to koji for build.

* **src** group (though not required) can be where a package's source can exist to help create patches if need be.

Note that SIGs or projects that plan on using the build system should be following this methodology.

### RPM Patching Structure

For the patch configuration, the layout must be followed strictly to ensure a SPEC file or its sources are modified accordingly. Here's an example below.

```
.
└── ROCKY
    ├── CFG
    │   └── browser.cfg
    └── _supporting
        ├── Bug-1238661---fix-mozillaSignalTrampoline-to-work-.patch
        ├── Bug-1526653---fix_user_vfp_armv7.patch
        └── firefox-rocky-default-prefs.js
```

At the top level, the **ROCKY** folder will hold two additional folders, **CFG** and **_supporting**.

The **CFG** directory will contain files that end in `.cfg` that tell the orchestrator what to do to the imports coming in the form of an action.

```
Action {
    file: "OriginalFile"
    with_file: "ROCKY/_supporting/RockyReplaceFile"
}
```

This goes into further detail at our [Debrand HowTo](https://wiki.rockylinux.org/team/release_engineering/debranding/) page.

### Branch Strategy

Typically when making a **patch** repo, the `main` branch is where everything should be. However, there are cases where this is not sufficient, especially in the case of major release version differences. Here's a general idea/example of how the branches will work:

* `main` is the universal branch that is always used during a patch
* `r8` is the Rocky 8 branch, specific to patching the corresponding RPM specs/patches for 8
* `r9` would be for Rocky 9
* `r9-beta` would be for Rocky 9 beta
* etc...

In practice when the patch process occurs, the `main` branch is parsed first and applied, and then if there is a corresponding `rX` branch, it would apply that next. There are cases too where `main` can be empty and you'll just have an `rX` branch. This is acceptable and will still work.

Note that with this strategy, merging branches is never recommended in most circumstances. Try to keep them separated where as best as possible and where absolutely needed. The only time branches should be merged or force-pushed is when going from `rXlh` to `rX-beta` or `rX-beta` to `rX`.

### Submitting a Potential Patch

There are a few ways to submit a patch to fix build issues in the main distribution. This section will break down some examples of ways you can put in a fix request for review.

#### Patch Repo Doesn't Exist

If there is a package failing, or you are looking to submit a patch for example to allow something to compile correctly on another architecture (e.g., `armv7`/`armhfp`), or perhaps you found a piece of the base that was not debranded properly, generally a bug report should be opened at our [Bug Tracker](https://bugs.rockylinux.org) with relevant information and logs. Opening a project under your namespace can be done and can eventually be transferred in into `staging` after review.

#### Patch Repo Exists

If there is a package failing because of a failing current patch, or a new patch is required, perhaps debranding must occur, you generally:

1. Fork the repo into your namespace
2. Make the relevant changes
3. Apply for a merge request/pull request

An appropriate bug tracking ticket should be opened, if not opened already (or automatically) to ensure there is documentation for this change.

{% include "releng/resources_bottom.md" %}
