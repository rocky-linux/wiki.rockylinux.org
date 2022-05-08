---
title: Hidden / External Dependencies
---
This page lists all hidden dependencies required to build the repos and what order they should be built in.

## What is a Hidden Dependency?

This is a general term for any package that is required, but not available in any CentOS repo.  However, these packages are available from git.centos.org alongside "normal" packages found in the repos.

A further complication: there are hidden dependencies that depend on other hidden dependencies.

For example, the well-known package **bind** depends on **kyua**, which is not present in any CentOS/RHEL repository.

Building **kyua** depends on having **lutok**, which in turn depends on having **atf**.  None of these are present in a "normal" CentOS repo. (BaseOS/AppStream/PowerTools/Extras/HA/etc.)

This can get extreme, with some packages requiring 5 (or more!) layers of these "hidden" deps.

## When should these be built?
That's an open question.  A safe time to build these would be starting after "Build Pass 6" (or possibly 7).  A strategy might be to build these completely on their own, or insert them into the "normal package" passes and build them concurrently.  Best way to do this is still an open question.


## Documenting
In an effort to document this, we are compiling layered "lists" of these hidden dependencies.  Very similar to the work being done under "Build_Order" to determine dependencies of the main repos.  You can almost think of these dependencies as another repo, similar to BaseOS/AppStream/PowerTools/etc.

These lists are numbered, and are in order of dependency.  You need to build it smallest to largest.  For example:  In order to build the packages from list 98, you need the ones that were built in list 97. And list 97 depends on the products from list 96, etc.

(The numbers are arbitrary and don't start at 1, so new layers don't require re-labeling of all the lists)

<br />

## The lists:

**External Build List #92**:
| Package Name | CentOS git Branch |
|:------------|-------------------------|
| buildsys-macros | c8 |
| centpkg-minimal | c8 |


**External Build List #93**:

| Package Name | CentOS git Branch |
|:------------|-------------------------|
| javapackages-tools | c8-stream-201902  (note: bootstrap java tools.  contains a bunch of pre-compiled RPMs to satisfy depdencies) 04/08/2021 - pulled out of repo. Causing conflicts. |
| perl-File-Find-Object-Rule | c8 |

<br />

**External Build List #94**:

| Package Name | CentOS git Branch |
|:------------|-------------------------|
| perl-Test-TrailingSpace | c8 |
| perl-XML-Filter-BufferText | c8 |

<br />


**External Build List #95**:

| Package Name | CentOS git Branch |
|:------------|-------------------------|
| perl-XML-SAX-Writer | c8 |
| perl-XML-SemanticDiff | c8 |


<br />

**External Build List #96**:

| Package Name | CentOS git Branch |
|:------------|-------------------------|
| perl-Class-Accessor-Chained | c8 |
| perl-DateTime-Event-Recurrence | c8 |
| perl-Module-Install-GithubMeta | c8 |
| perl-Set-Infinite | c8 |
| perl-strictures | c8 |
| perl-Sub-Quote | c8 |
| perl-Test-XML | c8 |


<br />

**External Build List #97**:

| Package Name | CentOS git Branch |
|:------------|-------------------------|
| perl-Class-ReturnValue | c8 |
| perl-Data-ICal | c8 |
| perl-DateTime-Event-ICal | c8 |
| perl-DateTime-Set | c8 |
| perl-File-Find-Object-Rule | c8 |
| perl-Moo | c8 |
| perl-Text-vFile-asData | c8 |
| perl-Tie-DataUUID | c8 |
| perl-UNIVERSAL-require | c8 |
| perl-XML-Fast | c8 |
| perl-XML-Spice | c8 |


<br />

**External Build List #98**:

| Package Name | CentOS git Branch |
|:------------|-------------------------|
| atf | c8 |
| javapoet | c8 |
| perl-Class-Inner | c8 |
| perl-Convert-Base64 | c8 |
| perl-CPAN-Changes | c8 |
| perl-Data-ICal-TimeZone | c8 |
| perl-DateTime-Format-ICal | c8 |
| perl-File-LibMagic | c8 |
| perl-Net-DAVTalk | c8 |
| perl-Text-LevenshteinXS | c8 |
| perl-Text-VCardFast | c8 |
| rubygem-coderay | c8 |
| tesla-polyglot | c8 `--with jp_minimal` |

<br />

**External Build List #99**:

| Package Name | CentOS git Branch |
|:------------|-------------------------|
| auto | c8 |
| beakerlib | c8 |
| centos-bookmarks | c8 |
| console-setup | c8 |
| datefudge | c8 |
| docbook5-style-xsl | c8 |
| eclipse-license2 | c8 |
| fasterxml-oss-parent | c8-stream-10.6 |
| felix-gogo-parent | c8 |
| felix-gogo-runtime | c8 |
| fonttools | c8 |
| gcab | c8 |
| imaptest | c8 |
| javapackages-tools | c8-stream-201902/javapackages-tools-5.3.1-7.module+el8.2.0+5555+73059ce4 |
| latexmk | c8 |
| libabigail | c8 |
| lutok | c8 |
| objectweb-asm (7.2) | c8-stream-201902 |
| objectweb-asm (7.3) | c8-stream-rhel8 `--without junit5` (needed to build byte-buddy)|
| opentest4j | c8 |
| pam_wrapper | c8 |
| perl-BSD-Resource | c8 |
| perl-Config-IniFiles | c8 |
| perl-Font-TTF | c8 |
| perl-Mail-IMAPTalk | c8 |
| perl-Mail-JMAPTalk | c8 |
| perl-Math-Int64 | c8 |
| perl-Net-CalDAVTalk | c8 |
| perl-NNTPClient | c8 |
| perl-PerlIO-gzip | c8 |
| perl-Test-Inter | c8 |
| perl-Test-Unit | c8 |
| perl-XML-Generator | c8 |
| polkit-gnome | c8 |
| psutils | c8 |
| python3-mallard-ducktype | c8 |
| python-blinker | c8 |
| python-cryptography-vectors | c8 |
| python-httpretty | c8 |
| python-pretend | c8 |
| rubygem-kramdown | c8 |
| sassc | c8 |
| shrinkwrap | c8 |
| ttembed | c8 |
| ttfautohint | c8 |
| tycho-extras | c8 |
| univocity-parsers | c8 |
| wordnet | c8 |
| xmlgraphics-commons | c8-stream-rhel8 (requires workaround setting JAVA_HOME ) |
| xpp3 | c8 |

<br />

**External Build List #100**:

| Package Name | CentOS git Branch |
|:------------|-------------------------|
| apache-commons-el | c8 |
| apiguardian | c8 |
| base64coder | c8 |
| batik | c8-stream-rhel8-bootstrap |
| byte-buddy | c8-stream-201902 |
| cbi-plugins | c8 |
| decentxml | c8 |
| ecj | c8 |
| eclipse-ecf | c8 `--with bootstrap` |
| eclipse-emf | c8 `--with bootstrap` |
| felix-gogo-command | c8 |
| felix-gogo-shell | c8 |
| felix-scr | c8 |
| golang-github-cpuguy83-go-md2man | c8-stream-1.0 |
| google-gson | c8 |
| hamcrest | c8-stream-201902 |
| icu4j | c8-stream-rhel8 |
| jackson-parent | c8-stream-10.6 |
| jboss-modules | c8 |
| jetty | c8 `--with jp_minimal` |
| junit5 | c8 |
| kyua | c8 |
| kxml | c8 |
| lucene | c8 `--with jp_minimal` |
| msv | c8-stream-10.6 |
| ocaml-fileutils | c8 |
| perl-File-MMagic  | c8 |
| perl-List-Pairwise | c8 |
| perl-File-Slurp-Tiny | c8-stream-5.26 |
| perl-Module-Install-ExtraTests | c8 |
| sat4j | c8 |
| xml-maven-plugin | c8 |
<br />

**External Build List #101**:

| Package Name | CentOS git Branch |
|:------------|-------------------------|
| catch | c8 |
| catch1 | c8 |
| ceres-solver | c8 |
| classloader-leak-test-framework | c8 |
| eclipse | c8 `--with bootstrap` |
| glassfish-jax-rs-api | c8-stream-10.6 |
| glslang | c8 |
| jackson-bom | c8-stream-10.6 |
| jarjar | c8 |
| java-comment-preprocessor | c8 |
| jboss-logmanager | c8 |
| maven-verifier-plugin | c8 |
| mdds (1.3) | c8 |
| mdds (1.4) | c8s (-b imports/c8s/mdds-1.4.3-1.el8) |
| mingw-w64-tools | c8 |
| mingw-libxml2 | c8 |
| mingw-pdcurses | c8 |
| mockito (2) | c8-stream-201902 |
| ocaml-calendar | c8 |
| ocaml-csv | c8 |
| ocaml-curses | c8 |
| ocaml-gettext | c8 |
| ocaml-libvirt | c8 |
| ocaml-xml-light | c8 |
| passivetex | c8
| PEGTL | c8 |
| perl-B-Hooks-EndOfScope | c8 |
| perl-DateTime-Format-IBeat | c8 |
| perl-Devel-Hide | c8 |
| perl-Encode-IMAPUTF7 | c8 |
| perl-ExtUtils-Config | c8 |
| perl-ExtUtils-Helpers | c8 |
| perl-ExtUtils-InstallPaths | c8 |
| perl-File-ShareDir-Install| c8 |
| perl-Test-File-ShareDir | c8 |
| perl-IO-CaptureOutput | c8 |
| perl-Crypt-OpenSSL-Guess | c8 |
| perl-Module-Install | c8 |
| perl-Module-Install-AuthorRequires | c8 |
| perl-Module-Install-AutoLicense| c8 |
| perl-Module-Install-ManifestSkip | c8 |
| perl-Module-Build-Tiny | c8 |
| perl-Module-Package | c8 |
| perl-Module-Manifest-Skip | c8 |
| perl-Net-CardDAVTalk | c8 |
| perl-Net-DNS-Resolver-Mock | c8 |
| perl-Net-DNS-Resolver-Programmable | c8 |
| perl-Net-IDN-Encode | c8 |
| perl-Net-LibIDN | c8 |
| perl-Object-Deadly | c8 |
| perl-Test-FailWarnings | c8 |
| perl-Test-File-ShareDir | c8 |
| perl-Test-InDistDir | c8 |
| perl-Test-MockModule | c8 |
| perl-Test-Needs | c8 |
| perl-Test-RequiresInternet | c8 |
| perl-Test-Without-Module | c8 |
| perl-Test2-Plugin-NoWarnings | c8 |
| perl-XML-XPathEngine | c8 |
| prometheus-simpleclient-java | c8 |
| properties-maven-plugin | c8 |
| python-bottle | c8 |
| python-hs-dbus-signature | c8 |
| python-pluggy | c8-stream-3.8 `--without tests` |
| python-sphinx | c8 |
| qt5-doc | c8 |
| relaxngcc | c8-stream-10.6 |
| replacer | c8 |
| screen | c8 |
| SFML | c8 |
| snakeyaml | c8s |
| spirv-headers | c8 |
| tesseract | c8 |
| ucpp | c8 |
| unicode-emoji | c8 |
| python-docutils  | c8 |
| rapidjson  | c8-stream-8.0 |
| rubygem-thread_order | c8 |
| perl-Expect | c8-stream-5.26 |
| perl-Perl-Version | c8-stream-5.26 |
| perl-Sort-Versions | c8-stream-5.26 |
| perl-Test-Output  | c8-stream-5.26 |
| tycho | c8-stream-rhel8-bootstrap (required a spec patch to build ) |
