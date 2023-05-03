---
title: Manual Install of OpenQA for rockylinux
author: Alan Marshall
revision_date: 2023-05-03
rc:
  prod: Rocky Linux
  level: Draft
---


#### Intended Audience
Those who wish to use the OpenQA automated testing system configured for Rocky Linux tests. To run your own automated tests in OpenQA, you need a PC or server with hardware-virtualisation and an up-to-date Fedora Linux.

### Introduction
This guide explains the use of the OpenQA automated testing system to test various aspects of Rocky Linux releases either at the pre-release stage or thereafter.

OpenQA is an automated test tool that makes it possible to test the whole installation process. It uses virtual machines which it sets up to reproduce the process, check the output (both serial console and GUI screen) in every step and send the necessary keystrokes and commands to proceed to the next step. OpenQA checks whether the system can be installed, whether it works properly, whether applications work and whether the system responds as expected to different installation options and commands.

OpenQA can run numerous combinations of tests for every revision of the operating system, reporting the errors detected for each combination of hardware configuration, installation options and variant of the operating system.

Upstream documentation is useful for reference but since it is a mixture of advice and instructions relating to openSUSE and Fedora which have substantial differences between them it is not always clear which are significant for Rocky.  However, as an rpm based distribution, Rocky Linux use is closely related to the Fedora version.

### WebUI
The web UI is a very useful feature of the OpenQA system since it provides an easily accessed view of the progress and details of OpenQA tests either on the local machine or remotely or both. It is intended to be intuitive and self-explanatory. Look out for the little blue help icons and click them for detailed help on specific sections.

Some pages use queries to select what should be shown. The query parameters are generated on clickable links, for example starting from the index page or the group overview page clicking on single builds. On the query pages there can be UI elements to control the parameters, for example to look for older builds or show only failed jobs, or other settings. Additionally, the query parameters can be tweaked by hand if you want to provide a link to specific views.

## Step-by-step Install Guide

OpenQA can be installed only on a Fedora (or OpenSUSE) server or workstation.

```
# install Packages
# for openqa
sudo dnf install openqa openqa-httpd openqa-worker fedora-messaging python3-jsonschema
sudo dnf install perl-REST-Client.noarch

# and for createhdds
sudo dnf install libguestfs-tools libguestfs-xfs python3-fedfind python3-libguestfs
sudo dnf install libvirt-daemon-config-network libvirt-python3 virt-install withlock

# configure httpd:
cd /etc/httpd/conf.d/
sudo cp openqa.conf.template openqa.conf
sudo cp openqa-ssl.conf.template openqa-ssl.conf
sudo setsebool -P httpd_can_network_connect 1
sudo systemctl restart httpd

# configure the web UI
sudo vi /etc/openqa/openqa.ini

[global]
branding=plain
download_domains = rockylinux.org
[auth]
method = Fake

sudo dnf install postgresql-server
sudo postgresql-setup --initdb

# enable and start services
sudo systemctl enable postgresql --now
sudo systemctl enable httpd --now
sudo systemctl enable openqa-gru --now
sudo systemctl enable openqa-scheduler --now
sudo systemctl enable openqa-websockets --now
sudo systemctl enable openqa-webui --now
sudo systemctl enable fm-consumer@fedora_openqa_scheduler --now
sudo systemctl enable libvirtd --now
sudo setsebool -P httpd_can_network_connect 1
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --reload
sudo systemctl restart httpd

# to create API key in local web interface at http://localhost
#   or on remote system   http://<ip addr>
# Click Login, then Manage API Keys, create a key and secret.

# insert key and secret
sudo vi /etc/openqa/client.conf

[localhost]
key = ...
secret = ...

# create workers
sudo systemctl enable openqa-worker@1 --now
# then ...@2 ...etc as desired. Look in webui workers to check shown idle.
# as a rule of thumb, you can have about half the number of workers as cores

# get Rocky tests
cd /var/lib/openqa/tests/
sudo git clone https://github.com/rocky-linux/os-autoinst-distri-rocky.git rocky
sudo chown -R geekotest:geekotest rocky
cd rocky

# when working in /var/lib/openqa nearly all commands need sudo so it is
#   easier to su to root. If desired sudo per command can be used instead.
sudo su
git config --global --add safe.directory /var/lib/openqa/share/tests/rocky

git checkout develop
# or whichever branch has the latest updates for your tests

./fifloader.py -l -c templates.fif.json templates-updates.fif.json
git clone https://github.com/rocky-linux/createhdds.git  ~/createhdds
mkdir -p /var/lib/openqa/share/factory/hdd/fixed

# will need about 200GB disk space available for ongoing tests
cd /var/lib/openqa/factory/hdd/fixed

# start a long running process that provides hdd image files for ongoing tests
~/createhdds/createhdds.py all

# get Rocky iso files for testing
mkdir -p /var/lib/openqa/share/factory/iso/fixed
cd /var/lib/openqa/factory/iso/fixed

curl -LOR https://dl.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.1-x86_64-boot.iso
curl -LOR https://dl.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.1-x86_64-minimal.iso
curl -LOR https://dl.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.1-x86_64-dvd.iso

# post tests and view progress on webui
cd /var/lib/openqa/tests/rocky/
openqa-cli api -X POST isos ISO=Rocky-9.1-x86_64-minimal.iso ARCH=x86_64 DISTRI=rocky FLAVOR=minimal-iso VERSION=9.1 BUILD="$(date +%Y%m%d.%H%M%S).0"-minimal
openqa-cli api -X POST isos ISO=Rocky-9.1-x86_64-boot.iso ARCH=x86_64 DISTRI=rocky FLAVOR=boot-iso VERSION=9.1 BUILD="$(date +%Y%m%d.%H%M%S).0"-boot

```
At this point your system is configured for single vm deployment and it can be used as such. Pause here if you wish to get some practice using openqa before progressing further.
Facilities for multi-vm testing which is substantially more complicated is beyond the scope of this document.


### Helper Scripts

see:
https://github.com/rocky-linux/os-autoinst-distri-rocky/tree/develop/scripts

cancel-build.sh is especially useful when you discover that you have initiated a large build and got it wrong... d'oh.

### Using Templates

#### Problem
A problem arises when testing an operating system, especially when doing continuous testing, that there is always a certain combination of jobs, each one with its own settings, that needs to be run for every revision. Those combinations can be different for different 'flavors' of the same revision, like running a different set of jobs for each architecture. This combinational problem can go one step further if OpenQA is being used for different kinds of tests, like running some simple pre-integration tests for some snapshots combined with more comprehensive post-integration tests for release candidates.

This section describes how an instance of OpenQA *could* be configured using the options in the admin area of the webUI to automatically create all the required jobs for each revision of your operating system that needs to be tested. *If* you were starting from scratch (the difficult way), you would probably go through the following order:

1. Define machines in 'Machines' menu
1. Define medium types (products) you have in 'Medium types' menu
1. Specify various collections of tests you want to run in the 'Test suites' menu
1. Define job groups in 'Job groups' menu for groups of tests
1. Select individual 'Job groups' and decide what combinations make sense and need to be tested

If you followed the install guide above then the cloned Rocky tests from github.com/rocky-linux/os-autoinst-distri-rocky.git will have pre-configured the admin area of the webUI. You may find it useful when reading the following sections.

Machines, mediums, test suites and job templates can all set various configuration variables. The job templates within the job groups define how the test suites, mediums and machines should be combined in various ways to produce individual 'jobs'. All the variables from the test suite, medium, machine and job template are combined and made available to the actual test code run by the 'job', along with variables specified as part of the job creation request. Certain variables also influence OpenQA’s and/or os-autoinst’s own behavior in terms of how it configures the environment for the job.

#### Machines
You need to have at least one machine set up to be able to run any tests. Those machines represent virtual machine types that you want to test. To make tests actually happen, you have to have an 'OpenQA worker' connected that can fulfill those specifications.

- Name. User defined string - only needed for operator to identify the machine configuration.
- Backend. What backend should be used for this machine. Recommended value is qemu as it is the most tested one, but other options (such as kvm2usb or vbox) are also possible.
- Variables Most machine variables influence os-autoinst’s behavior in terms of how the test machine is set up. A few important examples:
  - QEMUCPU can be 'qemu32' or 'qemu64' and specifies the architecture of the virtual CPU
  - QEMUCPUS is an integer that specifies the number of cores you wish for

  - USBBOOT when set to 1, the image will be loaded through an emulated USB stick.

#### Medium Types (products)
A medium type (product) in OpenQA is a simple description without any definite meaning. It basically consists of a name and a set of variables that define or characterize this product in os-autoinst.

Some example variables are:

- ISO_MAXSIZE contains the maximum size of the product. There is a test that checks that the current size of the product is less or equal than this variable.
- DVD if it is set to 1, this indicates that the medium is a DVD.
- LIVECD if it is set to 1, this indicates that the medium is a live image (can be a CD or USB)
- GNOME this variable, if it is set to 1, indicates that it is a GNOME only distribution.
- RESCUECD is set to 1 for rescue CD images.

#### Test Suites
A test suite consists of a name and a set of test variables that are used inside this particular test together with an optional description. The test variables can be used to parameterize the actual test code and influence the behaviour according to the settings.

Some sample variables are:

- DESKTOP possible values are 'kde' 'gnome' 'lxde' 'xfce' or 'textmode'. Used to indicate the desktop selected by the user during the test.
- ENCRYPT encrypt the home directory via YaST.
- HDDSIZEGB hard disk size in GB.
- HDD_1 path for the pre-created hard disk
- RAIDLEVEL RAID configuration variable

#### Job Groups
The job groups are the place where the actual test scenarios are defined by the selection of the medium type, the test suite and machine together with a priority value.

The priority value is used in the scheduler to choose the next job. If multiple jobs are scheduled and their requirements for running them are fulfilled the ones with a lower priority value are triggered. The id is the second sorting key: of two jobs with equal requirements and same priority value the one with lower id is triggered first.

Job groups themselves can be created over the web UI as well as the REST API. Job groups can optionally be nested into categories. The display order of job groups and categories can be configured by drag-and-drop in the web UI.

The scenario definitions within the job groups can be created and configured by different means:

- A simple web UI wizard which is automatically shown for job groups when a new medium is added to the job group.
- An intuitive table within the web UI for adding additional test scenarios to existing media including the possibility to configure the priority values.
- The scripts OpenQA-load-templates and OpenQA-dump-templates to quickly dump and load the configuration from custom plain-text dump format files using the REST API.
- Using declarative schedule definitions in the YAML format using REST API routes or an online-editor within the web UI including a syntax checker.

### Needles
Needles are very precise and the slightest deviation from the specified display will be detected. This means that every time there is a new release, very small changes occur in layout of displays resulting in many new or modified needles being required. There is always a significant amount of work needed by the Test Team to produce the automatic tests for a new version.

### Glossary
The following terms are used within the context of OpenQA:-

test module
* An individual test case in a single perl module (.pm) file, e.g. "sshxterm". If not further specified a test module is denoted with its "short name" equivalent to the filename including the test definition. The "full name" is composed of the test group (TBC), which itself is formed by the top-folder of the test module file, and the short name, e.g. "x11-sshxterm" (for x11/sshxterm.pm)

test suite
1. A collection of test modules, e.g. "textmode". All test modules within one test suite are run serially
job
1. One run of individual test cases in a row denoted by a unique number for one instance of OpenQA, e.g. one installation with subsequent testing of applications within gnome

test run
* Equivalent to job
test result
* The result of one job, e.g. "passed" with the details of each individual test module
test step
* the execution of one test module within a job

distri
* A test distribution but also sometimes referring to a product (CAUTION: ambiguous, historically a "GNU/Linux distribution"), composed of multiple test modules in a folder structure that compose test suites, e.g. "rocky" (test distribution, short for "os-autoinst-distri-rocky")

product
* The main "system under test" (SUT), e.g. "rocky", also called "Medium Types" in the web interface of OpenQA

job group
* Equivalent to product, used in context of the webUI

version
* One version of a product, don’t confuse with builds

flavor
* Keyword for a specific variant of a product to distinguish differing variants, e.g. "dvd-iso"

arch
* An architecture variant of a product, e.g. "x86_64"

machine
* Additional variant of machine, e.g. used for "64bit", "uefi", etc.

scenario
* A composition of <distri>-<version>-<flavor>-<arch>-<test_suite>@<machine>, e.g. "Rocky-9-dvd-x86_64-gnome@64bit"

build
* Different versions of a product as tested, can be considered a "sub-version" of version, e.g. "Build1234"; CAUTION: ambiguity: either with the prefix "Build" included or not

#### History (briefly)
Openqa started with OS-autoinst: automated testing of Operating Systems
The OS-autoinst project aims at providing a means to run fully automated tests, especially to run tests of basic and low-level operating system components such as bootloader, kernel, installer and upgrade, which can not easily be tested with other automated testing frameworks. However, it can just as well be used to test firefox and openoffice operation on top of a newly installed OS.
OpenQA is a test-scheduler and web-front for openSUSE and Fedora using OS-autoinst as a backend.
OpenQA originated at openSuse and was adopted by Fedora as the automated test system for their frequent distribution updates. Maintenance activity is fairly intense and is ongoing at various levels of users. OpenQA was adopted by Rocky Linux Test Team as the preferred automated testing system for the ongoing releases of it's distribution.
OpenQA is free software released under the GPLv2 license.

#### Attribution
This guide is heavily inspired by the numerous upstream documents in which installation and usage of OS-autoinst and OpenQA are described.

#### References
Since Rocky Linux use of OpenQA is drawn from upstream Fedora and hence openSUSE this document contains **many** passages which are edited versions of upstream documentation and that use is hereby gratefully acknowledged. As with many open source projects, we build on previous work.


