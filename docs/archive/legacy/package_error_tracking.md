---
title: Package Build Issues Tracking
---

This page is for tracking packages that are failing in the Rocky Linux Koji build system (dev/staging): https://kojidev.rockylinux.org .

There are 2 tables.  The upper one is for packages currently under investigation.  The lower table is for packages that have been "solved".  

**A package must be successfully built in Koji before it can be moved to the "solved" table.**  This is to prevent confusion about potential fixes.  Koji is the ultimate arbiter of whether a package has been fixed or not.

Note: the old package error tracking page centered around Skip G.'s CentOS "practice builds" is still available if you need to look at its notes: https://wiki.rockylinux.org/en/team/development/Package_Error_Tracking_older

<br />

## Methodology
The builds being done on kojidev are quite literally real-time progress as the Rocky Linux project races towards a **beta release**. 

To get there, we need to ensure that all of our packages build successfully.  Koji has a list of builds that have failed here:  https://kojidev.rockylinux.org/koji/builds?state=3&order=-build_id  (You can also go to Koji, click on builds, and select "State: Failed" from the drop-down menu)


You can select a package from the failing list that interests you, then click the "task" link that takes you to the failing details page, then click the failing part of the "Descendants" list.

Now you can see the raw Mock build logs from the official build, and investigate. (root.log and build.log are usually the most interesting for debug purposes)  See if you can get the build to work on your system with Mock, and take notes on how you did it (patch, needs a dependency or different version of dependency, etc.)  When you have results, go back to the **Dev/Packaging** channel on chat.rockylinux.org , and report your findings.  Someone will update this page with the findings.

It goes without saying that the more you know about using the Mock build tool, and the RPM package compilation process in general, the better you'll be able to help.  If you need more information about how to build/troubleshoot RPM packages for Rocky Linux, you'll probably want to start with our how to help guide (and read the other guides/material linked from there): https://wiki.rockylinux.org/en/team/development/Packaging_How_to_Help .

<br />

## Communication
Most coordination of these efforts is done over the Mattermost packaging chat channel. (https://chat.rockylinux.org/rocky-linux/channels/dev-packaging , or if you prefer IRC: #rockylinux-devel-packaging on Freenode)

If you're looking at a failing package, please tell everyone there!  That way we can avoid duplication of effort.  When you have a fix, or have discovered information that will help, someone with Wiki access will be happy to take your findings and publish them here.  

<br />
<br />

## Packages Being Investigated:
This is a list of failing builds from **kojidev.rockylinux.org** that have been looked at, and notes added. 

This list is not grouped according to repo.

| Package | Notes |
|:--------|----------------|
| bolt-0.9-1.el8 | Using simple mock chroot (`isolation=simple`) solves permission issues, but there are still 2 tests that fail with signal 5 (SIGTRAP).  Investigation still ongoing |
| graphviz-2.40.1-40 | Fixed if `module_hotfixes=1` is turned off.  It pulls in the latest Ruby 2.7 and not the default Ruby 2.5 stream, which breaks the build |
| marisa | Probably caused by module_hotfixes being on. (Succeeded locally for Leigh + tjyang.  More investigation...?) |
| python-requests | Missing dependency 'python3-pytest-mock' (Succeeded locally for Leigh + tjyang.  More investigation...?) |
| python-psycopg2 | **Failed** locally also.  https://bugzilla.redhat.com/show_bug.cgi?id=1909674  Possible patch required?  https://src.fedoraproject.org/rpms/python-psycopg2/c/89f4b65570783ea763c37311e974296d3ff40d90?branch=master |
| scrub | `x86_64 passed`, aarch64 failed on tests (Succeeded locally for Leigh + tjyang.  More investigation...?) |
| uglify-js| Fixed if `module_hotfixes=1`. Fails when ‘module_hotfixes’ is enabled. This is caused by newer versions of NodeJS. Found a patch that is in newer versions of uglify-js which fixes this for any version of NodeJS.(Succeeded locally for Leigh + tjyang.  More investigation...?) |


<br />
<br />
<br />
<hr />

## Packages that have been fixed:
These packages have been successfully built in Koji after investigation.  They are cut/pasted down here from the upper list once they succeed in Koji.  We are keeping their notes here intact in case of future issues.

| Package | Notes |
|:--------|----------------|
|  |  |
