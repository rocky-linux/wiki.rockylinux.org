---
title: Releasing Packages
---

## Release

### rocky-release packages

It is expected with Special Interest Groups that are delivering packages to have associated release packages that provide:

* Repo file(s) for dnf
* GPG key assosciated with the signing of your packages

During the initial request process, a GPG key is assigned to you in the build system to be used to sign your packages. A release package must be requested to be built and submitted to the extras repository. A request can be opened at [SIG/Core Issues](https://git.resf.org/sig_core/meta).

!!! info "Key/Package Restrictions"
    The Special Interest Group cannot submit a key nor can they have access to the private key. A SIG cannot submit their own release package.

When you are opening the request, use the following template:

* Title: [SIG] NAME_OF_SIG - Release Package Request
* How many repositories - By default a "common" repository is assigned.

  * Do you plan on having multiple versions of some software? (example: ceph, glusterfs)
  * Do you plan on having a separate modularity repository?

* What major releases? (eg, are you only building for 9?)
* Other comments you feel will be necessary for Release Engineering to be aware of

### Releasing Packages for your SIG

TBD

### Directory Format for Repositories (Informational)

This is more informational more than anything, but it is important for a SIG to know where their exported repositories will live.

Repositories will be formatted as such:

`/pub/sig/MAJOR/NAME/ARCH/PKG_OR_REPO`

This basically means that the sig directory will live along side the main distribution directories, potentially at the root a mirror. At `/pub/rocky` you'll see each supported major version. At `/pub/sig` you'll also see major versions, with a different structure. Let's break it down.

* `NAME` can be the name of the SIG or the abbreviation code (eg, cloud, kernel, mcs)
* `MAJOR` is the major version that's being targetted (8, 9, so on)
* `ARCH` is for the architecture
* `PKG_OR_REPO` could be for the specific set of packages of just any repository. (For example, you could have a "common" directory alongside the others)

Let's say for the sake of the example we need some repositories for mcs and we build for x86_64 and aarch64. It could look like this. This assumes the messaging and communication SIG has not only an ejabberd repository, but also a "common" repository that is perhaps shared with ejabberd and potentially another set of packages in the future.

```
.
├── rocky
│   ├── 8
│   └── 9
└── sig
    ├── 8
    │   └── mcs
    │       ├── aarch64
    │       │   ├── ejabberd
    │       │   │   ├── Packages
    │       │   │   └── repodata
    │       │   └── mcs-common
    │       │       ├── Packages
    │       │       └── repodata
    │       └── x86_64
    │           ├── ejabberd
    │           │   ├── Packages
    │           │   └── repodata
    │           └── mcs-common
    │               ├── Packages
    │               └── repodata
    └── 9
        └── mcs
            ├── aarch64
            │   ├── ejabberd
            │   │   ├── Packages
            │   │   └── repodata
            │   └── mcs-common
            │       ├── Packages
            │       └── repodata
            └── x86_64
                ├── ejabberd
                │   ├── Packages
                │   └── repodata
                └── mcs-common
                    ├── Packages
                    └── repodata
```

### Mirror List Queries (Informational)

Queries to a mirror list for SIG repositories will be like the standard calls, but repo names will have a format of `sig-NAME-MAJOR`. `NAME` can be a simple SIG name or abbreviate or a combination, for example, `sig-mcs-common` or `sig-cloud`.

{% include "releng/resources_bottom.md" %}
