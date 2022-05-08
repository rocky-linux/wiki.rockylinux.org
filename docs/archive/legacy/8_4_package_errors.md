---
title: Rocky Release 8.4 Package Errors
---

This page tracks package fixes/progress for the upcoming 8.4 release.  Packages are tracked in a table with package name, Koji build link, assignee, and notes.

Packages that are fixed will be marked with a ~~strikethrough~~ to indicate they're done.

Packages are considered fixed only after they have a successful build in Koji.

<br />
<br />

| Package | Koji Link | Assignee | Notes |
|:--------|-------|--------|-------|
| ~~spirv-tools-2020.5-3.20201208~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8403~~ | ~~N/A~~ | ~~Neil: Last time we had to tag to an older release of spirv-headers - we likely need to update this.~~ |
| ~~python-cryptography~~ | https://kojidev.rockylinux.org/koji/buildinfo?buildID=8353 | Skip Grube | Relies on new python-cryptography-vectors c8s branch; Neil: Removed unnecessary patch from 8.3 |
| dotnet3*/dotnet5* | https://kojidev.rockylinux.org/koji/buildinfo?buildID=8326 | Michael Young | Import/patch issue?  Also might be memory issues with building large SRPM on i686 ; 2021-05-27 - see comment below |
| ~~rhel-system-roles~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8376~~ | ~~N/A~~ | ~~No matching package to install: 'python3dist(ruamel.yaml)'~~ |
| ~~pandoc~~ | https://kojidev.rockylinux.org/koji/buildinfo?buildID=8340 | Neil Hanlon / ashman / others | ~~Need to bootstrap + build "hscolour and it should be fixed  - Had to enable bootstrapping on ghc-rpm-macros (built as %{RELEASE}.1) and then build hscolour as well with a bootstrapping patch to not have a circular dependency on ghc-rpm-macros to hscolour.~~|
| ~~texlive~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8464~~ | ~~Jordan Pisaniello~~ | ~~Compiler error : ../../../texk/web2c/pdftexdir/pdftosrc.cc:91:25: error: 'unique_ptr' is not a member of 'std' (and others)~~ |
| ~~xdp-tools~~ | ~~https://kojidev.rockylinux.org/koji/taskinfo?taskID=80568~~ | N/A | ~~Compiler error libbpf support: FORCE_SYSTEM_LIBBPF is set, but no usable libbpf found~~ |
| ~~libreoffice~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8315~~ | ~~Skip Grube~~ | Needs mdds-1.5 (c8s branch), then new liborcus, then can compile this |
| ~~gupnp~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8213~~ | ~~Skip Grube~~ | ~~gupnp: need 'gssdp-devel >= 1.0.5' first (new hidden dependency?)~~ |
| ~~libdazzle~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8265~~ |  N/A | ~~libdazzle: aarch64 error:  failed test "test-recursive-monitor" - see build.log for more info~~ |
| ~~libuv~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8297~~ | ~~N/A~~ | ~~Several failed tests, but ONLY on i686~~ |
| ~~libwacom~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8306~~ | ~~Skip Grube~~ | ~~libwacom:  need to update meson:  meson.build:1:0: ERROR:  Meson version is 0.49.2 but project requires >= 0.50.0.~~ |
| ~~libbpf~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8263~~ | ~~N/A~~ | ~~/usr/bin/strip:/builddir/build/BUILDROOT/libbpf-0.2.0-1.el8.x86_64/usr/lib64/st9U4xP0/libbpf-in.o[.gnu.build.attributes]: error: failed to copy merged notes into output: Bad value (???)~~ |
| ~~bcc~~ | ~~https://kojidev.rockylinux.org/koji/taskinfo?taskID=80556~~ | N/A | ~~Needs new kernel release~~ |
| ~~gssdp~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8209~~ | N/A | ~~failing test "test-functional" ONLY on i686~~ |
| ~~gnome-settings-daemon~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8204~~ | ~~Skip Grube~ |  ~~Spec file is incorrectly configured or macro is being defined~~ |
| ~~ghostscript~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8195~~ | N/A | ~~Compiler errors: from ./base/sjbig2.c:26:/usr/include/jbig2.h:93:11: note: expected 'Jbig2ErrorCallback' {aka 'int (*)(void *, const char *, enum <anonymous>,  int)'} but argument is of type 'void (*)(void *, const char *, Jbig2Severity,  int32_t)' {aka 'void (*)(void *, const char *, enum <anonymous>,  int)'} (and others)~~ |
| ~~dnf~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8147~~ | ~~Skip Grube~~ | ~~No matching package to install: 'python3-hawkey >= 0.55.0-5' (new hidden dep?)~~ |
| ~~dlm~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8137~~ | ~~N/A~~ | ~~compiler errors: member.c:113:86: error: parameter 2 ('ring_id') has incomplete type~~ |
| ~~corosync~~ | ~~https://kojidev.rockylinux.org/koji/buildinfo?buildID=8122~~ | ~~Skip Grube~~ | ~~No matching package to install: 'libknet1-devel >= 1.18' (hidden dep?  or something not compiled yet?)~~ |
| ~~bpftrace~~ | ~~https://kojidev.rockylinux.org/koji/taskinfo?taskID=80558~~ | N/A | ~~Compiler error - likely fixed by new libbpf(?)~~ |



### Annotations
 #### dotnet3.1
  **From Michael Young on 2021-05-27**
  >Hey @Skip Grube I have been quiet all week because dotnet is kicking my butt. I thought it would be as simple as redoing the patch. I have been working with dotnet3.1. It doesn't seem to like the minor version that is now in os-release for rocky 8.4. When I redid the patch and built with just the major version, it builds... But with the major and minor, it fails.
  >
  >Wanted to put a note here since I am going to be away from a computer until Monday and don't want to leave everyone hanging... Not sure if there is a date in mind besides as soon as possible. If anyone wants to take a stab at it, be my guest. Otherwise, I will keep plugging away at it... I think I am close to getting it to use the runtime I'd of rocky-8.4
