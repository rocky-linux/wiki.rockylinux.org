---
title: openQA for rocky
editor: Alan Marshall
revision_date: 2022-10-23
rc:
  prod: Rocky Linux
  vers:
    -  8
    -  9
  level: Draft
---

#### History (briefly)

OpenQA originated at openSuse and was adopted by Fedora as the automated test system for their frequent distribution updates. Maintenance activity is fairly intense and is ongoing at various levels of users. OpenQA was adopted by Rocky Linux Test Team as the preferred automated testing system for the ongoing releases of it's distribution.
openQA is free software released under the GPLv2 license.

#### Attribution

This guide is heavily inspired by the numerous upstream documents in which installation and usage of openQA is described.

###### Intended Audience
This is an augmented summary for those who wish to use the openQA automated testing system configured for Rocky Linux tests.

## Contents
<preferably automated>

#### Introduction
This guide explains the use of the openQA automated testing system to test various aspects of Rocky Linux releases either at the pre-release stage or thereafter.
openQA is an automated test tool that makes it possible to test the whole installation process. It uses virtual machines set up via libvirt (but not qemu) to reproduce the process, check the output (both serial console and GUI screen) in every step and send the necessary keystrokes and commands to proceed to the next step. openQA checks whether the system can be installed, whether it works properly, whether applications work or whether the system responds as expected to different installation options and commands.
openQA can run numerous combinations of tests for every revision of the operating system, reporting the errors detected for each combination of hardware configuration, installation options and variant of the operating system.

Upstream documentation is useful for reference but since it is a mixture of advice and instructions relating to openSUSE and Fedora which have significant differences between them it is not always clear which are significant for Rocky.
As you would expect, as an rpm based distribution, Rocky Linux is closely related to the Fedora version.

### Templates


This section describes how an instance of openQA could be configured using the options in the admin area to automatically create all the required jobs for each revision of your operating system that needs to be tested. **If** you were starting from scratch, you would probably go through the following order:

1. Define machines in 'Machines' menu

1. Define medium types (products) you have in 'Medium types' menu

1. Specify various collections of tests you want to run in the 'Test suites' menu

1. Define job groups in 'Job groups' menu for groups of tests

1. Select individual 'Job groups' and decide what combinations make sense and need to be tested

Machines, mediums, test suites and job templates can all set various configuration variables. The so called job templates within the job groups define how the test suites, mediums and machines should be combined in various ways to produce individual 'jobs'. All the variables from the test suite, medium, machine and job template are combined and made available to the actual test code run by the 'job', along with variables specified as part of the job creation request. Certain variables also influence openQA’s and/or os-autoinst’s own behavior in terms of how it configures the environment for the job.


### Needles

The needles are very precise and the slightest deviation from the required display will be detected. This means that every time there is a new release, very small changes occur in layout of displays resulting in many new needles being required. There is always a significant amount of work needed by the test team to produce the automatic tests for a new version.

#### Operation

##### webUI

### Helper Scripts

#### Installation

##### Glossary

The following terms are used within the context of openQA:-

test module

* An individual test case in a single perl module (.pm) file, e.g. "sshxterm". If not further specified a test module is denoted with its "short name" equivalent to the filename including the test definition. The "full name" is composed of the test group (TBC), which itself is formed by the top-folder of the test module file, and the short name, e.g. "x11-sshxterm" (for x11/sshxterm.pm)

test suite

1. A collection of test modules, e.g. "textmode". All test modules within one test suite are run serially
job

1. One run of individual test cases in a row denoted by a unique number for one instance of openQA, e.g. one installation with subsequent testing of applications within gnome

test run
* Equivalent to job

test result
* The result of one job, e.g. "passed" with the details of each individual test module

test step
* the execution of one test module within a job

distri

* A test distribution but also sometimes referring to a product (CAUTION: ambiguous, historically a "GNU/Linux distribution"), composed of multiple test modules in a folder structure that compose test suites, e.g. "rocky" (test distribution, short for "os-autoinst-distri-rocky")

product

* The main "system under test" (SUT), e.g. "rocky", also called "Medium Types" in the web interface of openQA

job group

* Equivalent to product, used in context of the webUI

version

* One version of a product, don’t confuse with builds

flavor

* A specific variant of a product to distinguish differing variants, e.g. "DVD"

arch

* An architecture variant of a product, e.g. "x86_64"

machine

* Additional variant of machine, e.g. used for "64bit", "uefi", etc.

scenario

* A composition of <distri>-<version>-<flavor>-<arch>-<test_suite>@<machine>, e.g. "Rocky-9-dvd-x86_64-gnome@64bit"

build

* Different versions of a product as tested, can be considered a "sub-version" of version, e.g. "Build1234"; CAUTION: ambiguity: either with the prefix "Build" included or not

#### References
Since Rocky Linux use of openQA is drawn from upstream Fedora and hence openSUSE this document contains **many** passages which are edited versions of upstream documentation and that use is hereby gratefully acknowledged. As with many open source projects, we build on previous work.

##### Appendix A

