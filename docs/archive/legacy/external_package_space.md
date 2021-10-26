---
title: External Package Scratch Space
---

This is a staging area for current work on external dependencies.  Once confirmed working, items from these lists will be removed and added to the "official" Hidden/External Dependencies Wiki page.

Packages listed should use the default "c8" branch, unless otherwise noted in parentheses

(Remember: all perl deps built without "module_hotfix" dnf option, we want to build w/ default Perl 5.26 stream)

<br />

### To add to External build list 100:
```
# Build Deps 100:
(empty, for now - moved to the official page)
```

<br />

### To add to the External build list 101:
```
# Build Deps 101:
(empty, for now - moved to the official page)
```

<br />

### To add to the External build list 102:
```
# Build Deps 102:

```

<br />

### Still being figured out:
```


################
**** Notes for Tycho build ****

apache-commons-codec namespace changed between 1.11 and 1.13

From koji build log for 1.11 (https://koji.mbox.centos.org/pkgs/packages/apache-commons-codec/1.11/3.module_el8.0.0+39+6a9b6e22/data/logs/noarch/build.log)

	"Provides: apache-commons-codec = 1.11-3.module_el8.0.0+39+6a9b6e22 mvn(commons-codec:commons-codec) = 1.11 mvn(commons-codec:commons-codec:pom:) = 1.11 osgi(org.apache.commons.codec) = 1.11.0"

	Notice that it says it provides osgi(org.apache.commons.codec)
	
From koji bild log for 1.13 (https://koji.mbox.centos.org/pkgs/packages/apache-commons-codec/1.13/3.module_el8.3.0+568+0c23fd64/data/logs/noarch/build.log)

	"Provides: apache-commons-codec = 1.13-3.module_el8.3.0+568+0c23fd64 mvn(commons-codec:commons-codec) = 1.13 mvn(commons-codec:commons-codec:pom:) = 1.13 osgi(org.apache.commons.commons-codec) = 1.13.0"
	
	Notice that it says it provides osgi(org.apache.commons.commons-codec)
	
The change from 'org.apache.commons.codec' to 'org.apache.commons.commons-codec' breaks the build of tycho

Patching the files in the source file org.eclipse.tycho-tycho-1.4.0.tar.xz to refer to "org.apache.commons.commons-codec" resolved the build.
	Files touched inside source file: org.eclipse.tycho-tycho-1.4.0/tycho-bundles/tycho-bundles-external/tycho-bundles-external.product
					  org.eclipse.tycho-tycho-1.4.0/tycho-bundles/tycho-standalone-p2-director/p2 Director.product
					  
Patched tycho-bootstrap.sh as well



SKIPS NOTE:
Potentially patch in tycho .spec file:
find . -iname "*.product" -type f | xargs -n 1  -I {} sed -i 's/org\.apache\.commons\.codec/org\.apache\.commons\.commons\-codec/g' "{}"
find . -iname "*.sh" -type f | xargs -n 1  -I {} sed -i 's/org\.apache\.commons\.codec/org\.apache\.commons\.commons\-codec/g' "{}"
#########################





Maven issues - https://pagure.io/centos-infra/issue/210, https://bugzilla.redhat.com/show_bug.cgi?id=1897375
--------------------------------------------------------------------------------------------------
Attempt to install "maven" package as part of setting up mock environment, as mentioned in Bugzilla report results in packaging conflicts


Error: Transaction test error:
  file /usr/share/java/maven-resolver/maven-resolver-api.jar from install of maven-resolver-api-1:1.1.1-2.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package maven-resolver-1.4.1-3.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/maven-poms/maven-resolver/maven-resolver-api.pom from install of maven-resolver-api-1:1.1.1-2.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package maven-resolver-1.4.1-3.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/java/maven-resolver/maven-resolver-util.jar from install of maven-resolver-util-1:1.1.1-2.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package maven-resolver-1.4.1-3.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/maven-poms/maven-resolver/maven-resolver-util.pom from install of maven-resolver-util-1:1.1.1-2.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package maven-resolver-1.4.1-3.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/java/maven-resolver/maven-resolver-spi.jar from install of maven-resolver-spi-1:1.1.1-2.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package maven-resolver-1.4.1-3.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/maven-poms/maven-resolver/maven-resolver-spi.pom from install of maven-resolver-spi-1:1.1.1-2.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package maven-resolver-1.4.1-3.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/java/org.eclipse.sisu.inject.jar from install of sisu-inject-1:0.3.3-6.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package sisu-0.3.4-2.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/maven-poms/org.eclipse.sisu.inject.pom from install of sisu-inject-1:0.3.3-6.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package sisu-0.3.4-2.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/java/org.eclipse.sisu.plexus.jar from install of sisu-plexus-1:0.3.3-6.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package sisu-0.3.4-2.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/maven-poms/org.eclipse.sisu.plexus.pom from install of sisu-plexus-1:0.3.3-6.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package sisu-0.3.4-2.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/java/maven-resolver/maven-resolver-impl.jar from install of maven-resolver-impl-1:1.1.1-2.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package maven-resolver-1.4.1-3.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/maven-poms/maven-resolver/maven-resolver-impl.pom from install of maven-resolver-impl-1:1.1.1-2.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package maven-resolver-1.4.1-3.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/java/maven-wagon/provider-api.jar from install of maven-wagon-provider-api-0:3.1.0-1.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package maven-wagon-3.3.4-2.module_el8.3.0+568+0c23fd64.noarch
  file /usr/share/maven-poms/maven-wagon/provider-api.pom from install of maven-wagon-provider-api-0:3.1.0-1.module_el8.0.0+39+6a9b6e22.noarch conflicts with file from package maven-wagon-3.3.4-2.module_el8.3.0+568+0c23fd64.noarch
----------------------------------------------------------------------------------------------------------




Trying to build new version of maven with fix to known bug in it: https://bugzilla.redhat.com/show_bug.cgi?id=1897375

maven - c8-stream-3.6
	No matching package to install: 'mvn(org.codehaus.modello:modello-maven-plugin) >= 1.10.0'
	No matching package to install: 'mvn(org.mockito:mockito-core) >= 2'
	No matching package to install: 'mvn(org.xmlunit:xmlunit-core)'
	No matching package to install: 'mvn(org.xmlunit:xmlunit-matchers)'
	dependency - slf4j-sources - produced by 'slf4j' branch c8-stream-3.6 - depends on maven??

```
<br /><br />

### Dependencies that we need to find packages for:
```
## Dependencies I'm not sure about, and suggested(?) packages that might provide them:
## (need to investigate these, and when found, add their packages to the list above)
## Listed as dependency first, then possible package that it comes from after:

eclipse-pde  ->  eclipse ??  

hibernate-jpa-2.0-api ??
hsqldb -> hsqldb-lib ??

pkgconfig(wayland-eglstream) ????
pkgconfig(wayland-eglstream-protocols) ????
springframework-beans ????
qt5-qtbase-doc   qt5-qbase (?)

mvn(avalon-framework:avalon-framework-api)   avalon-framework ??
mvn(avalon-framework:avalon-framework-impl)  avalon-framework ??

mvn(ch.qos.logback:logback-classic) ????

mvn(com.fasterxml.jackson:jackson-base:pom:) jackson, or fasterxml-oss-partent ??
mvn(com.fasterxml.jackson:jackson-parent:pom:) jackson, or fasterxml-oss-partent ??

mvn(com.googlecode.json-simple:json-simple)   ????
mvn(com.google.code.maven-replacer-plugin:replacer)  replacer ??

mvn(com.jcraft:jsch.agentproxy.connector-factory) jsch ??
mvn(com.jcraft:jsch.agentproxy.jsch)  jsch ??

mvn(dom4j:dom4j)  -> dom4j

mvn(io.prometheus:simpleclient)  prometheus-simpleclient-java
mvn(io.prometheus:simpleclient_common)  prometheus-simpleclient-java
mvn(io.prometheus:simpleclient_hotspot)  prometheus-simpleclient-java
mvn(io.prometheus:simpleclient_httpserver)  prometheus-simpleclient-java

mvn(javax.ws.rs:javax.ws.rs-api)  glassfish-jax-rs-api ??

mvn(logkit:logkit)  avalon-logkit ??

mvn(net.sf.ehcache:ehcache-core)  ????
mvn(net.spy:spymemcached)  ????

mvn(org.apache.maven.scm:maven-scm-api)  maven-scm ??
mvn(org.apache.maven.scm:maven-scm-manager-plexus)  maven-scm ??

mvn(org.codehaus.modello:modello-maven-plugin)  modello ??


mvn(org.mockito:mockito-core)  mockito ??
mvn(org.xmlunit:xmlunit-core)  xmlunit
mvn(org.xmlunit:xmlunit-matchers)  xmlunit
mvn(org.yaml:snakeyaml)  snakeyaml

```
