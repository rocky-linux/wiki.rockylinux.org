---
title: Package Build Issues Tracking
---

**NOTE: This page is deprecated, and refers to Skip's CentOS 8.3 "practice" build.  It is being kept as a reference in case there are similar issues with the listed packages.**

**The actual build is in progress, and Koji build errors are tracked on the main error tracking page: https://wiki.rockylinux.org/e/en/team/development/Package_Error_Tracking**

<br />
##################################################################
<br />

This page details packages that have failed to build, or which something "special" had to be done to achieve a build.

For example, a package which fails when building with the newest version of a dependency, and requires the forced-downgrade to the older build dependency would go here.

This page is NOT for dependency issues, or tracking which order to build dependent packages in.  That information is being tracked under Development/Build_Order/ in this wiki.


## Repositories/Builds
This page tracks build failures from these sources:

- CentOS BaseOS
- CentOS AppStream
- CentOS PowerTools
- External Dependencies

"External Dependencies" means packages that are downloaded and built from git.centos.org , and don't belong in an official repository.  Many packages from the official repositories depend on these external dependency packages.


## Methodology and Links
Right now, build passes are done from CentOS 8.3 SRPMs and Skip's build server: ( https://rocky.lowend.ninja/RockyDevel/ )

Official Koji/MBS infrastructure is nearly complete and will of course be the official location for Rocky builds.  This unofficial work is being done to gather information that will help the official build go smoothly.

All build "passes" are done via Mock, and their results are added to a repository on the build server.  These repositories are available to subsequent builds, so more packages get their dependencies and successfully build.

### Links:

* **Build Result Repositories:**  https://rocky.lowend.ninja/RockyDevel/ {BaseOS_final, BaseOS_devel, AppStream_final, AppStream_devel, PowerTools_final, PowerTools_devel, External_Deps}  (Repos are separated into what goes in the official repo, and other build artifacts produced from the build that aren't in the official repo)
* **Mock Configurations:**  https://rocky.lowend.ninja/RockyDevel/mock_configs/  - The mock config files used for each Build Pass.
* **Mock Build logs and RPMs:** https://rocky.lowend.ninja/RockyDevel/MOCK_RAW/ - Logs and result RPMs from the mock builds.  Separated by repo and package name/version.  Dig into here to find error logs and match them with build results listed in the wiki.
* **Summarized build results:** https://rocky.lowend.ninja/RockyDevel/deliverables/ - Results from each build pass.  What new packages succeeded, which ones failed, and what RPM files were created as a result of the build.  This information gets copied to the Wiki under Development/Build_Order/ for easy viewing, but is available in raw form here.


<br />

## A Note on Modularity
The current method for package testing is very simplistic, and doesn't take into account modular-stream packages (new feature in RHEL 8).  While we don't produce modular metadata with this method to create proper modules, it's still possible to compile modular packages and use modular dependencies.

Our Mock config uses the option ```module_hotfixes=1``` in the DNF repo config files, which causes DNF to consider all packages for build dependencies in Mock, even ones from modules that are not enabled.


<br />

## Package Build Tips Discovered so far:

- **Perl:** Build everything (especially external dependencies!) against the default Perl 5.26 stream, NOT the latest available 5.30 stream.  Perl packages higher up the chain depend on 5.26.

- **Maven:**  Create blank maven.conf file : `config_opts['files']['/etc/java/maven.conf'] = " " ` by changing mock config.  Maven-related packages have a script that checks for it and will fail if it's not present

- **Various(SystemD)**: SystemD changed its version string output from a simple "239" to a more complicated "239 (239-41.el8_3.1)" starting with the listed version.  Breaks several package scripts.

- **javapackages-tools:** In order to produce "maven-local-openjdk8", you need a specific commit, more info under External Dependencies page.

<br />

## The New List
This is a list of failing builds from **kojidev.rockylinux.org** that need help.  We're now focusing development efforts on helping the real builds, and not doing "practice" builds of CentOS.

This list is not grouped according to repo.

| Package | Notes |
|:--------|----------------|
| bolt-0.9-1.el8 | Using simple mock chroot (`isolation=simple`) solves permission issues, but there are still 2 tests that fail with signal 5 (SIGTRAP).  Investigation still ongoing |
| graphviz-2.40.1-40 | Fixed if `module_hotfixes=1` is turned off.  It pulls in the latest Ruby 2.7 and not the default Ruby 2.5 stream, which breaks the build |
| marisa | Succeeded locally for Leigh + tjyang.  More investigation...? |
| python-requests | Succeeded locally for Leigh + tjyang.  More investigation...? |
| python-psycopg2 | **Failed** locally also.  Possible patch required?  https://src.fedoraproject.org/rpms/python-psycopg2/c/89f4b65570783ea763c37311e974296d3ff40d90?branch=master |
| scrub | Succeeded locally for Leigh + tjyang.  More investigation...? |
| uglify-js| Succeeded locally for Leigh + tjyang.  More investigation...? |



## The (old) List
The following is a list of the packages we have investigated.  Notes are kept about why they failed, and any workarounds used to build them successfully.  Expect this to get updated as we gather more information!

**CentOS 8 BaseOS Repository**:

| Package |  Notes  |
|:--------|----------------|
| ~~efibootmgr-16-1.el8~~ | ~~Patch: https://git.rockylinux.org/staging/patch/efibootmgr~~ |
| ~~fwupdate-11-3.el8~~ | ~~Patch: https://git.rockylinux.org/staging/patch/fwupdate~~ |
| ~~libkcapi-1.2.0-2.el8~~ | ~~Will not build in the default Mock systemd-nspawn container.  MUST use ```mock --isolation=simple``` option to build in traditional chroot~~ |
| ~~libusbx-1.0.23-4.el8~~ | ~~Patch: https://github.com/elguero/centos8-libusbx/commit/daaad4ad85e7306ad0f111558bb143a2e9700b6d (mock should already have git-core available~~|
| ~~python-cffi-1.11.5-5.el8~~ | ~~Need to define %__python. Build with `--define '__python %__python3'` (see https://fedoraproject.org/wiki/Changes/PythonMacroError)~~ |
| ~~tpm2-abrmd-2.1.1-3.el8~~ | ~~Patch: https://git.rockylinux.org/staging/patch/tpm2-abrmd~~ |


<br />

**CentOS 8 AppStream Repository**:

| Package  |  Notes  |
|:--------|--------------|
| ~~abattis-cantarell-fonts-0.0.25-4.el8~~ | ~~Patched fontforge to fix segfault issue.  Builds fine using the patched fontforge in its BuildRequires~~ |
| ~~apache-commons-logging-1.2-13.module_el8.0.0+39+6a9b6e22~~ | ~~Needs to be built `--without avalon`~~ |
| ~~brltty-5.6-28.el8~~	| ~~Needs patch to change location of asoundlib.h in newer version of alsa. https://github.com/sjpp/centos8-brltty/commit/388ddcf6493d50ce34542c8badb1a54a9f811950 (see https://bugzilla.redhat.com/show_bug.cgi?id=1716389, https://src.fedoraproject.org/rpms/brltty/c/897ad85a69cd7fb53cabcbac2fbc7c0ca1719da7?branch=master)~~ |
| ~~ceph-12.2.7-9.el8~~ | ~~Need to define %__python. Build with `--define '__python %__python3'` (see https://fedoraproject.org/wiki/Changes/PythonMacroError)~~ |
| ~~cobbler-2.0.7.1-6.module_el8.1.0+210+a3d63f21~~ | ~~Need to define %__python. Build with `--define '__python %__python3'` (see https://fedoraproject.org/wiki/Changes/PythonMacroError)~~ |
| ~~cogl-1.22.2-10.el8~~ | ~~Fix was committed to Rocky Git. Possible fix: https://github.com/elguero/centos8-cogl/commit/a8b47440f5c7290d96d0b8786f48f323a8a950f9. Got further in the build by force-including these packages in buildroot: ```libdrm-devel libXxf86vm-devel  mesa-libGL-devel mesa-libEGL-devel xml-common mesa-khr-devel ``` (matches centos koji build).  Still fails though.~~ |
| ~~cyrus-imapd-3.0.7-19.el8~~ | ~~Hidden dependencies added to the list, `perl-Encode-IMAPUTF7`. Will build once dependencies are satisfied.~~ |
| ~~egl-wayland-1.1.4-1.el8~~ | ~~We are unable to use the SRPM in vault.centos.org for `egl-wayland` due to a newer version of `mesa-libEGL-devel` being present (See https://github.com/NVIDIA/egl-wayland/commit/4a343a4b563e84c6258efbddf1d910f9dd6e0300). Building `egl-wayland` was resolved by checking out the latest code from git.centos.org (produces same version 1.1.4-1) that now contains a patch to fix this.~~ |
| ~~gegl04-0.4.4-6.el8~~	| ~~Need to patch SPEC file. Change `BuildRequires: pkgconfig(exiv2) >= 0.25` to `BuildRequires: compat-exiv2-026`.~~ |
| ~~gcc-toolset-9-dyninst~~ | ~~This is a scl build.  In chroot, add `scl-utils-build` and `gcc-toolset-9-build`. Then define the `scl` macro as follows: `--define 'scl gcc-toolset-9'`~~ |
| ~~gcc-toolset-9-gcc~~ | ~~This is a scl build.  In chroot, add `scl-utils-build` and `gcc-toolset-9-build`. Then define the `scl` macro as follows: `--define 'scl gcc-toolset-9'`~~ |
| ~~gcc-toolset-10-dyninst~~ | ~~This is a scl build.  In chroot, add `scl-utils-build` and `gcc-toolset-10-build`. Then define the `scl` macro as follows: `--define 'scl gcc-toolset-10'`~~ |
| ~~gcc-toolset-10-gcc~~ | ~~This is a scl build.  In chroot, add `scl-utils-build` and `gcc-toolset-10-build`. Then define the `scl` macro as follows: `--define 'scl gcc-toolset-10'`~~ |
| ~~gcc-toolset-10-systemtap~~ | ~~This is a scl build.  In chroot, add `scl-utils-build` and `gcc-toolset-10-build`. Then define the `scl` macro as follows: `--define 'scl gcc-toolset-10'`~~ |
| ~~google-guice-4.2.2-4.module_el8.~~ | With javapackages-tool from branch c8-stream-201902 built without forcing anything into buildroot. ~~Hidden dependency (newer version): `objectweb-asm-7` added to list 101. Built successfully by forcing `plexus-utils-3.3.0-3.el8.noarch objectweb-asm-7.2-2.el8_3.noarch` into buildroot, and setting the \_without macros found in the maven modules.~~ |
| ~~grafana~~ | ~~Tries to download dependencies. No network available in mock (normally unless enabled).  Crossing off list because latest version builds correctly.~~ |
| ~~gstreamer1-plugins-base~~ | ~~Dependency: `egl-wayland-devel`. Already fixed and should build during next pass~~ |
| ~~HdrHistogram-2.1.11-2.module_el8.2.0+460+6583c1d0~~ | ~~Hidden dependency: `replacer`. Already been added and should build in next pass.~~ |
| httpcomponents-client-4.5.5-4.module_el8.0.0+39+6a9b6e22 | Built using `--without memcached` and `--without ehcache` |
| httpcomponents-client-4.5.10-* | Successfully built. Needs `mockito-3.1.2-2.el8_3` - Added to list 101 (`byte-buddy` added to list 100, `hamcrest` added to list 100 and `objectweb-asm-7` (v7.3) added to list 99) |
| httpcomponents-core-4.4.12-* | Successfully built. Needs `mockito-3.1.2-2.el8_3` - Added to list 101 (`byte-buddy` added to list 100, `hamcrest` added to list 100 and `objectweb-asm-7` (v7.3) added to list 99) |
| ~~istack-commons~~ | ~~Dependency: `dom4j` - Need to get dom4j built.  Also had to force `plexus-utils-3.3.0-3.el8.noarch` into build root (override version 3.1)~~ |
| ~~jackson-annotations~~ | ~~Hidden dependency: `jackson-parent` (added to list 101)~~ |
| ~~jackson-core~~ | ~~Hidden dependency: `jackson-bom`. (added to list 101)~~ |
| ~~jackson-databind~~ | ~~Hidden dependency: `jackson-bom`. (added to list 101)~~ |
| ~~jackson-jaxrs-providers~~ | ~~Hidden dependency: `glassfish-jax-rs-api, jackson-bom`. (added to list 101)~~ |
| ~~jackson-module-jaxb-annotations~~ | ~~Hidden dependency: `jackson-parent` (added to list 101)~~ |
| ~~jline~~ | ~~Needs to be built against `jansi-1.17*`. Completed build by forcing jansi-1.17 and `plexus-utils-3.3.0-3` into the buildroot.  Should be ok when the module is built, as it specifies these in modulemd src.~~ |
| ~~jmc~~ | ~~Hidden dependency: `eclipse-pde`, provided by building `eclipse` which has its long list of hidden dependencies. (added to list 101)~~ |
| ~~jolokia-jvm-agent~~ | ~~Hidden dependency: `json-simple` (added to list 101)~~ |
| ~~jss~~ | ~~Patch committed to staging: https://git.rockylinux.org/staging/patch/jss~~ |
| ~~liborcus-0.14.1-1.el8~~	| ~~Hidden dependency: `mdds-1.4` is in branch `c8s` and is a specific tag, `imports/c8s/mdds-1.4.3-1.el8` (added to list 101)~~ |
| libreoffice-6.3.6.2-3.el8	| Should build once `liborcus-0.14-1-1.el8` is able to built. See above. |
| ~~libucil~~ | ~~Newer `alsa-libs` has moved the location of `asoundlib.h`. Patch: https://github.com/elguero/centos8-libucil/commit/cd15a416fc10456bab7a2ae67b2073d4a12a4b8c~~ |
| ~~libvirt-python-4.5.0-2.module_el8.2.0+320+13f867d7~~ | ~~Newer version is present.~~ |
| ~~mariadb-java-client-2.2.5~~ | ~~Hidden dependency: `replacer` (added to list 101)~~ |
| ~~maven-3.5.4-5.module_el8.0.0+39+6a9b6e22~~ | ~~Built `--without logback`.  Also disabled module_hotfixes and enabled maven-3.5 module to build.  Should be fine under MBS we think(?)~~ |
| ~~maven-3.6.2-4.module_*~~ | ~~Built `javapackages-tools` from c8-stream-201902 and was able to then build maven. ~~Hidden dependencies: `slf4j-sources` (artifact of building slf4j), `modello`, `mockito-core` (which has dependencies too, `byte-buddy` (needs `objectweb-asm-7`) and `hamcrest-core`), `xmlunit`.  Needed to disable module_hotfixes and enable maven:3.6 stream in mock, should build automatically using MBS~~ |
| ~~maven-wagon-3.1.0-1.module_el8.0.0+39+6a9b6e22~~ | ~~Built `--without scm` and `--without ssh`. Dependencies displayed in build pass 10 were not used in koji build which indicates that it was built without them by using these conditionals (https://koji.mbox.centos.org/pkgs/packages/maven-wagon/3.1.0/1.module_el8.0.0+39+6a9b6e22/data/logs/noarch/root.log)~~ |
| ~~mesa-libGLU-9.0.0-15.el8~~	| ~~Patch: https://github.com/elguero/centos8-mesa-libGLU/commit/87fc0e63afb3ac0eb65ff480ee6e616979f39927~~ |
| ~~mod_wsgi~~ | ~~Need to `--define 'python3_pkgversion 38'` macro (as specified in python38 module)~~ |
| ~~mutter-3.32.2~~ | Needed `pkgconfig(wayland-eglstream)` .  Appears to work after that is satisfied. |
| ~~numpy-1.14.2-*~~ | ~~These are part of the python27 module, and must be built `--with python2` and `--without python3` .  Should be fine when the module is built by MBS.~~ |
| perl-File-HomeDir-1.00-14.module_el8.1.0+229+cd132df8 | Missing `BuildRequires: perl(Module::Install)` (maybe ok when built as a module?) |
| perl-JSON-2.97.001-2.el8 | ~~Missing `BuildRequires: perl-tests`~~ No longer able to reproduce error. |
| ~~perl-Module-Build-0.42.29-4.module_el8.3.0+406+78614513~~ | ~~Needs `--define 'perl_bootstrap 1'` to build without the need for dependencies that have been removed from RHEL8~~ |
| ~~perl-URI-1.7~~ | ~~Needs `--define 'perl_bootstrap 1'` to build without the need for dependencies that have been removed from RHEL8~~ |
| ~~pesign~~ | ~~https://github.com/elguero/centos8 pesign/commit/8e0b2ac48129cfe51dd1d53531e77dbc34317dc7~~ |
| plexus-containers | Built now that javapackages-tool from c8-stream-201902 is present. ~~`[ERROR] COMPILATION ERROR : [INFO] ------------------------------------------------------------- [ERROR] /builddir/build/BUILD/plexus-containers-plexus-containers-2.1.0/plexus-component-metadata/src/main/java/org/codehaus/plexus/metadata/ann/AnnReader.java:[38,18] cannot find symbol  symbol:   variable ASM7 location: interface org.objectweb.asm.Opcodes`~~ |
| ~~plexus-build-api-0.0.7-20.module_el8.0.0+30+832da3a1~~ |  ~~Newer version in Git should build properly~~ |
| ~~plexus-interpolation-1.26-3.module_el8.~~ | ~~Needs `JAVA_HOME` set. `config_opts['files']['/etc/profile.d/mystuff.sh'] = """ export JAVA_HOME=/ """`~~ |
| postgresql-jdbc-42.2.3-* | Built fine localy ?? Maybe next build will pass. |
| ~~prometheus-jmx-exporter-0.12.0-5.el8~~ | ~~Hidden dependencies: `prometheus-simpleclient-java` and `snakeyaml` (added to list 101). `snakeyaml` depends on `base64coder` (added to list 100).  Build is successful~~ |
| ~~prometheus-jmx-exporter-0.12.0-5.el8~~ | ~~One of the hidden dependencies is `snakeyaml`. This version depends on `snakeyaml 1.26-2` which is in branch `c8s`.~~ |
| ~~python-cups-1.9.72-21.el8.0.1~~	| ~~Build with `--define '__python %__python3'` (see https://fedoraproject.org/wiki/Changes/PythonMacroError)~~ |
| ~~python-systemd~~ | ~~Possible fix: https://github.com/elguero/centos8-python-systemd/commit/b015bd9c2673939465162cd8a03003222d00327e   Affected by version string in new Systemd running longer ("239" vs. "239 (239.4-rhel)"  Reference:  https://github.com/systemd/python-systemd/issues/90~~ |
| ~~pytz-2019.*~~	| ~~Need to `--define 'python3_pkgversion 38'` - part of the python38 module, so should be fine in MBS~~ |
| ~~qt5-qtdoc-5.12.5-1.el8~~ | ~~Hidden dependency `qt5-qtbase-doc`. Build `qt5-doc` from git.centos.org to satisfy.~~ |
| ~~qt5-qtwayland-5.12.5-1.el8~~ | ~~Missing `BuildRequires:  libXext-devel`. Fixed in git already.~~ |
| ~~rhncfg-5.10.120-10.module_el8.1.0+210+a3d63f21~~ | ~~Need to define %__python. Built with `--define '__python %__python3'` (see https://fedoraproject.org/wiki/Changes/PythonMacroError)~~ |
| ~~rust-1.41.1-1.module_el8.2.0+322+d7f93ccc~~ | ~~Outdated SRPM - use rust-1.47 from CentOS repo (OK, removed from Skip's build server)~~ |
| scipy-1.3.1-4* | Need to `--define 'python3_pkgversion 38'` - otherwise it grabs python3 packages which does not satisfy dependency |
| ~~SLOF~~ | ~~Needs to be built for `ppc64le`. Spec requires that target arch.~~ |
| ~~spacewalk-backend-2.8.48-4.module_el8.1.0+210+a3d63f21~~ | ~~Need to define %__python. Built with `--define '__python %__python3'` (see https://fedoraproject.org/wiki/Changes/PythonMacroError)~~ |
| ~~spacewalk-usix-2.8.1-5.module_el8.1.0+210+a3d63f21~~ | ~~Need to define %__python. Built with `--define '__python %__python3'` (see https://fedoraproject.org/wiki/Changes/PythonMacroError)~~ |
| ~~subversion-~~ | ~~Needs to be build `--without kwallet`. CentOS Koji logs shows kwallet is not present.~~ |
| ~~varnish-6.0{2-1, 6-2}.~~ | ~~Needs to be built `--with python3` and `--without python2`~~ |
| ~~varnish-modules-0.15.0-~~ | ~~Needs to be built `--with python3` and `--without python2`~~ |
| ~~velocity-1.7-24.module_*~~ | ~~Needs to be built `_without_hsqldb=1`, and point to jdk instead of jre in profile.d: `export JAVA_HOME=/usr/lib/jvm/java/` .  Both likely work when building the module.~~ |
| ~~xdg-desktop-portal-gtk-1.6.0-1.el8~~	| ~~It looks like it succeeded in build pass 10 (dependencies fulfilled)~~ |
| ~~xorg-x11-docs-1.7.1-7.el8~~ | ~~Hidden dependency: `passivetex`, built hidden dependency from branch c8. Dependecy satisfied and built.~~ |
| ~~xorg-x11-server-1.20.{6-3, 8-6, 8-6.1}~~ | ~~Dependency on `egl-wayland`, which is currently failing to build. We are unable to use the SRPM in vault.centos.org for `egl-wayland` due to a newer version of `mesa-libEGL-devel` being present (See https://github.com/NVIDIA/egl-wayland/commit/4a343a4b563e84c6258efbddf1d910f9dd6e0300). Building `egl-wayland` was resolved by checking out the latest code from git.centos.org (produces same version 1.1.4-1) that now contains a patch to fix this. Once `egl-wayland` was built, `egl-wayland-devel` is present to satisfy the dependency.~~ |

<br />

**CentOS 8 PowerTools Repository**:

| Package  |  Notes  |
|:--------|--------------|
| apache-commons-logging |  Builds using `--without avalon` |
| ~~apache-ivy~~ |  ~~Enabled javapackages-tools-201801 module, and turned on javapackages-tools-201801 macros.  Should build fine with MBS.~~ |
| assertj-core | Builds using `--without memoryfilesystem` |
| bsh |  Builds when using `--without desktop` |
| ~~compat-guile18~~ | ~~Incorrect syntax for `Obsoletes` in spec file. Patch: https://github.com/N3WWN/rocky-debranding/tree/master/compat-guile18/ROCKY/CFG~~ |
| dejagnu | Hidden dependency: `screen` (added to list 101) |
| jaxen |  Built using `--without dom4j` **Note:** We have dom4j now in our externals repo and it builds fine with that as well. The original packge was built without dom4j. I would recommend building without dom4j if we want to match the package available from CentOS. |
| maven-doxia |  Builds using `--without itext`, `--without markdown` and `--without fop` |
| maven-doxia-sitetools |  Builds using `--without markdown` and `--without fop` |
| maven-invoker-plugin |  Builds using `--without groovy` |
| maven-plugin-testing |  Depends on `maven-wagon` from PowerTools. See below. Built successfully using maven-wagon in local repo with priority over RockyDevExternals |
| maven-script-interpreter |  Builds using `--without groovy` |
| maven-wagon |  Builds using `--without scm` and `--without ssh` |
| ~~mingw-cairo~~ | ~~Hidden dependencies: `mingw-w64-tools , mingw-libxml2`~~ |
| ~~mingw-gstreamer1~~ | ~~Hidden dependencies: `mingw-w64-tools , mingw-libxml2`~~ |
| ~~mingw-harfbuzz~~ | ~~Hidden dep: `mingw-w64-tools`~~ |
| ~~mingw-sqlite~~ | ~~Hidden dependency: `mingw-pdcurses`~~ |
| pandoc | Need to bootstrap Haskell compiler + dependencies (worked on...) |
| ~~perl-B-Hooks-EndOfScope~~ | ~~Hidden dependency: `perl-Devel-Hide`~~ |
| ~~perl-DateTime-Format-Builder~~ | ~~Hidden dependency: `perl-DateTime-Format-IBeat`~~ |
| ~~perl-DateTime-Locale~~ | ~~Hidden dependency: `perl-File-ShareDir-Install`, `perl-Test-File-ShareDir`~~ |
| ~~perl-Devel-CheckLib~~ | ~~Hidden dependency: `perl-IO-CaptureOutput`~~ |
| ~~perl-JSON-XS~~ | ~~Worked for me with above deps (gmk)~~ |
| ~~perl-MIME-Charset~~ | ~~Worked for me with above deps (gmk)~~ |
| ~~perl-Module-Install-ReadmeFromPod~~ | ~~Hidden dependency: `perl-Module-Install`, `perl-Module-Install-AuthorRequires`, `perl-Module-Install-AutoLicense`, `perl-Test-InDistDir`~~ |
| ~~perl-Params-ValidationCompiler~~ | ~~Hidden dependency: `perl-Test2-Plugin-NoWarnings`, `perl-Test-Without-Module`~~ |
| ~~perl-Readonly~~ | ~~Hidden dependency: `perl-Module-Build-Tiny`, `perl-ExtUtils-Config`, `perl-ExtUtils-Helpers`, `perl-ExtUtils-InstallPaths`~~ |
| ~~perl-Term-Size-Any~~ | ~~Worked for me with above deps (gmk)~~ |
| ~~perl-Unicode-EastAsianWidth~~ | ~~Hidden dependency: `perl-Module-Package`, `perl-Module-Install-ManifestSkip`, `perl-Module-Manifest-Skip`~~ |
| ~~perl-XML-Twig~~ | ~~Hidden dependency: `perl-XML-XPathEngine`~~ |
| perl-gettext	| Incorrect syntax for `Obsoletes` in spec file. Patch: https://github.com/N3WWN/rocky-debranding/tree/master/perl-gettext/ROCKY/CFG|
| perl-DateTime-Locale | Hidden dependency: `perl-Test-File-ShareDir` (added to list 101) |
| perl-Module-Install-ReadmeFromPod | Hidden dependency: `perl-Module-Install-AuthorRequires` and `perl-Test-InDistDir` (added to list 101) |
| pytest | Built by using `--define 'python3_pkgversion 38'`, Hidden dependency: `python-pluggy` >= 0.12 (added to list 101 along with build note) |
| rubygem-rspec-core |  Hidden dependency: `rubygem-thread_order` (Added to hidden dependency list 101). Needs to be built with `module_hotfixes` disabled so that it builds against `rubygems-2.7.6.2` (https://pkgs.dyn.su/rocky-8/artifacts/) |
| rubygem-rspec-mocks | Hidden dependency: `rubygem-thread_order` (Added to hidden dependency list 101). Needs to be built with `module_hotfixes` disabled so that it builds against `rubygems-2.7.6.2` (https://pkgs.dyn.su/rocky-8/artifacts/) |
| rubygem-rspec-support | Hidden dependency: `rubygem-thread_order` (Added to hidden dependency list 101). Needs to be built with `module_hotfixes` disabled so that it builds against `rubygems-2.7.6.2` (https://pkgs.dyn.su/rocky-8/artifacts/) |
| testng | Builds with `--without groovy` and `--without snakeyaml` |
| xbean | Built `--without equinox`, `--without spring` and `--without groovy` |
| xmvn | Built `--without gradle` |

<br />

**External Dependencies**:

| Package  |  Notes  |
|:--------|--------------|
| dom4j | Wacky package.  It must be built using a `jaxen` package that is built with dom4j support, which is not present in CentOS.  We had to bootstrap the dom4j build using `jaxen` from Fedora 29, which is compiled with dom4j support.  |
| perl-* | Be SURE to build against Perl-5.26 (default stream), NOT Perl-5.30 (latest version available).  Required disabling module_hotfixes=1 option to force default Perl.  Maybe fixed by MBS...? |
| maven-* | Requires presence of an /etc/maven.conf , fails if not found.  Added a blank one in mock: ```config_opts['files']['/etc/java/maven.conf'] = " "``` as a workaround |

<br />


**Older SRPM Errors**
These failures were looked at, but are older versions of the packages, and likely not needed:

| Package |  Notes  |
|:--------|----------------|
| device-mapper-multipath-0.8.3-3.el8 | Newest version of systemd gives extra information about version number - "239 (239-41.el8_3.1)" vs. the plain old "239".  So a script fails.  Will build against older versions of Systemd.  We have a newer version of this package that works, it may be Ok to skip. |
| device-mapper-multipath-0.8.3-3.el8_2.3 | Newest version of systemd gives extra information about version number - "239 (239-41.el8_3.1)" vs. the plain old "239".  So a script fails.  Will build against older versions of Systemd.  We have a newer version of this package that works, it may be Ok to skip. |
| samba-4.11.2-13.el8 | Requires python3-ldb version lower or equal to 2.0.999, however actual python3-ldb version is 2.1.3. We have a newer version of this package that works, it may be Ok to skip. (samba-4.12.3) |
| sssd-2.2.3-20.el8 | ERROR: sssd -> requires pam_wrapper rpm (https://git.centos.org/rpms/pam_wrapper.git) We have a newer version of this package that works, it may be Ok to skip. |
| bcc-0.11.0-2.el8 | Unable to find clang-libs even though the dependency that should satisfy this is installed.  Only works with clang 9 or lower, but newer bcc with clang 10 seems ok.  Probably fine to skip.  |
| tigervnc-1.9.0-15.el8_1 | `xorg-server 1.20.7+` requires the impelementation of a ddxInputThreadInit function. A patch that fixes this is in the latest version at git.centos.org and works with `xorg-server 1.20.8-6`. This is what is currently in the repo. (https://git.centos.org/rpms/tigervnc/c/4a81f2fc8757bea7ff2c1d8b1fd881a2bed6803c?branch=c8) The version in vault.centos.org was built against `xorg-server 1.20.3-11`. Suggest skipping this package. |
| sbd-1.4.1-3.el8 | Build error is being caused by a change in Pacemaker (https://bugzilla.redhat.com/show_bug.cgi?id=1850078). This has been fixed in newer versions. Suggest skipping. |
| xorg-x11-drv-intel-2.99.917-38.20180618.el8 | Missing in spec file `BuildRequires: libXv-devel`. Added it to chroot install. CentOS Koji logs show that this hidden dependency was installed for their build (https://koji.mbox.centos.org/pkgs/packages/xorg-x11-drv-intel/2.99.917/38.20180618.el8/data/logs/i686/root.log) |
| webkit2gtk3-2.24.4-2.el8_1 | Looks like a build error that is being caused by `libglvnd` being present. The original build used different subpackages which contained header files. These packages have been removed and appear to be in libglvnd. (See https://bugs.webkit.org/show_bug.cgi?id=204108) `webkit2gtk3-2.24.4-2.el8_1` <--- This version was built against an older version of mesa and libglvnd. Newer versions have been rebased to `webkit2gtk3 2.28`. I would recommend skipping this package since there is a newer one present which works with the latest libraries. |
| ~~spirv-tools-2019.5-1.20200129.git97f1d48.el8~~	| ~~The `spirv headers` have changed and this no longer builds against the latest version present. Suggest skipping since there are newer versions that build fine.~~ |
| spice-gtk-0.37-1.el8	| Missing `BuildRequires: libdrm-devel` in spec file. Is present in subsequent updates. Added `libdrm-devel` to chroot install and was built. |
| vulkan-tools-1.2.131.1-1.el8 | Looks like a lot of newer vulkan headers and dependencies, like spirv, have been updated. Building against newer headers and libraries results in a build failure. Found a Debian post where someone was trying to rebuild the same version that we are trying to rebuild and the resolution was that newer versions have fixed the build issue. Suggest skipping since newer version is present. |
| vulkan-validation-layers-1.2.13{1, 5}.* | Same issue as vulkan-tools. Newer vulkan headers and dependencies being present results in a build failure with this older version.  Suggest skipping. |
