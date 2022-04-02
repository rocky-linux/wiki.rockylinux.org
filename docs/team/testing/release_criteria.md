---
title: Rocky Linux 8 Release Criteria
author: Trevor Cooper
revision_date: 2021-04-01
rc:
  prod: Rocky Linux
  ver: 8
  level: Final
---

# {{ rc.level }} Release Objectives

{% include 'testing/rc_content_example_only.md' %}

The objective of a release (major or minor) is to provide a solid Enterprise Linux release that is suitable to:

- Meet the needs of end users
- Meet the needs of enterprises big or small

## {{ rc.level }} Release Requirements

In order for {{ rc.prod }} to be released to the general public, a compose must be able to meet all the following criteria as provided in this document. This is allows the decision process to be straightforward and as clear as possible. This document only contains “hard requirement” items. Optional/nice to have items are not to be included in this list.

There may cases where a requirement cannot be met but only in particular configurations. In these types of cases, the Release Engineering Team should use their judgement to determine whether or not the issue should be considered to block the release. They should consider the number of users likely to be affected by said issue, the severity of the case, if the issue can be avoided with ease (by both informed and uninformed users), and if the problem exists upstream in the current Red Hat Enterprise Linux that the release is based on.

!!! info "Release-blocking Server"
    ...means bugs as it pertains to server functionality can be considered to block a release. This applies to any packages that provide a service such as httpd, nginx, etc. All architectures apply.

!!! info "Release-blocking Desktop"
    ...means bugs as it pertains to desktop functionality (GNOME) can be considered to block a release. This applies to both x86_64 and aarch64. Additional desktops (as provided by EPEL or a SIG) are not considered blockers.

!!! info "Release-blocking Image"
    ...means bugs as it pertains to the images built that can block a release. This applies to the DVD, minimal, and boot images on all architectures.

### Initialization Requirements

#### Release-blocking images must boot

Release-blocking installer images must boot when written to optical media of an appropriate size (if applicable) and when written to a USB flash drive with a supported method (rufus is not supported). It is not the testing team’s responsibility to test optical media, but they can and report back. If a bug is found, it is considered a blocker.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Basic Graphics Mode behaviors
The generic video driver option (“basic graphics mode”) on all release-blocking installers must function as intended. This means launching the installer or desktop and attempting to use a generic driver. There must be no bugs that prevent the installer from being reached in this configuration on all systems and classes of hardware supported by the enterprise linux kernel.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### No Broken Packages
Critical errors, such as undeclared conflicts, unresolved dependencies, or modules relying on packages from another stream will be considered an automatic blocker. There are potential exceptions to this (eg, freeradius cannot be installed on an older perl stream, this is a known issue upstream).
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Repositories Must Match Upstream
Repositories and the packages within them should match upstream as close as possible. Notable exceptions would be kmods, kpatch, or what is deemed as “spyware” like insights. Packages that are available from upstream should not have hard requirements on RHSM and packages that have it default built in should be patched out.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Debranding
Assets and functionality that are Red Hat specific should not be included. If they are not patched out, it will be considered an automatic blocker.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

### Installer Requirements

#### Media Consistency Verification
This means that the installer’s mechanism for verifying the install medium is intact and must complete successfully, with the assumption that the medium was correctly written. It should return a failure message if this not the case.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Packages and Installer Sources
The installer must be able to use all supported local/remote packages and installer sources.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### NAS (Network Attached Storage)"
The installer must be able to detect and install to supported NAS devices (if possible and supported by the kernel).
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Installation Interfaces
The installer must be able to complete an installation using all supported spokes.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Minimal Installation
A minimal installation (via network) must be able to install the minimal package set.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Kickstart Installation
A kickstart installation should succeed, whether from optical/USB media or via the network.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Disk Layouts
The installer must be able to create and install to any workable partition layout using any file system or format combination offered or supported by the installer. File systems that are not supported by the EL kernel is not tested here (this means btrfs, zfs, both of wish are not supported).
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Firmware RAID
The installer must be able to detect and install to firmware RAID devices. Note that system-specific bugs do not count as blockers. It is likely that some hardware support might be broken or not available at all. DUDs (driver update disks) are not considered for this criteria.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Bootloader Disk Selection
The installer must allow the user to choose which disk the bootloader will be installed to or, if the user so chooses, not to install a bootloader.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Storage Volume Resize
Any installer mechanism for resizing storage volumes must correctly attempt the requested operation. This means that if the installer offers a way to resize storage volumes, then it must use the correct resizing tool with the correct parameters. However, it does not require the installer to disallow resizing of unformatted or volumes with an unknown filesystem type.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Update Image
The installer must be able to use an installer update image retrieved from removable media or a remote package source. This includes DUDs (driver update disks).
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Installer Help
Any element in the installer which contains a “help” text must display the appropriate help documentation when selected.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Installer Translations
The installer must correctly display all complete translations that are available for use.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

### Cloud Image Requirements
#### Images Published to Cloud Providers
Release-blocking cloud disk images must be published to appropriate cloud providers (such as Amazon) and they must successfully boot. This also applies to KVM based instances, such as x86 and aarch64 systems.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

### Post-Installation Requirements
#### System Services
All system services present after installation must start properly, with the exception of services that require hardware which is not present. Examples of such services would be:
    - sshd
    - firewalld
    - auditd
    - chronyd
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Keyboard Layout
If a particular keyboard layout has been configured for the system, that layout must be used:
    - When unlocking storage volumes (encrypted by LUKS)
    - When logging in at a TTY console
    - When logging in via GDM
    - After logging into a GNOME desktop system, if the user does not have their own layout configuration set.

??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### SELinux Errors (Server)
There must be no SELinux denial logs in /var/log/audit/audit.log

??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### SELinux and Crash Notifications (Desktop Only)
There must be no SELinux denial notifications or crash notifications on boot, during installation, or during first login.

??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Default Application Functionality (Desktop Only)
Applications that can be launched within GNOME or on the command line must start successfully and withstand basic functionality tests. This includes:
    - Web browser
    - File manager
    - Package manager
    - Image/Document Viewers
    - Text editors (gedit, vim)
    - Archive manager
    - Terminal Emulator (gnome terminal)
    - Problem Reporter
    - Help Viewer
    - System Settings

??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Default Panel Functionality (Desktop Only)
All elements of GNOME should function properly in regular use.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Dual Monitor Setup (Desktop Only)
Computers using two monitors, the graphical output is correctly shown on both monitors.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Artwork and Assets (Server and Desktop)
Proposed final artwork (such as wallpapers and other assets) must be included. A wallpaper from this package should show up as a default for GDM and GNOME.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

#### Packages and Module Installation
Packages (non-module) should be able to be installed without conflicts or dependent on repositories outside of {{ rc.prod }}.
    - Default modules (as listed in dnf module list) should be installed without requiring them to be enabled.
    - Module streams should be able to be switched and those packages should be able to be installed without errors or unresolved dependencies.
??? tldr "References"
    - Test cases:
        - [QA:Testcase_TBD](QA/Testcase_Template.md)

{% include 'testing/rc_content_bottom.md' %}
