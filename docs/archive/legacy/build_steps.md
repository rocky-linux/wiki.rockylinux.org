---
title: Rocky Build Process Overview (Revised)
---

**UPDATE2: updated version of this document published 2021-01-04 , lots of conceptual work has been done, many more things finalized**

This is a simple document that explains going from RHEL sources to freshly (re)-built Rocky Linux packages.  It's not intended to be overly technical or specific at all, just an introduction (and general plan) to someone interested in how the process will work.


## The Steps: Going from RHEL 8 Source to Rocky 8 Binary Package
1:  Obtain the RHEL sources via SRPM or CentOS Git

2-3: Import RHEL source into Rocky Linux Git, replace any protected trademarks / branding from the source

4:  Produce a Rocky 8 Source RPM from the Rocky Linux Git repository for the package, likely using Koji/MBS/Mock RPM build tools

5: Compile the source RPM to a Rocky 8 binary RPM using the build tools

6: Sign and test the RPM in an automatic way

7: Deploy it to the Rocky Linux repository, and distribute to users

<br />

Obviously, each of these steps has a lot more to it.  This document will not get in-depth about ways and means of accomplishing each step.  We prefer each of these to be as automated as possible.  We'll take a (short) look at each one in turn, and the various options available to achieve them:

<br />

### Step 1: Obtain the Source
This is fairly straightforward.  If you want to re-build RHEL 8, you need the source to RHEL 8.  There are 2 main ways to do this:

* Download source RPM files on a RHEL machine via yum/dnf
* Copy them from https://git.centos.org (which are identical to RHEL and have tagged versions)

The packaging team has decided to go with option #2: copying from CentOS Git.  This minimizes potential legal questions with RHEL subscription terms, and is a simple operation to perform.  SRPM extraction can be used in the future in case of any issues with the CentOS Git site.

Tools are now being developed to perform this step in an automated fashion.  CentOS (and Fedora) use an MQ messaging solution to indicate when new commits are made to a repository.  We intend to consume those published messages as well to get alerted when we should build a new package.

We have news that https://git.centos.org will be the actual commit location for RHEL sources in the future, so we should be in good company!



**Future Doc:** There will be another document explaining exactly what is in the CentOS Git branches, how to navigate, etc.



<br />

### Steps 2-3: Import source to Git, and replace branding
This is a big technical question-mark, and will need to be carefully considered.

Each package in RHEL should have a corresponding Rocky Linux Git repository dedicated to it.  For example: Rocky Linux will have a bash repository, a python3 repository, a python3-gpg repository, etc.  **One git repo for each package.**  Yes, that is a lot of git repositories.

The decision from our infrastructure team is to go with a (self-hosted) **Gitlab** instance.

This section will outline some of the major technical hurdles being considered:


#### Second git that's private?
It is legally questionable to host raw RHEL material due to trademark issues.  There are a couple of options:

* Host a second, private git that holds raw RHEL sources waiting to be de-branded
* De-brand sources via script or patch as they are imported, and place the result into the main, public git repos

**Tentative Answer:** Applying de-brand patches at the same time as import seems viable.  So no need for a separate private repo.


#### Git package/binary strategy
Packages are distributed as specfiles, patches, and the upstream/original source as a tarball (.tar.gz, tar.bz2, etc.).  Text files are easy enough in git, but there are different strategies for storing these upstream tar files.

**Answer:** The agreed-upon strategy is to use a lookaside caching mechanism, just like Fedora and CentOS proper.  The one used is called dist-git, and involves a separate script that downloads a tarfile that matches to a checked out git branch.

If this doesn't work out, git-lfs is also a popular option for binary storage.



#### Files/Folders, Tags/Branches layout in Git:
Should we stick to the folders/tags/branches layout in git.centos.org?  Or something quite different?  Should we place debranding metadata with the project, or somewhere else?  How about automated/scripted test cases?  There is a lot to consider here.

**Tentative Answer:** Our Git layout will likely mirror certain branches of packages in git.centos.org, but with different names.  Debranding metadata will be kept separate, as well as metadata related to modular package builds.

<br />

### Step 4: Produce a Rocky Linux source RPM
Once in a Rocky repository, the contents of a package should correspond directly to its SRPM equivalent.

The debranding should be complete by this point, so a build system (Koji) will be able to point to the repository, grab the source for it, and construct our Rocky SRPM using Mock and other RPM tools.

Special attention will have to be paid to the "modular/stream" RPMs in RHEL 8.  The Modular Build System (MBS) service that interacts with Koji needs to be set up properly to accomodate this.

Particulars of the build config will depend on the answers to steps 2-3 above:  What folder(s) will things be in, where will the binary tar file data be located, etc.



<br />

### Step 5: Produce a Rocky Linux Binary RPM
This is pretty straightforward.  Once we have a valid source RPM, we use our build system to extract, compile, and produce a valid binary RPM.

Again, special consideration is needed for modular/stream packages, and dependencies.

**Note about dependencies:**  Not everything required to build the packages in RHEL is available in RHEL.  Some packages require other packages to be built first, and their **-devel** packages produced before another package will compile properly.  RHEL/CentOS do not maintain a public location for these "extra" dependencies, but Rocky Linux plans to.  There will likely be another document later spelling this information out in more detail.

Once complete, we're ready to test, sign, and send it off to the official repository (and mirrors!).


<br />


### Step 6: Sign and Test
RPMs produced by us should be cryptographically signed with a Rocky Linux key, which guarantees to users that the package was indeed built by the Rocky Linux project.

The package will also need to be put through some testing - preferably automated.  The nature of the testing is yet to be determined, but we'll want to do some sanity checks at the bare minimum before unleashing it on the world.  (Is this package installable?  Did we accidentally miss any files?  Does it cause dnf/yum dependency conflicts? etc.)

<br />

### Step 7: Deploy to Repository
Once a package is complete and tested, it will be uploaded to the Rocky Linux repository, and picked up/cloned by a network of repository mirrors around the world.  The Rocky 8 source RPM will of course be uploaded as well.

Users of the distro will then see it when they `dnf update` or `dnf install` !


<br />

### Closing Note:
This is version "3" of this document.  We are now about a month into the project, and have come a long way in our understanding!

The technical folks examining this have learned much in a short time, and already have working proof-of-concept RPM pipelines(!)  Come join in ~Dev/Packaging on Mattermost and we're happy to discuss package/release pipeline direction.

There are still several questions to answer, particularly in regards to steps 2-3.  Progress is being made, though.

Spelling out what needs to be done is much easier than actually accomplishing it.

This document remains a work-in-progress, as more technical information comes in.

This document remains a rough draft, and is likely to go through more revision as we learn more.

<br />

Thanks,

-Skip Grube (Mattermost)  (skip77 on IRC)
