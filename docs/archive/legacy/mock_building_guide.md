---
title: Build Order Effort:  How to Help
---

If you're interested in helping with Rocky Linux packaging effort, we could use you!  One of the critical things we need done is to figure out which order the packages need to be built, and determine any outside/external build dependencies.  Read more to see what we mean:


## What Needs to be Done?
Many source packages in RHEL/CentOS will not build properly by themselves.  Often, you need some RPMs produced from other packages built first, and available as dependencies.  

**Our Mission:** is to help the release engineering team by identifying these chains of dependencies, and figuring out which order we need to build things in.  Additionally, we need to identify any **external dependencies** that the package builds require.  All of this information must be documented so we can build the initial version of Rocky Linux (Based on RHEL/CentOS 8.3).

We are building a complete copy of CentOS 8.3 (from the CentOS repositories) and taking notes on it.

<br />

### Types of Package Dependencies/Failures


**1:  Devel dependencies within the distro**

These dependencies (often in the form of "-devel" RPMs) are not available in the regular CentOS repositories (BaseOS, AppStream, PowerTools), but must be produced by first building other packages.  For example, the package **curl** requires **libmetalink-devel** to build properly.   The **libmetalink-devel** RPM is not available in the default repositories, you must produce it by taking the **libmetalink** source RPM and compiling it.
<br />

**2:  Dependencies outside the distro**

Some packages require packages at build-time which are not in the CentOS/RHEL repositories at all.  These must be identified, compiled to RPMs, and made available to our build process.  Fortunately, these "external" dependencies are all located at **https://git.centos.org** .  They can be checked out with the proper branch and compiled to SRPMs and then RPMs.
<br />

**3:  Build time failures**

Some packages just fail to build for other reasons when using the default Mock build settings.   We must investigate these failures and figure out workarounds.  And most importantly, take notes on how we solved the issues.

For example, some RPMs related to the Java **maven** tool will refuse to build without a ```/etc/maven.conf``` file present.  We can set our Mock tool up to create a blank maven.conf and work around this requirement.  We need to make a note of this, because it's something extra that needs to be done in order for the build to succeed.

<br />


## How do we do this?

Building RPM packages in the modern era is done via the **mock** build tool.   ( https://github.com/rpm-software-management/mock )  Mock creates a blank chroot and installs a minimal system inside it.  It then builds the source RPMs via classic **rpmbuild** tool inside the chroot.

This guarantees that only the packages that are actually required for the build process are present, and no extra dependencies accidentally creep in.


### Using and Installing Mock
Mock is a simple tool written in Python, and is widely available.  It's in the EPEL repo under CentOS/RHEL 8, and is even available in some Debian based distros.  We are using **Mock version 2.6** (default in EPEL 8) for our research builds here.

Mock is easy to use:  
```mock -r /etc/mock/myconfig.cfg  --nocheck   --resultdir=/path/to/results    curl-7.61.1-14.el8.1.src.rpm ```

The mock configuration lets you specify what gets put in your minimal chroot, and what repositories DNF will use when setting up the build.  Fortunately, we have a standardized mock config you can download and use yourself (linked below), so you don't have to go through and set everything up yourself.

Log files will be written to your results path during the build.  If the build was successful, the resulting RPMs will also be present there.

<br />

### Reading Mock Output
Mock produces log files with standard/consistent names during each build.  The most important ones that we care about are: **root.log** and **build.log**.  

Root.log details the process that was used to set up the chroot environment.  It shows what commands were issued, and especially what packages were installed.  A missing dependency will usually show up here, when mock will attempt to *dnf install* a dependency and not find it.

Build.log details the actual package build process.  This includes the compilation step(s) for whatever langauge the packaged software was written in (C, C++, Java, Rust, etc.).  It also includes any other steps/scripts outlined in the .spec file that get performed.  Build failures that don't involve dependencies usually show up in here.

<br />

## Links and Next Steps (How to Start Helping!)

We are tracking the results of this effort on the Wiki.  If you click "Browse" in the top left, and navigate to **Development** -> **Build_Order** , you'll see many pages that refer to "Build passes".

A **build pass** is very simple:

1. Use mock to attempt to build all ~3000 packages in CentOS, using only the default BaseOS, AppStream, and PowerTools repositories.
2. Record which packages passed, and which ones failed to build.  As well as what RPM files were produced from doing the build pass. (this is what is in those wiki pages)
3. Take the produced RPMs and add them to repositories, so the next build pass can use them as dependencies.
4. DO IT AGAIN! (and again, and again...)
5. Once we've built everything, we will use these pages as a reference.  We now know what order we need to feed these 

Fortunately, Skip Grube has a server and is executing these build passes.  We need help troubleshooting individual packages.  Read on...

<br />

### Where we need help:
We've done enough build passes now that we have most (but not all) of the dependencies lined up in order.  We need to investigate the remaining failed packages and determine why they are failing.

We must answer questions like: Is the package failing because it needs a dependency?  Is it external, or will it be automatically produced in one of the build passes?  Is it failing because of some other error?

<br />

### How you can help exactly (with links!):

**Step 0:** Get familiar with the Mock build tool and its configuration.  Learn how to build SRPMs, and how to check out branches from **git.centos.org**, turn them into SRPMs, and compile them with Mock.
<br />

**Step 1:**
The latest build pass (as of this document) is #10.  So here are the build failures: **https://wiki.rockylinux.org/en/team/development/Build_Order/Build_Pass_10_Failure**  

Pick one to investigate, and make sure it's NOT on this list of packages we have already solved: **https://wiki.rockylinux.org/en/team/development/Package_Error_Tracking**
<br />

**Step 2:** You can view the Mock build logs for that failed package under here:  **https://rocky.lowend.ninja/RockyDevel/MOCK_RAW/** (sorted by repo and package name).  
<br />

**Step 3:** Once you've investigated the log(s), try to build the package yourself, in your own mock.  Our exact Mock configurations are available here: **https://rocky.lowend.ninja/RockyDevel/mock_configs/** (sorted by build pass number), and SRPMs are available from CentOS here: **https://vault.centos.org/8.3.2011/** (sorted by repo)
<br />

**Step 4:** This is the tricky part, and involves troubleshooting skills.  Why exactly is the package failing?  How do you get the build to succeed?  This may involve hunting dependencies, fiddling with the .spec file in the SRPM, or playing with mock options.
<br />

**Step 5:** If you solve one, please TELL US ABOUT IT!  Hop over to chat.rockylinux.org .  We hang out in the #Dev/Packaging channel, and are always listening!  Ping @Skip Grube  or  @Michael Young and let us know how you fixed it!  We'll add it to our knowledge base as soon as we can, and thanks!
