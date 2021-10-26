---
title: How to Help - Getting Started with Package Debugs
---

## Intro - What needs to be done
The area we need help the most right now, and the easiest way to contribute, is to help troubleshoot failing package builds.

We're rebuilding CentOS 8.3 as "practice", so we can figure out any issues that crop up with our official Rocky build ahead of time.  We are documenting any errors we find in the packages and how to fix them (to make it build).  This documentation will help our release engineering team when it comes time to do official builds.


## Get Familiar with the `mock` build tool:

Check out the wiki on `mock`'s [GitHub repository](https://github.com/rpm-software-management/mock/wiki) for some starter information that links out to additional reading at the [bottom](https://github.com/rpm-software-management/mock/wiki#see-also).

The biggest and most relevant technical/intro page for our package debugging effort can be found on our [Mock Building Guide](/team/development/Mock_Build_Howto) here on the wiki.


We are using the `mock` program to perform our builds, just like the real Rocky infrastructure will.  You should install it and get very used to it. Please use this guide to get started, and explain a bit about what we hope to achieve and why we have to build all these packages in a specific order.

Please read those carefully, and maybe dip your toe in the water by feeding your mock an SRPM or 2 and compiling some things.

Mock is really great, as it's an easy-to-call program that constructs an entire system inside a chroot to perform the build, then cleans it up afterwards.

If you'd like a reference for Mock config files to look at or play with, there are some published [here](https://rocky.lowend.ninja/RockyDevel/mock_configs/) (that correspond with the "Build Passes" being done to test package builds). More information about the passes can be found here on the wiki at: `/team/development/Build_Order/Build_Pass_{1..X}_{Artifacts,Failure,RPMs,Successful}` <small>... (which will definitely be cleaned up later, we just want to avoid breaking any existing links at such a critical juncture).</small>

Once you're familiar with `mock` (and especially digging through its output logs), we have a list of failing packages that we need to investigate and come up with explanations and/or fixes for.




## Helping with the debug effort:

Once you are familiar with Mock, and especially with debugging its output, you can begin looking at failing packages. Some of this information is also on the [Mock Build Howto](/team/development/Mock_Build_Howto) page.


1. Find a failing package on the newest build pass failures page (currently [Build Pass 10](/team/development/Build_Order/Build_Pass_10_Failure)).

2. Make sure the package hasn't already been looked at and/or fixed:  **https://wiki.rockylinux.org/en/team/development/Package_Error_Tracking**

3. Let other debuggers know what you're working on!  We don't want to duplicate effort.  Hop on the [~Dev/Packaging](https://chat.rockylinux.org/rocky-linux/channels/dev-packaging) channel on mattermost!

4. Set your mock program up with the [most recent configs that we are using](https://rocky.lowend.ninja/RockyDevel/mock_configs/).  You can use it to attempt the build in the same way as we do (with external dependencies, extra repos, etc.)

5. Investigate the error(s):  You can use your own mock, as well as the log files from when the build failed, located here:  **https://rocky.lowend.ninja/RockyDevel/MOCK_RAW/**

6. Figure out what's going on, and how to fix it.  It may take the form of special mock settings, or a patch added to the program + specfile.  Report your findings to the [~Dev/Packaging](https://chat.rockylinux.org/rocky-linux/channels/dev-packaging) channel, and someone will record them on the [Wiki Package_Error_Tracking page](https://wiki.rockylinux.org/en/team/development/Package_Error_Tracking) page.

7. The idea is to shrink the Build Failures, and grow the [Package_Error_Tracking](/team/development/Package_Error_Tracking) page.  If necessary, we will commit build fixes to our [patch repo](https://git.rockylinux.org/staging/patch) for the different packages.
