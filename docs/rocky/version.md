---
title: Rocky Linux Release and Version Guide
---

This page goes over the Rocky Linux Release Versions, their support, timelines, and how it affects our users.

## Current Supported Releases

Below is a table of Rocky Linux versions, with accompanying general release and (planned or are planned) end of life dates.

| Release         | Codename       | Release Date  | Active Support Ends  | End of Life          | Latest/Current Version   |
|-----------------|----------------|---------------|----------------------|----------------------|--------------------------|
| Rocky Linux 8   | Green Obsidian | May 1, 2021   | May 31, 2024         | May 31, 2029         | 8.10 (May 31, 2024)      |
| Rocky Linux 9   | Blue Onyx      | July 14, 2022 | May 31, 2027         | May 31, 2032         | 9.5 (November 19, 2024)  |

For more detailed information on each version, click any of the tabs below.

{% include "releng/version_table.md" %}

See the [Timeline and Terminology](#timeline-and-terminology) and [Release Cadence](#release-cadence) sections for more information on how these dates are determined.

## Timeline and Terminology

### Terminology

Throughout this page, you will see terms such as "major version" or "minor version", among others. You will see these terms used throughout many discussions online forums, mail lists, or even our Mattermost. See below for their basic definitions.

| Term           | Definition                                                                                                                                                        |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Major Version  | A major version is denoted by a whole number, such as "Rocky Linux 9". This number is left-most number in a version, such as 9.0, where "9" is the major version. These releases come with significant changes to its preceding major version. |
| Minor Version  | A minor version is denoted by the right-most number in a version, such as "Rocky Linux 9.3". "9" being the major version, "3" being the minor version. These updates come with version upgrades, rebases, new software and features. |
| Release        | Release typically refers to a major version release, such as "Rocky Linux 9". It is typically assumed it is referring to the latest/current version of that release. |
| Minor Release  | Used as "Minor Version" in most cases. |
| Active Support | Active support, also known as "full support" is the period of time in which minor releases are provided every six (6) months, whilst providing new software, rebases, or other new features. When Active Support ends, a release receives maintenance-only updates. |

### Timeline

Rocky Linux attempts to follow CentOS Stream development and Red Hat Enterprise Linux releases as close as possible. With this model, Rocky Linux releases should follow fairly close to our upstreams.

#### Major Version Release

For a new Rocky Linux release, the following should be true:

* New major version is released with support of ten (10) years, starting at `.0`.
* Release will have five (5) years of minor version updates or "active support"

    * Each major version will come with two minor version releases a year: Every six (6) months
    * Minor version releases will come with new features, software rebases, and sometimes brand new software
    * Final minor version will be `.10`

#### Minor Version Release

For a new Rocky Linux minor version release, the following should be true:

* New minor version is released with new features and/or software
* Previous minor version is moved to the [vault](repo.md#vault) and is no longer supported

However, when the minor version is `.10`, this means:

* Rocky Linux (and other Enterprise Linux derivatives) go into security maintenance for the next five (5) years
* This version of Rocky Linux will likely not receive new features, but new packages may appear occasionally

### Release Schedule

Based on Red Hat's life cycle policy, the month of May is when new major versions are released *and* every May and November a new minor version release is provided for prior supported releases. Rocky Linux attempts to follow this system as closely as possible.

Below is a general guideline (based on Red Hat documentation) for the "full support" cycle for Rocky Linux.

| Version | Month    |
|---------|----------|
| .0      | May      |
| .1      | November |
| .2      | May      |
| .3      | November |
| .4      | May      |
| .5      | November |
| .6      | May      |
| .7      | November |
| .8      | May      |
| .9      | November |
| .10*    | May      |

Upon each new minor release, (`X.Y+1`), the previous version is no longer supported and is moved to the [vault](repo.md#vault).

!!! warning "X.10"
    `X.10` is the final minor release. When it is released, that version of Rocky Linux is now in maintenance mode for the next five (5) years until End of Life, receiving only maintenance related updates. CentOS Stream X will also cease development upstream. This marks the end of "active support".

## Version Policy

Rocky Linux attempts to follow closely with the updates of our upstream Red Hat Enterprise Linux. This means that updates aim to be released as on time as possible.

**For Rocky Linux 8 and 10**: Previous versions of packages will coexist in the repositories to allow a user to downgrade in case of a regression or other use cases (such as security only updates).

**For Rocky Linux 9**: This policy is not currently supported and can be expected in a future Rocky Linux version. Please see [Peridot Issue #18](https://github.com/rocky-linux/peridot/issues/18). Older versions of packages can by found in [Koji](https://kojidev.rockylinux.org) when they're uploaded or the vault.

**For all Rocky Linux versions**: When a new minor release arrives, all previous updates/versions are *not* carried over and will be found in the vault.

### General Update Timeline

Updates for Rocky Linux are generally expected to be built and released between twenty-four (24) and fourty-eight (48) hours, assuming best effort allows the packages to build without any complications or unforeseen added dependencies by upstream mid-support cycle.

Minor releases for Rocky Linux are generally expected to be built and released at least a week (7 days) after upstream, assuming best effort allows the packages to build without any complications and it passes the Testing Team OpenQA and general testing.

Major releases for Rocky Linux are expected to be built and released when they are ready, assuming best effort allows the packages to build without any complications and passes the Testing Team OpenQA and other general testing. Major Releases have no guaranteed ETA.

## End of Life and Unsupported Release/Version Policy

A release or version of Rocky Linux is considered unsupported if:

* The Rocky Linux minor version has been superseded by another release *or*
* The Rocky Linux release is End of Life

See the examples below.

### Example: An Unsupported Version

When a new Rocky Linux minor release arrives in May/November, the following is true:

* The previous version is no longer supported by Release Engineering and the community
* This version is no longer updated and is moved to the [vault](http://dl.rockylinux.org/vault/rocky/).
* This version **does not** receive bug fix nor security updates.
* You are recommended to update your system with `dnf update`.

### Example: An End of Life Release

When a Rocky Linux release has reached its End of Life date typically after ten (10) years (for example, May of 2029), the following is true:

* The release is no longer supported in full by Release Engineering and the community
* The final version is moved to the [vault](http://dl.rockylinux.org/vault/rocky/).
* This release no longer receives updates and thus no longer supported.
* You are recommended to install a supported Rocky Linux version and migrate your data.

If you cannot install a new system and migrate and you still need support for your system or systems, you may be able to find a support provider.

!!! warning
    Support providers will maintain their own packages and policies outside of the Rocky Linux ecosystem, and thus their policies *do not* apply here. The release is still considered EOL and unsupported by the Rocky Linux project.

## Beta to Stable Policy

Rocky Linux may release beta versions when possible. These are typically close to our upstreams where reasonably possible. These are released specifically to find bugs or issues in our build process. This also helps correlate issues with our upstreams in the event they also have bugs. These are provided to our Testing Team members and others in the community and are free to download and test by anyone in the community.

However, when the stable minor version is released, updating from the beta to the stable version is not recommended nor is it supported, even for experienced users.

The following is unsupported:

* Updating from a stable release to beta release
* Updating from a beta release to stable release

## Upgrade Policy

Upgrades are not generally supported by Release Engineering nor most of the Rocky community. If you wish to perform upgrades between releases, there is a tool called ELevate that may be able to help you. But as a note of caution, this has not been formally tested and we cannot provide official assistance.

!!! warning
    Some users have expressed success with doing upgrades with this tool. However, it is not formally tested by the Rocky Linux project and we cannot provide official assistance.

!!! note
    If you wish to be part of an effort to ensure upgrades are possible, we recommend that you join us in our Mattermost and ask how you can help.
