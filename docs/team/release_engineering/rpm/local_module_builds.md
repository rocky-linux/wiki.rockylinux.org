---
title: Local Module Builds
---

Within the Fedora and Red Hat ecosystem, modularity is unfortunately a piece
that is a blessing and a curse. It might be more one way or the other.

This page is primarily to talk about how to do local builds for modules,
including the final formatting of the module yaml description that will have to
be imported into the repo via `modifyrepo_c`.

Note that the below is based on how `lazybuilder` performs module builds, which
was made to be close to MBS+Koji and is not perfect. This is mostly used as a
reference.

## Contact Information
| | |
| - | - |
| **Owner** | Release Engineering Team |
| **Email Contact** | releng@rockylinux.org |
| **Email Contact** | infrastructure@rockylinux.org |
| **Mattermost Contacts** | `@label` `@mustafa` `@neil` `@tgo` |
| **Mattermost Channels** | `~Development` |

## Building Local Modules

This section explains what it's like to build local modules, what you can do,
and what you can expect.

### Module Source, "transmodrification", pulling sources

The module source typically lives in a `SOURCES` directory in a module git repo
with the name of `modulemd.src.txt`. This is a basic version that could be used
to do a module build. Each package listed is a reference to the stream version
for that particular module.

```
document: modulemd
version: 2
data:
  stream: 1.4
  summary: 389 Directory Server (base)
  description: >-
    389 Directory Server is an LDAPv3 compliant server.  The base package includes
    the LDAP server and command line utilities for server administration.
  license:
    module:
    - MIT
  dependencies:
  - buildrequires:
      nodejs: [10]
      platform: [el8]
    requires:
      platform: [el8]
  filter:
    rpms:
    - cockpit-389-ds
  components:
    rpms:
      389-ds-base:
        rationale: Package in api
        ref: stream-1.4-rhel-8.4.0
        arches: [aarch64, ppc64le, s390x, x86_64]
```

Notice `ref`? That's the reference point. When a "transmodrification" occurs,
the process is supposed to look at each RPM repo in the components['rpms']
list. The branch name that this module data lives in will be the basis of how
it determines what the *new* references will be. In this example, the branch
name is `r8-stream-1.4` so when we do the "conversion", it should become
a git commit hash of the last commit in the branch `r8-stream-1.4` for that
particular rpm component.

```
document: modulemd
version: 2
data:
  stream: "1.4"
  summary: 389 Directory Server (base)
  description: 389 Directory Server is an LDAPv3 compliant server.  The base package
    includes the LDAP server and command line utilities for server administration.
  license:
    module:
    - MIT
  dependencies:
  - buildrequires:
      nodejs:
      - "10"
      platform:
      - el8
    requires:
      platform:
      - el8
  filter:
    rpms:
    - cockpit-389-ds
  components:
    rpms:
      389-ds-base:
        rationale: Package in api
        ref: efe94eb32d597765f49b7b1528ba9881e1f29327
        arches:
        - aarch64
        - ppc64le
        - s390x
        - x86_64
```

See the reference now? It's now a commit hash that refers directly to 389-ds-base
on branch `r8-stream-1.4`, being the last commit/tag. See the glossary at the
end of this page for more information, as it can be a commit hash, branch, or
tag name.

### Configuring Macros and Contexts

Traditionally within an MBS and Koji system, there are several macros that
are created and are usually unique per module stream. There are certain
components that work together to create a unique `%dist` tag based on several
factors. To summarize, here's what generally happens:

* **A module version is formed as** `M0m0YYYYMMDDhhmmss`**, which would be the major version, 0, minor version, 0, and then a timestamp.**
* **Select components are brought together and a sha1 hash is made, shortened to 8 characters for the context**

  * The runtime context is typically the "dependencies" section of the module source, calculated to sha1
  * The build context is the `xmd['mbs']['buildrequires']` data that koji generates and is output into `module.txt`, calculated to sha1
  * The runtime and build contexts are combined `BUILD:RUNTIME`, a sha1 is calculated, and then shortened to 8
  * This context is typically the one that changes less often

* **Select components are brought together and a sha1 hash is made, shortened to 8 characters for the dist tag**

  * The module name, stream, version, and context are all brought together as `name.stream.version.context`, calculated to sha1

* **The `%dist` tag is given a format of** `.module_elX.Y.Z+000+00000000`

  * X is the major version, Y is the minor version, Z is typically 0.
  * The second number is the iteration, aka the module number. If you've done 500 module builds, the next one would be 501, regardless of module.
  * The last set is a context hash generated earlier in the step above

#### Configuring the Macros

In koji+MBS, a module macros package is made that defines the module macros.
In lazybuilder, we skip that and define the macros directly. For example, in
mock, we drop a file with all the macros we need. Here's an example of 389-ds.
The file name is is `macros.zz-modules` to ensure these macros are picked up
last and will have precendence and override macros of similar names, especially
the `%dist` tag.

```
rpmbuild# cat /etc/rpm/macros.zz-modules

%dist .module_el8.4.0+636+837ee950
%modularitylabel 389-ds:1.4:8040020210810203142:866effaa
%_module_build 1
%_module_name 389-ds
%_module_stream 1.4
%_module_version 8040020210810203142
%_module_context 866effaa
```

The the `%dist` tag honestly is the most important piece here. But all of
these tags are required regardless.

##### Build Opts Macros

Some modules may have additional buildopts macros. Perl is a *great* example
of this. When koji+MBS make their module macros package for the build, they
combine the module macros and the build opts macros together into one file.
It will be the same exact file name each time.

```
rpmbuild# cat /etc/rpm/macros.zz-modules

# Module macros
%dist .module+el8.4.0+463+10533ad3
%modularitylabel perl:5.24:8040020210602173155:162f5753
%_module_build 1
%_module_name perl
%_module_stream 5.24
%_module_version 8040020210602173155
%_module_context 162f5753

# Build Opts macros
%_with_perl_enables_groff 1
%_without_perl_enables_syslog_test 1
%_with_perl_enables_systemtap 1
%_without_perl_enables_tcsh 1
%_without_perl_Compress_Bzip2_enables_optional_test 1
%_without_perl_CPAN_Meta_Requirements_enables_optional_test 1
%_without_perl_IPC_System_Simple_enables_optional_test 1
%_without_perl_LWP_MediaTypes_enables_mailcap 1
%_without_perl_Module_Build_enables_optional_test 1
%_without_perl_Perl_OSType_enables_optional_test 1
%_without_perl_Pod_Perldoc_enables_tk_test 1
%_without_perl_Software_License_enables_optional_test 1
%_without_perl_Sys_Syslog_enables_optional_test 1
%_without_perl_Test_Harness_enables_optional_test 1
%_without_perl_URI_enables_Business_ISBN 1
```

#### Built Module Example

Let's break down an example of `389-ds` - It's a simple module. Let's start
with `modulemd.txt`. Notice how it has `xmd` data. That is an integral part
of making the context, though it's mostly information for koji and MBS and
is generated on the fly and used throughout the build process for each
arch. In the context of lazybuilder, it creates fake data to essentially
fill the gap of not having MBS+Koji in the first place. The comments will
point out what's used to make the contexts.

```
---
document: modulemd
version: 2
data:
  name: 389-ds
  stream: 1.4
  version: 8040020210810203142
  context: 866effaa
  summary: 389 Directory Server (base)
  description: >-
    389 Directory Server is an LDAPv3 compliant server.  The base package includes
    the LDAP server and command line utilities for server administration.
  license:
    module:
    - MIT
  xmd:
    mbs:
      # This section xmd['mbs']['buildrequires'] is used to generate the build context
      # This is typically made before hand and is used with the dependencies section
      # to make the context listed above.
      buildrequires:
        nodejs:
          context: 30b713e6
          filtered_rpms: []
          koji_tag: module-nodejs-10-8030020210426100849-30b713e6
          ref: 4589c1afe3ab66ffe6456b9b4af4cc981b1b7cdf
          stream: 10
          version: 8030020210426100849
        platform:
          context: 00000000
          filtered_rpms: []
          koji_tag: module-rocky-8.4.0-build
          ref: virtual
          stream: el8.4.0
          stream_collision_modules: 
          ursine_rpms: 
          version: 2
      commit: 53f7648dd6e54fb156b16302eb56bacf67a9024d
      mse: TRUE
      rpms:
        389-ds-base:
          ref: efe94eb32d597765f49b7b1528ba9881e1f29327
      scmurl: https://git.rockylinux.org/staging/modules/389-ds?#53f7648dd6e54fb156b16302eb56bacf67a9024d
      ursine_rpms: []
  # Dependencies is part of the context combined with the xmd data. This data
  # is already in the source yaml pulled for the module build in the first place.
  # Note that in the source, it's usually `elX` rather than `elX.Y.Z` unless
  # explicitly configured that way.
  dependencies:
  - buildrequires:
      nodejs: [10]
      platform: [el8.4.0]
    requires:
      platform: [el8]
  filter:
    rpms:
    - cockpit-389-ds
  components:
    rpms:
      389-ds-base:
        rationale: Package in api
        repository: git+https://git.rockylinux.org/staging/rpms/389-ds-base
        cache: http://pkgs.fedoraproject.org/repo/pkgs/389-ds-base
        ref: efe94eb32d597765f49b7b1528ba9881e1f29327
        arches: [aarch64, ppc64le, s390x, x86_64]
...
```

Below is a version meant to be imported into a repo. This is after the build's
completion. You'll notice that some fields are either empty or missing from
above or even from the git repo's source that we pulled from initially. You'll
also notice that xmd is now an empty dictionary. This is on purpose. While it
is optional in the repo module data, the build system typically gives it `{}`.

```
---
document: modulemd
version: 2
data:
  name: 389-ds
  stream: 1.4
  version: 8040020210810203142
  context: 866effaa
  arch: x86_64
  summary: 389 Directory Server (base)
  description: >-
    389 Directory Server is an LDAPv3 compliant server.  The base package includes
    the LDAP server and command line utilities for server administration.
  license:
    module:
    - MIT
    content:
    - GPLv3+
  # This data is not an empty dictionary. It is required.
  xmd: {}
  dependencies:
  - buildrequires:
      nodejs: [10]
      platform: [el8.4.0]
    requires:
      platform: [el8]
  filter:
    rpms:
    - cockpit-389-ds
  components:
    rpms:
      389-ds-base:
        rationale: Package in api
        ref: efe94eb32d597765f49b7b1528ba9881e1f29327
        arches: [aarch64, ppc64le, s390x, x86_64]
  artifacts:
    rpms:
    - 389-ds-base-0:1.4.3.16-19.module+el8.4.0+636+837ee950.src
    - 389-ds-base-0:1.4.3.16-19.module+el8.4.0+636+837ee950.x86_64
    - 389-ds-base-debuginfo-0:1.4.3.16-19.module+el8.4.0+636+837ee950.x86_64
    - 389-ds-base-debugsource-0:1.4.3.16-19.module+el8.4.0+636+837ee950.x86_64
    - 389-ds-base-devel-0:1.4.3.16-19.module+el8.4.0+636+837ee950.x86_64
    - 389-ds-base-legacy-tools-0:1.4.3.16-19.module+el8.4.0+636+837ee950.x86_64
    - 389-ds-base-legacy-tools-debuginfo-0:1.4.3.16-19.module+el8.4.0+636+837ee950.x86_64
    - 389-ds-base-libs-0:1.4.3.16-19.module+el8.4.0+636+837ee950.x86_64
    - 389-ds-base-libs-debuginfo-0:1.4.3.16-19.module+el8.4.0+636+837ee950.x86_64
    - 389-ds-base-snmp-0:1.4.3.16-19.module+el8.4.0+636+837ee950.x86_64
    - 389-ds-base-snmp-debuginfo-0:1.4.3.16-19.module+el8.4.0+636+837ee950.x86_64
    - python3-lib389-0:1.4.3.16-19.module+el8.4.0+636+837ee950.noarch
...
```

The final "repo" of modules (per arch) is eventually made with a designation
like:

```
module-NAME-STREAM-VERSION-CONTEXT

module-389-ds-1.4-8040020210810203142-866effaa
```

This is what pungi and other utilities bring in and then combine into a single
repo, generally, taking care of the module.yaml.

#### Default Modules

Most modules will have a set default that would be expected if a dnf install
was called. For example, in EL8 if you said `dnf install postgresql-server`,
the package that gets installed is version 10. If a module doesn't have a
default set, a `dnf install` will traditionally not work. To ensure a module
package will install without having to enable them and to use the default,
you need default information. Here's the postgresql example.

```
---
document: modulemd-defaults
version: 1
data:
  module: postgresql
  stream: 10
  profiles:
    9.6: [server]
    10: [server]
    12: [server]
    13: [server]
...
```

Even if a module only has one stream, default module information is still
needed to ensure that a package can be installed without enabling the module
explicitly. Here's an example.

```
---
document: modulemd-defaults
version: 1
data:
  module: httpd
  stream: 2.4
  profiles:
    2.4: [common]
...
```

This type of information is expected by pungi as a default modules repo that
can be configured. These YAML's are not with the modules themselves. They are
brought in when the repos are being created in the first place.

In the context of lazybuilder, it checks for defaults if enabled and then the
final repo that's made of the results will immediately have the information
at the top. See the references below for the jinja template that lazybuilder
uses to generate this information.

As a final note, let's say an update comes in for postgresql and you want to
ensure that the old version of postgresql 10 and the updated version of 10
can stay together. This is when the final module data is combined together
and then it's added into the repo using `modifyrepo_c`. Note though, you do
*not* have to have the modulemd-defaults provided again. You can have it once
such as the first time you made the repo in the first place, and it will still
work.

### Building the packages

So we have an idea of how the module data itself is made and managed. All there
is left to do is to do a chain build in mock. The kicker is you need to pay
attention to the build order that is assigned to each package being built. **If
a build order isn't assigned, assume that it's group 0 and will be built first.**
This does not stop 0 being assigned, but just know that `buildorder` being
omitted implies group 0. See below.

```
    components:
        rpms:
            first:
                rationale: core functions
                ref: 3.0
                buildorder: 0
            second:
                rationale: ui
                ref: latest
                buildorder: 0
            third:
                rationale: front end
                ref: latest
                buildorder: 1
```

What this shows is that the packages in build group 0 can be built simultaneously
in the context of Koji+MBS. For a local build, you'd just put them first in the
list. Basically each of these groups have to be done, completed, and available
right away for the next package or set of packages. For koji+mbs, they do this
automatically since they have a tag/repo that gets updated on each completion
and the builds are done in parallel.

For mock, a chain build will always have an internal repo that it uses, so each
completed package will have a final createrepo done on it before moving on to the
next package in the list. It's not parallel like koji, but it's still consistent.

Essentially a mock command would look like:

```
mock -r module.cfg \
  --chain \
  --localrepo /var/lib/mock/modulename \
  first.src.rpm \
  second.src.rpm \
  third.src.rpm
```

### Making the final YAML and repo

It's probably wise to have a template to make the module repo data off of. It's
the same as having a script to "transmodrify" the module data properly to be
used. Having a template will simplify a lot of things and will make it easier
to convert the data from git and then the final build artifacts and data that
makes the module data. The lazybuilder template is a good starting point,
though it is a bit ugly, being made in jinja. It can be made better using
python or even golang.

Regardless, you should have it templated or scripted somehow. See the references
in the next section.

### A note about virtual modules

Virtual modules are weird. They do not have a module dist tag, and they are just
built like... any other RPM. The difference here is that a virtual module while
it will should have an api['rpms'] list, it will **not** have an artifacts section.

A huge example of this is perl:5.26 in EL8. perl 5.26 is the default version. If
you install perl-interpreter, you'll get `perl-interpreter-5.26.3-419.el8_4.1.x86_64`.
Notice how it doesn't have a module tag? That's because it wasn't built directly
in MBS. There are not many virtual modules, but this is important to keep in mind
that these do in fact exist. The module yaml itself will *not* have a list of
packages to build, aka a "components" section. Here's the current EL8 perl 5.26 example.

```
document: modulemd
version: 2
data:
    summary: Practical Extraction and Report Language
    description: >
        Perl is a high-level programming language with roots in C, sed, awk
        and shell scripting. Perl is good at handling processes and files, and
        is especially good at handling text. Perl's hallmarks are practicality
        and efficiency. While it is used to do a lot of different things,
        Perl's most common applications are system administration utilities
        and web programming.
    license:
        module: [ MIT ]
    dependencies:
        - buildrequires:
              platform: [el8]
          requires:
              platform: [el8]
    references:
        community: https://docs.pagure.org/modularity/
    profiles:
        common:
            description: Interpreter and all Perl modules bundled within upstream Perl.
            rpms:
                - perl
        minimal:
            description: Only the interpreter as a standalone executable.
            rpms:
                - perl-interpreter
    api:
        rpms:
            - perl
            - perl-Archive-Tar
            - perl-Attribute-Handlers
            - perl-autodie
            - perl-B-Debug
            - perl-bignum
            - perl-Carp
            - perl-Compress-Raw-Bzip2
            - perl-Compress-Raw-Zlib
            - perl-Config-Perl-V
            - perl-constant
            - perl-CPAN
            - perl-CPAN-Meta
            - perl-CPAN-Meta-Requirements
            - perl-CPAN-Meta-YAML
            - perl-Data-Dumper
            - perl-DB_File
            - perl-devel
            - perl-Devel-Peek
            - perl-Devel-PPPort
            - perl-Devel-SelfStubber
            - perl-Digest
            - perl-Digest-MD5
            - perl-Digest-SHA
            - perl-Encode
            - perl-Encode-devel
            - perl-encoding
            - perl-Env
            - perl-Errno
            - perl-experimental
            - perl-Exporter
            - perl-ExtUtils-CBuilder
            - perl-ExtUtils-Command
            - perl-ExtUtils-Embed
            - perl-ExtUtils-Install
            - perl-ExtUtils-MakeMaker
            - perl-ExtUtils-Manifest
            - perl-ExtUtils-Miniperl
            - perl-ExtUtils-MM-Utils
            - perl-ExtUtils-ParseXS
            - perl-File-Fetch
            - perl-File-Path
            - perl-File-Temp
            - perl-Filter
            - perl-Filter-Simple
            - perl-generators
            - perl-Getopt-Long
            - perl-HTTP-Tiny
            - perl-interpreter
            - perl-IO
            - perl-IO-Compress
            - perl-IO-Socket-IP
            - perl-IO-Zlib
            - perl-IPC-Cmd
            - perl-IPC-SysV
            - perl-JSON-PP
            - perl-libnet
            - perl-libnetcfg
            - perl-libs
            - perl-Locale-Codes
            - perl-Locale-Maketext
            - perl-Locale-Maketext-Simple
            - perl-macros
            - perl-Math-BigInt
            - perl-Math-BigInt-FastCalc
            - perl-Math-BigRat
            - perl-Math-Complex
            - perl-Memoize
            - perl-MIME-Base64
            - perl-Module-CoreList
            - perl-Module-CoreList-tools
            - perl-Module-Load
            - perl-Module-Load-Conditional
            - perl-Module-Loaded
            - perl-Module-Metadata
            - perl-Net-Ping
            - perl-open
            - perl-Params-Check
            - perl-parent
            - perl-PathTools
            - perl-Perl-OSType
            - perl-perlfaq
            - perl-PerlIO-via-QuotedPrint
            - perl-Pod-Checker
            - perl-Pod-Escapes
            - perl-Pod-Html
            - perl-Pod-Parser
            - perl-Pod-Perldoc
            - perl-Pod-Simple
            - perl-Pod-Usage
            - perl-podlators
            - perl-Scalar-List-Utils
            - perl-SelfLoader
            - perl-Socket
            - perl-Storable
            - perl-Sys-Syslog
            - perl-Term-ANSIColor
            - perl-Term-Cap
            - perl-Test
            - perl-Test-Harness
            - perl-Test-Simple
            - perl-tests
            - perl-Text-Balanced
            - perl-Text-ParseWords
            - perl-Text-Tabs+Wrap
            - perl-Thread-Queue
            - perl-threads
            - perl-threads-shared
            - perl-Time-HiRes
            - perl-Time-Local
            - perl-Time-Piece
            - perl-Unicode-Collate
            - perl-Unicode-Normalize
            - perl-utils
            - perl-version
    # We do not build any packages because they are already available
    # in BaseOS or AppStream repository. We cannnot replace BaseOS
    # packages.
    #components:
    #    rpms:
```

## Reference

Below is a reference for what's in a module's data. Some keys are optional.
There'll also be an example from lazybuilder, which uses jinja to template out
the final data that is used in a repo.

### Module Template and Known Keys

Below are the keys that are expected in the YAML for both defaults and the
actual module build itself. Each item will have information on the type of
value it is (eg, is it a string, list), if it's optional or mandatory, plus
comments that may point out what's valid in source data rather than final
repo data. Some of the data below may not be used in EL, but it's important
to know what is possible and what could be expected.

This information was copied from: [Fedora Modularity](https://github.com/fedora-modularity/libmodulemd/tree/main/yaml_specs)

```
# Document type identifier
# `document: modulemd-defaults` describes the default stream and profiles for
# a module.
document: modulemd-defaults
# Module metadata format version
version: 1
data:
    # Module name that the defaults are for, required.
    module: foo
    # A 64-bit unsigned integer. Use YYYYMMDDHHMM to easily identify the last
    # modification time. Use UTC for consistency.
    # When merging, entries with a newer 'modified' value will override any
    # earlier values. (optional)
    modified: 201812071200
    # Module stream that is the default for the module, optional.
    stream: "x.y"
    # Module profiles indexed by the stream name, optional
    # This is a dictionary of stream names to a list of default profiles to be
    # installed.
    profiles:
        'x.y': []
        bar: [baz, snafu]
    # System intents dictionary, optional. Indexed by the intent name.
    # Overrides stream/profiles for intent.
    intents:
        desktop:
            # Module stream that is the default for the module, required.
            # Overrides the above values for systems with this intent.
            stream: "y.z"
            # Module profiles indexed by the stream name, required
            # Overrides the above values for systems with this intent.
            # From the above, foo:x.y has "other" as the value and foo:bar has
            # no default profile.
            profiles:
                'y.z': [blah]
                'x.y': [other]
        server:
            # Module stream that is the default for the module, required.
            # Overrides the above values for systems with this intent.
            stream: "x.y"
            # Module profiles indexed by the stream name, required
            # Overrides the above values for systems with this intent.
            # From the above foo:x.y and foo:bar have no default profile.
            profiles:
                'x.y': []
```

**Note**: The glossary explains this, but remember that **AUTOMATIC** means that
it will typically not be in the module data itself, and will likely be in
repo data itself. There are also spots where thare are things that are **MANDATORY**
but also do not show up in a lot of modules, because the implicit/default option
turns off that section.

**Note**: There is a large chunk of these keys and values that state they are
**AUTOMATIC** and they do show up in the module data as a result of the module data
source and/or the build system doing work. An example of this is **arch**, among
others.

```
##############################################################################
# Glossary:                                                                  #
#                                                                            #
# build system: The process by which a module is built and packaged. In many #
# cases, this will be the Module Build Service tool, but this term is used   #
# as a catch-all to describe any mechanism for producing a yum repository    #
# containing modular content from input module metadata files.               #
#                                                                            #
#                                                                            #
# == Attribute Types ==                                                      #
#                                                                            #
# MANDATORY: Attributes of this type must be filled in by the packager of    #
# this module. They must also be preserved and provided in the output        #
# metadata produced by the build system for inclusion into a repository.     #
#                                                                            #
# OPTIONAL: Attributes of this type may be provided by the packager of this  #
# module, when appropriate. If they are provided, they must also be          #
# preserved and provided in the output metadata produced by the build        #
# system for inclusion into a repository.                                    #
#                                                                            #
# AUTOMATIC: Attributes of this type must be present in the repository       #
# metadata, but they may be left unspecified by the packager. In this case,  #
# the build system is responsible for generating an appropriate value for    #
# the attribute and including it in the repository metadata. If the packager #
# specifies this attribute explicitly, it must be preserved and provided in  #
# the output metadata for inclusion into a repository.                       #
#                                                                            #
# The definitions above describe the expected behavior of the build system   #
# operating in its default configuration. It is permissible for the build    #
# system to override user-provided entries through non-default operating     #
# modes. If such changes are made, all items indicated as being required for #
# the output repository must still be present.                               #
##############################################################################


# Document type identifier
# `document: modulemd` describes the contents of a module stream
document: modulemd

# Module metadata format version
version: 2

data:
    # name:
    # The name of the module
    # Filled in by the build system, using the VCS repository name as the name
    # of the module.
    #
    # Type: AUTOMATIC
    #
    # Mandatory for module metadata in a yum/dnf repository.
    name: foo

    # stream:
    # Module update stream
    # Filled in by the buildsystem, using the VCS branch name as the name of
    # the stream.
    #
    # Type: AUTOMATIC
    #
    # Mandatory for module metadata in a yum/dnf repository.
    stream: "latest"

    # version:
    # Module version, 64-bit unsigned integer
    # If this value is unset (or set to zero), it will be filled in by the
    # buildsystem, using the VCS commit timestamp.  Module version defines the
    # upgrade path for the particular update stream.
    #
    # Type: AUTOMATIC
    #
    # Mandatory for module metadata in a yum/dnf repository.
    version: 20160927144203

    # context:
    # Module context flag
    # The context flag serves to distinguish module builds with the
    # same name, stream and version and plays an important role in
    # automatic module stream name expansion.
    #
    # If 'static_context' is unset or equal to FALSE:
    #   Filled in by the buildsystem.  A short hash of the module's name,
    #   stream, version and its expanded runtime dependencies. The exact
    #   mechanism for generating the hash is unspecified.
    #
    #   Type: AUTOMATIC
    #
    #   Mandatory for module metadata in a yum/dnf repository.
    #
    # If 'static_context' is set to True:
    #   The context flag is a string of up to thirteen [a-zA-Z0-9_] characters
    #   representing a build and runtime configuration for this stream. This
    #   string is arbitrary but must be unique in this module stream.
    #
    #   Type: MANDATORY
    static_context: false
    context: c0ffee43

    # arch:
    # Module artifact architecture
    # Contains a string describing the module's artifacts' main hardware
    # architecture compatibility, distinguishing the module artifact,
    # e.g. a repository, from others with the same name, stream, version and
    # context.  This is not a generic hardware family (i.e. basearch).
    # Examples: i386, i486, armv7hl, x86_64
    # Filled in by the buildsystem during the compose stage.
    #
    # Type: AUTOMATIC
    #
    # Mandatory for module metadata in a yum/dnf repository.
    arch: x86_64

    # summary:
    # A short summary describing the module
    #
    # Type: MANDATORY
    #
    # Mandatory for module metadata in a yum/dnf repository.
    summary: An example module

    # description:
    # A verbose description of the module
    #
    # Type: MANDATORY
    #
    # Mandatory for module metadata in a yum/dnf repository.
    description: >-
        A module for the demonstration of the metadata format. Also,
        the obligatory lorem ipsum dolor sit amet goes right here.

    # servicelevels:
    # Service levels
    # This is a dictionary of important dates (and possibly supplementary data
    # in the future) that describes the end point of certain functionality,
    # such as the date when the module will transition to "security fixes only"
    # or go completely end-of-life.
    # Filled in by the buildsystem.  Service level names might have special
    # meaning to other systems.  Defined externally.
    #
    # Type: AUTOMATIC
    servicelevels:
        rawhide:
            # EOL dates are the ISO 8601 format.
            eol: 2077-10-23
        stable_api:
            eol: 2077-10-23
        bug_fixes:
            eol: 2077-10-23
        security_fixes:
            eol: 2077-10-23

    # license:
    # Module and content licenses in the Fedora license identifier
    # format
    #
    # Type: MANDATORY
    license:
        # module:
        # Module license
        # This list covers licenses used for the module metadata and
        # possibly other files involved in the creation of this specific
        # module.
        #
        # Type: MANDATORY
        module:
            - MIT

        # content:
        # Content license
        # A list of licenses used by the packages in the module.
        # This should be populated by build tools, not the module author.
        #
        # Type: AUTOMATIC
        #
        # Mandatory for module metadata in a yum/dnf repository.
        content:
            - ASL 2.0
            - GPL+ or Artistic

    # xmd:
    # Extensible metadata block
    # A dictionary of user-defined keys and values.
    # Defaults to an empty dictionary.
    #
    # Type: OPTIONAL
    xmd:
        some_key: some_data

    # dependencies:
    # Module dependencies, if any
    # A list of dictionaries describing build and runtime dependencies
    # of this module.  Each list item describes a combination of dependencies
    # this module can be built or run against.
    # Dependency keys are module names, dependency values are lists of
    # required streams.  The lists can be both inclusive (listing compatible
    # streams) or exclusive (accepting every stream except for those listed).
    # An empty list implies all active existing streams are supported.
    # Requiring multiple streams at build time will result in multiple
    # builds.  Requiring multiple streams at runtime implies the module
    # is compatible with all of them.  If the same module streams are listed
    # in both the build time and the runtime block, the build tools translate
    # the runtime block so that it matches the stream the module was built
    # against.  Multiple builds result in multiple output modulemd files.
    # See below for an example.
    # The example below illustrates how to build the same module in four
    # different ways, with varying build time and runtime dependencies.
    #
    # Type: OPTIONAL
    dependencies:
        # Build on all available platforms except for f27, f28 and epel7
        # After build, the runtime dependency will match the one used for
        # the build.
        - buildrequires:
              platform: [-f27, -f28, -epel7]
          requires:
              platform: [-f27, -f28, -epel7]

        # For platform:f27 perform two builds, one with buildtools:v1, another
        # with buildtools:v2 in the buildroot.  Both will also utilize
        # compatible:v3.  At runtime, buildtools isn't required and either
        # compatible:v3 or compatible:v4 can be installed.
        - buildrequires:
              platform: [f27]
              buildtools: [v1, v2]
              compatible: [v3]
          requires:
              platform: [f27]
              compatible: [v3, v4]

        # For platform:f28 builds, require either runtime:a or runtime:b at
        # runtime.  Only one build is performed.
        - buildrequires:
              platform: [f28]
          requires:
              platform: [f28]
              runtime: [a, b]

        # For platform:epel7, build against against all available extras
        # streams and moreextras:foo and moreextras:bar.  The number of builds
        # in this case will be 2 * <the number of extras streams available>.
        # At runtime, both extras and moreextras will match whatever stream was
        # used for build.
        - buildrequires:
              platform: [epel7]
              extras: []
              moreextras: [foo, bar]
          requires:
              platform: [epel7]
              extras: []
              moreextras: [foo, bar]

    # references:
    # References to external resources, typically upstream
    #
    # Type: OPTIONAL
    references:
        # community:
        # Upstream community website, if it exists
        #
        # Type: OPTIONAL
        community: http://www.example.com/

        # documentation:
        # Upstream documentation, if it exists
        #
        # Type: OPTIONAL
        documentation: http://www.example.com/

        # tracker:
        # Upstream bug tracker, if it exists
        #
        # Type: OPTIONAL
        tracker: http://www.example.com/

    # profiles:
    # Profiles define the end user's use cases for the module. They consist of
    # package lists of components to be installed by default if the module is
    # enabled. The keys are the profile names and contain package lists by
    # component type. There are several profiles defined below. Suggested
    # behavior for package managers is to just enable repository for selected
    # module. Then users are able to install packages on their own. If they
    # select a specific profile, the package manager should install all
    # packages of that profile.
    # Defaults to no profile definitions.
    #
    # Type: OPTIONAL
    profiles:

        # An example profile that defines a set of packages which are meant to
        # be installed inside a container image artifact.
        #
        # Type: OPTIONAL
        container:
            rpms:
                - bar
                - bar-devel

        # An example profile that delivers a minimal set of packages to
        # provide this module's basic functionality. This is meant to be used
        # on target systems where size of the distribution is a real concern.
        #
        # Type: Optional
        minimal:
            # A verbose description of the module, optional
            description: Minimal profile installing only the bar package.
            rpms:
                - bar

        # buildroot:
        # This is a special reserved profile name.
        #
        # This provides a listing of packages that will be automatically
        # installed into the buildroot of all component builds that are started
        # after a component builds with its `buildroot: True` option set.
        #
        # The primary purpose of this is for building RPMs that change
        # the build environment, such as those that provide new RPM
        # macro definitions that can be used by subsequent builds.
        #
        # Specifically, it is used to flesh out the build group in koji.
        #
        # Type: OPTIONAL
        buildroot:
            rpms:
                - bar-devel

        # srpm-buildroot:
        # This is a special reserved profile name.
        #
        # This provides a listing of packages that will be automatically
        # installed into the buildroot of all component builds that are started
        # after a component builds with its `srpm-buildroot: True` option set.
        #
        # The primary purpose of this is for building RPMs that change
        # the build environment, such as those that provide new RPM
        # macro definitions that can be used by subsequent builds.
        #
        # Very similar to the buildroot profile above, this is used by the
        # build system to specify any additional packages which should be
        # installed during the buildSRPMfromSCM step in koji.
        #
        # Type: OPTIONAL
        srpm-buildroot:
            rpms:
                - bar-extras

    # api:
    # Module API
    # Defaults to no API.
    #
    # Type: OPTIONAL
    api:
        # rpms:
        # The module's public RPM-level API.
        # A list of binary RPM names that are considered to be the
        # main and stable feature of the module; binary RPMs not listed
        # here are considered "unsupported" or "implementation details".
        # In the example here we don't list the xyz package as it's only
        # included as a dependency of xxx.  However, we list a subpackage
        # of bar, bar-extras.
        # Defaults to an empty list.
        #
        # Type: OPTIONAL
        rpms:
            - bar
            - bar-extras
            - bar-devel
            - baz
            - xxx

    # filter:
    # Module component filters
    # Defaults to no filters.
    #
    # Type: OPTIONAL
    filter:
        # rpms:
        # RPM names not to be included in the module.
        # By default, all built binary RPMs are included.  In the example
        # we exclude a subpackage of bar, bar-nonfoo from our module.
        # Defaults to an empty list.
        #
        # Type: OPTIONAL
        rpms:
            - baz-nonfoo

    # demodularized:
    # Artifacts which became non-modular
    # Defaults to no demodularization.
    # Type: OPTIONAL
    demodularized:
        # rpms:
        # A list of binary RPM package names which where removed from
        # a module. This list explains to a package mananger that the packages
        # are not part of the module anymore and up-to-now same-named masked
        # non-modular packages should become available again. This enables
        # moving a package from a module to a set of non-modular packages. The
        # exact implementation of the demodularization (e.g. whether it
        # applies to all modules or only to this stream) is defined by the
        # package manager.
        # Defaults to an empty list.
        #
        # Type: OPTIONAL
        rpms:
            - bar-old

    # buildopts:
    # Component build options
    # Additional per component type module-wide build options.
    #
    # Type: OPTIONAL
    buildopts:
        # rpms:
        # RPM-specific build options
        #
        # Type: OPTIONAL
        rpms:
            # macros:
            # Additional macros that should be defined in the
            # RPM buildroot, appended to the default set.  Care should be
            # taken so that the newlines are preserved.  Literal style
            # block is recommended, with or without the trailing newline.
            #
            # Type: OPTIONAL
            macros: |
                %demomacro 1
                %demomacro2 %{demomacro}23

            # whitelist:
            # Explicit list of package build names this module will produce.
            # By default the build system only allows components listed under
            # data.components.rpms to be built as part of this module.
            # In case the expected RPM build names do not match the component
            # names, the list can be defined here.
            # This list overrides rather then just extends the default.
            # List of package build names without versions.
            #
            # Type: OPTIONAL
            whitelist:
                - fooscl-1-bar
                - fooscl-1-baz
                - xxx
                - xyz

        # arches:
        # Instructs the build system to only build the
        # module on this specific set of architectures.
        # Includes specific hardware architectures, not families.
        # See the data.arch field for details.
        # Defaults to all available arches.
        #
        # Type: OPTIONAL
        arches: [i686, x86_64]

    # components:
    # Functional components of the module
    #
    # Type: OPTIONAL
    components:
        # rpms:
        # RPM content of the module
        # Keys are the VCS/SRPM names, values dictionaries holding
        # additional information.
        #
        # Type: OPTIONAL
        rpms:
            bar:
                # name:
                # The real name of the package, if it differs from the key in
                # this dictionary. Used when bootstrapping to build a
                # bootstrapping ref before building the package for real.
                #
                # Type: OPTIONAL
                name: bar-real

                # rationale:
                # Why is this component present.
                # A simple, free-form string.
                #
                # Type: MANDATORY
                rationale: We need this to demonstrate stuff.

                # repository:
                # Use this repository if it's different from the build
                # system configuration.
                #
                # Type: AUTOMATIC
                repository: https://pagure.io/bar.git

                # cache:
                # Use this lookaside cache if it's different from the
                # build system configuration.
                #
                # Type: AUTOMATIC
                cache: https://example.com/cache

                # ref:
                # Use this specific commit hash, branch name or tag for
                # the build.  If ref is a branch name, the branch HEAD
                # will be used.  If no ref is given, the master branch
                # is assumed.
                #
                # Type: AUTOMATIC
                ref: 26ca0c0

                # buildafter:
                # Use the "buildafter" value to specify that this component
                # must be be ordered later than some other entries in this map.
                # The values of this array come from the keys of this map and
                # not the real component name to enable bootstrapping.
                # Use of both buildafter and buildorder in the same document is
                # prohibited, as they will conflict.
                #
                # Note: The use of buildafter is not currently supported by the
                # Fedora module build system.
                #
                # Type: AUTOMATIC
                #
                # buildafter:
                #    - baz

                # buildonly:
                # Use the "buildonly" value to indicate that all artifacts
                # produced by this component are intended only for building
                # this component and should be automatically added to the
                # data.filter.rpms list after the build is complete.
                # Defaults to "false" if not specified.
                #
                # Type: AUTOMATIC
                buildonly: false

            # baz builds RPM macros for the other components to use
            baz:
                rationale: Demonstrate updating the buildroot contents.

                # buildroot:
                # If buildroot is set to True, the packages listed in this
                # module's 'buildroot' profile will be installed into the
                # buildroot of any component built in buildorder/buildafter
                # batches begun after this one, without requiring that those
                # packages are listed among BuildRequires.
                #
                # The primary purpose of this is for building RPMs that change
                # the build environment, such as those that provide new RPM
                # macro definitions that can be used by subsequent builds.
                #
                # Defaults to "false" if not specified.
                #
                # Type: OPTIONAL
                buildroot: true

                # srpm-buildroot:
                # If srpm-buildroot is set to True, the packages listed in this
                # module's 'srpm-buildroot' profile will be installed into the
                # buildroot of any component built in buildorder/buildafter
                # batches begun after this one, without requiring that those
                # packages are listed among BuildRequires.
                #
                # The primary purpose of this is for building RPMs that change
                # the build environment, such as those that provide new RPM
                # macro definitions that can be used by subsequent builds.
                #
                # Defaults to "false" if not specified.
                #
                # Type: OPTIONAL
                srpm-buildroot: true

                # See component xyz for a complete description of buildorder
                #
                # build this component before any others so that the macros it
                # creates are available to all of them.
                buildorder: -1

            xxx:
                rationale: xxx demonstrates arches and multilib.

                # arches:
                # xxx is only available on the listed architectures.
                # Includes specific hardware architectures, not families.
                # See the data.arch field for details.
                # Instructs the build system to only build the
                # component on this specific set of architectures.
                # If data.buildopts.arches is also specified,
                # this must be a subset of those architectures.
                # Defaults to all available arches.
                #
                # Type: AUTOMATIC
                arches: [i686, x86_64]

                # multilib:
                # A list of architectures with multilib
                # installs, i.e. both i686 and x86_64
                # versions will be installed on x86_64.
                # Includes specific hardware architectures, not families.
                # See the data.arch field for details.
                # Defaults to no multilib.
                #
                # Type: AUTOMATIC
                multilib: [x86_64]

            xyz:
                rationale: xyz is a bundled dependency of xxx.

                # buildorder:
                # Build order group
                # When building, components are sorted by build order tag
                # and built in batches grouped by their buildorder value.
                # Built batches are then re-tagged into the buildroot.
                # Multiple components can have the same buildorder index
                # to map them into build groups.
                # Defaults to zero.
                # Integer, from an interval [-(2^63), +2^63-1].
                # In this example, bar, baz and xxx are built first in
                # no particular order, then tagged into the buildroot,
                # then, finally, xyz is built.
                # Use of both buildafter and buildorder in the same document is
                # prohibited, as they will conflict.
                #
                # Type: OPTIONAL
                buildorder: 10

        # modules:
        # Module content of this module
        # Included modules are built in the shared buildroot, together with
        # other included content.  Keys are module names, values additional
        # component information.  Note this only includes components and their
        # properties from the referenced module and doesn't inherit any
        # additional module metadata such as the module's dependencies or
        # component buildopts.  The included components are built in their
        # defined buildorder as sub-build groups.
        #
        # Type: OPTIONAL
        modules:
            includedmodule:

                # rationale:
                # Why is this module included?
                #
                # Type: MANDATORY
                rationale: Included in the stack, just because.

                # repository:
                # Link to VCS repository that contains the modulemd file
                # if it differs from the buildsystem default configuration.
                #
                # Type: AUTOMATIC
                repository: https://pagure.io/includedmodule.git

                # ref:
                # See the rpms ref.
                #
                # Type: AUTOMATIC
                ref: somecoolbranchname

                # buildorder:
                # See the rpms buildorder.
                #
                # Type: AUTOMATIC
                buildorder: 100

    # artifacts:
    # Artifacts shipped with this module
    # This section lists binary artifacts shipped with the module, allowing
    # software management tools to handle module bundles.  This section is
    # populated by the module build system.
    #
    # Type: AUTOMATIC
    artifacts:

        # rpms:
        # RPM artifacts shipped with this module
        # A set of NEVRAs associated with this module. An epoch number in the
        # NEVRA string is mandatory.
        #
        # Type: AUTOMATIC
        rpms:
            - bar-0:1.23-1.module_deadbeef.x86_64
            - bar-devel-0:1.23-1.module_deadbeef.x86_64
            - bar-extras-0:1.23-1.module_deadbeef.x86_64
            - baz-0:42-42.module_deadbeef.x86_64
            - xxx-0:1-1.module_deadbeef.x86_64
            - xxx-0:1-1.module_deadbeef.i686
            - xyz-0:1-1.module_deadbeef.x86_64

        # rpm-map:
        # The rpm-map exists to link checksums from repomd to specific
        # artifacts produced by this module. Any item in this list must match
        # an entry in the data.artifacts.rpms section.
        #
        # Type: AUTOMATIC
        rpm-map:

          # The digest-type of this checksum.
          #
          # Type: MANDATORY
          sha256:

            # The checksum of the artifact being sought.
            #
            # Type: MANDATORY
            ee47083ed80146eb2c84e9a94d0836393912185dcda62b9d93ee0c2ea5dc795b:

              # name:
              # The RPM name.
              #
              # Type: Mandatory
              name: bar

              # epoch:
              # The RPM epoch.
              # A 32-bit unsigned integer.
              #
              # Type: OPTIONAL
              epoch: 0

              # version:
              # The RPM version.
              #
              # Type: MANDATORY
              version: 1.23

              # release:
              # The RPM release.
              #
              # Type: MANDATORY
              release: 1.module_deadbeef

              # arch:
              # The RPM architecture.
              #
              # Type: MANDATORY
              arch: x86_64

              # nevra:
              # The complete RPM NEVRA.
              #
              # Type: MANDATORY
              nevra: bar-0:1.23-1.module_deadbeef.x86_64
```

### Module Template and Keys using jinja

```
{% if module_default_data is defined %}
---
document: modulemd-defaults
version: {{ module_default_data.version }}
data:
  module: {{ module_default_data.data.module }}
  stream: {{ module_default_data.data.stream }}
  profiles:
{% for k in module_default_data.data.profiles %}
    {{ k }}: [{{ module_default_data.data.profiles[k]|join(', ') }}]
{% endfor %}
...
{% endif %}
---
document: {{ module_data.document }}
version: {{ module_data.version }}
data:
  name: {{ source_name | default("source") }}
  stream: "{{ module_data.data.stream }}"
  version: {{ module_version | default(8040) }}
  context: {{ module_context | default('01010110') }}
  arch: {{ mock_arch | default(ansible_architecture) }}
  summary: {{ module_data.data.summary | wordwrap(width=79) | indent(width=4) }}
  description: {{ module_data.data.description | wordwrap(width=79) | indent(width=4) }}
  license:
{% for (key, value) in module_data.data.license.items() %}
    {{ key }}:
    - {{ value | join('\n    - ') }}
{% endfor %}
  xmd: {}
{% if module_data.data.dependencies is defined %}
  dependencies:
{% for l in module_data.data.dependencies %}
{% for r in l.keys() %}
{% if loop.index == 1 %}
  - {{ r }}:
{% else %}
    {{ r }}:
{% endif %}
{% for (m, n) in l[r].items() %}
      {{ m }}: [{{ n | join(', ') }}]
{% endfor %}
{% endfor %}
{% endfor %}
{% endif %}
{% if module_data.data.filter is defined %}
  filter:
{% for (key, value) in module_data.data.filter.items() %}
    {{ key }}:
    - {{ value | join('\n    - ') }}
{% endfor %}
{% endif %}
{% if module_data.data.profiles is defined %}
  profiles:
{% for (key, value) in module_data.data.profiles.items() %}
    {{ key }}:
{% for (key, value) in value.items() %}
{% if value is iterable and (value is not string and value is not mapping) %}
      {{ key | indent(width=6) }}:
      - {{ value | join('\n      - ') }}
{% else %}
      {{ key | indent(width=6) }}: {{ value }}
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}
{% if module_data.data.api is defined %}
  api:
{% for (key, value) in module_data.data.api.items() %}
    {{ key }}:
    - {{ value | join('\n    - ') }}
{% endfor %}
{% endif %}
{% if module_data.data.buildopts is defined %}
  buildopts:
{% for (key, value) in module_data.data.buildopts.items() %}
    {{ key }}:
{% for (key, value) in value.items() %}
      {{ key }}: |
        {{ value | indent(width=8) }}
{% endfor %}
{% endfor %}
{% endif %}
{% if module_data.data.references is defined %}
  references:
{% for (key, value) in module_data.data.references.items() %}
    {{ key }}: {{ value }}
{% endfor %}
{% endif %}
{% if module_data.data.components is defined %}
  components:
{% for (key, value) in module_data.data.components.items() %}
    {{ key }}:
{% for (key, value) in value.items() %}
      {{ key }}:
{% for (key, value) in value.items() %}
{% if value is iterable and (value is not string and value is not mapping) %}
        {{ key | indent(width=8) }}: [{{ value | join(', ') }}]
{% else %}
        {{ key | indent(width=8) }}: {{ value }}
{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endif %}
{% if artifacts is defined %}
  artifacts:
{% for (key, value) in artifacts.items() %}
    {{ key }}:
    - {{ value | join('\n    - ') }}
{% endfor %}
{% endif %}
...
```
