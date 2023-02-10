---
title: Reporting Bugs and Requests for Enhancementx
---

The Rocky Linux Project has several ways of reporting issues or requesting enhancements, depending on what the issue is and who it pertains to. This page aims to try to steer you in the right direction on where to go.

## Rocky Linux (core distribution)

### Bugs

Bugs are an inevitable part of any Linux distribution. Users may find problems and want a way to report the bug.

All bug reports (which includes packages from Special Interest Groups) should be reported at our [Bug Tracker](https://bugs.rockylinux.org).

When reporting bugs, ensure you have read the [Bug Tracker Guidelines](../guidelines/bug_tracker_guidelines.md) so you can make a proper bug report.

!!! note
    You may be asked to reproduce the issue on Red Hat Enterprise Linux. If the issue is reproducible on RHEL, you are encouraged to also open a bug report at the [Red Hat Bugzilla](https://bugzilla.redhat.com). The assignee on your bug report can do this for you also if you wish.

### RFE

Requests for Enhancements to packages[^1] are typically handled at the [Bug Tracker](https://bugs.rockylinux.org). In some cases, this may not apply. A Special Interest Group may ask that an RFE be submitted elsewhere. See the SIG section later in this page.

## Rocky Linux Infrastructure and Services

Rocky Linux Infrastructure have responsibility over several areas. Below is just some of what is maintained:

* [Mirror Manager](https://mirrors.rockylinux.org)
* [Account Services](https://accounts.rockylinux.org)
* [RESF Git Service](https://git.resf.org)
* [Rocky Linux Git Service](https://git.rockylinux.org)
* [Mail List](https://lists.resf.org)
* General Special Interest Group requests (such as resources)

Infrastructure and Services encourages issues and requests to be submitted to their [Infrastructure Meta](https://git.resf.org/infrastructure/meta/issues) tracker.

## Rocky Linux Special Interest Groups (SIG)

Each Special Interest Group may do things a bit differently from the next. In majority of cases, a SIG will receive a group at the [RESF Git Service](https://git.resf.org) and a "meta" repository. However, a SIG can choose not to use this and note on their wiki of where to go.

Examples of SIG's that use "meta" are below:

* [SIG/Core](https://git.resf.org/sig_core/meta/issues)
* [SIG/AltArch](https://git.resf.org/sig_altarch/meta/issues)

## Other Resources

If you have reproduced a bug or an issue in RHEL (or even Stream), or you would like to request something for a future Enterprise Linux version (that will make it to Rocky Linux in a future version), you are encouraged to submit a report to the [Red Hat Bugzilla](https://bugzilla.redhat.com). Below are some quick links for submitting such requests.

* [Red Hat Enterprise Linux 8](https://bugzilla.redhat.com/enter_bug.cgi?product=Red%20Hat%20Enterprise%20Linux%208) - For RHEL 8 bugs found in both Rocky Linux and RHEL 8
* [Red Hat Enterprise Linux 9](https://bugzilla.redhat.com/enter_bug.cgi?product=Red%20Hat%20Enterprise%20Linux%209) - For RHEL 9 bugs found in both Rocky Linux and RHEL 9
* [CentOS Stream 8](https://bugzilla.redhat.com/enter_bug.cgi?product=Red%20Hat%20Enterprise%20Linux%208&version=CentOS%20Stream) - Bugs or RFE's for CentOS Stream 8
* [CentOS Stream 9](https://bugzilla.redhat.com/enter_bug.cgi?product=Red%20Hat%20Enterprise%20Linux%209&version=CentOS%20Stream) - Bugs or RFE's for CentOS Stream 9

[^1]: Packages may be for a core Rocky Linux package or a Special Interest Group package. Note that if an RFE is put in for a Rocky Linux core package, it will most likely be rejected and you may be encouraged to request it upstream to CentOS Stream. If the RFE is to a package that contains `rocky-` in the name *or* it is a package that we actively patch, it may be considered. RFE's to prepare for upcoming features from Stream to RHEL (e.g. to prepare for said feature) is encouraged.
