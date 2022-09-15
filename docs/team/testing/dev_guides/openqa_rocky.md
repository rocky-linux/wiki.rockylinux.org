---
title: openQA
author: Alan Marshall
revision_date: 2022-09-15
rc:
  prod: Rocky Linux
  vers: 8 & 9
  level: Draft
---

###### Purpose
This guide pulls together a summary specifically for Rocky Linux from the numerous areas in which installation and usage of openQA is described. It is intended to be useable in itself but will reference (and perhaps comment on) upstream documentation in a helpful way.

###### Intended Audience
Those who wish to use the openQA automated testing system configured for Rocky Linux tests.

## Contents
<will be automated>

#### Introduction
This guide explains the use of the openQA automated testing system to test various aspects of Rocky Linux releases either at the pre-release stage or thereafter.
openQA is an automated test tool that makes it possible to test the whole installation process. It uses virtual machines to reproduce the process, check the output (both serial console and screen) in every step and send the necessary keystrokes and commands to proceed to the next step. openQA checks whether the system can be installed, whether it works properly, whether applications work or whether the system responds as expected to different installation options and commands.
openQA can run several combinations of tests for every revision of the operating system, reporting the errors detected for each combination of hardware configuration, installation options and variant of the operating system.
Upstream documentation is useful for reference but it is a mixture of advice and instructions relating to openSUSE and Fedora which have significant differences between them and it is not always clear which is being referred to.
As you would expect, Rocky Linux is closely related to the Fedora version.

#### History
openQA is free software released under the GPLv2 license.

#### Installation

#### Operation

#### References
Since Rocky Linux use of openQA is drawn from upstream openSUSE and Fedora this document contains many passages which are edited versions of upstream documentation and that use is hereby acknowledged. As with many open source projects, we build on previous work.
##### Appendix A

