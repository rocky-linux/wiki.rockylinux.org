---
title: Managing Content
---

This section goes over how to manage content in git and the community build system.

## Importing to the RESF Git Service

All Special Interset Groups get an organization created in the RESF Git Service. Each organization will have a `meta` repository that can track issues or requests for the SIG as a whole. This is not a requirement and each SIG can dictate how issues or requests are handled.

There is no strict requirement on what repositories should and should not exist. It is up to the discretion of the SIG.

## Importing to the Rocky Linux GitLab

Special Interest Groups that build and release packages will have a subgroup under `SIG`. This subgroup will have additional subgroups, `src`, `rpms`, `modules`.

!!! info "Additional Subgroups"
    While this is the default layout, additional subgroups can be made at the root of the SIG group. It is expected that some SIG's may not have plans to build packages as they could have an entirely separate focus.

### rpms

This area is specifically used for rpm sources (spec file, patches, light text files). The expected format is:

* `SOURCES/...` -- light text files, scripts, patches, etc can come here (eg ones not in a tar ball)
* `SPECS/name.spec` -- Your spec file comes here - note it should only be one spec file
* `.name.metadata` -- Required, lists your source archives or otherwise that will be in lookaside. Empty if there are no sources to pull from lookaside.

The metadata file format is expected to be:

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

### Tagging

In the case of an rpm or a module, there should be tags associated, otherwise the build system will *not* pick up your builds. The general format for a tags are as follows:

* RPM: `imports/rX/NEVR` (for example, `imports/r8/bash-4.4.20-2.el8` is acceptable)
  * Note: You cannot choose a tag/branch destined for one rocky release and build on another. Ensure your tags and branches are in alignment.

* Module: `imports/rX-stream-STREAM_NAME_OR_VERSION/MODULE_NAME-STREAM_NAME_OR_VERSION-X0Y00YYYYMMDDHHMMSS.ZZZZZZZZ`
  * Note: X is the major version, Y is the minor version. MODULE_NAME and STREAM_NAME_OR_VERSION are required. Ensure you fill out the timestamp as appropriate. You may fill in the final Z's with a portion of the commit hash that you are using for the tag.
  * Example: `imports/r8-stream-1.4/389-ds-1.4-8060020220204145416.ce3e8c9c`

### Peridot Configuration

Each Special Interest Group will need a repository called `peridot-config` which will contain the content of the special interest group. This helps identify what repositories will exist and what exists in each repository. The default file is `catalog.cfg`. Below is just a simple example using SIG/Core.

```
# kind: resf.peridot.v1.CatalogSync
package {
  name: "some-core-tool"
  type: PACKAGE_TYPE_NORMAL_SRC
  repository {
    name: "core-common"
    include_filter: "core-tool-mgt.noarch"
    include_filter: "core-tool-keys.noarch"
  }
}

package {
  name: "some-infra-tool"
  type: PACKAGE_TYPE_NORMAL_SRC
  repository {
    name: "core-infra"
    include_filter: "infra-tool-mgt.x86_64"
    include_filter: "infra-tool-mgt.aarc64"
    include_filter: "infra-tool-mgt.s390x"
    include_filter: "infra-tool-mgt.ppc64le"
    include_filter: "infra-tool-keys.noarch"
  }
}
```

Below was a SIG/Cloud example.

```
# kind: resf.peridot.v1.CatalogSync
exclude_filter {
  repo_match: "^cloud-common$"
  arch {
    key: "*"
    glob_match: "kernel-debug-devel-matched"
  }
}
package {
  name: "kernel"
  type: 2
  repository {
    name: "cloud-common"
    # use an include filter, then exclude same NA to force an empty repo
    include_filter: "kernel-debug-devel-matched.aarch64"
  }
  repository {
    name: "cloud-kernel"
    include_filter: "kernel-debug-devel-matched.aarch64"
    include_filter: "kernel-debug-devel.aarch64"
. . .
  }
}
```

## Importing to S3

TBD

{% include "releng/resources_bottom.md" %}
