---
title: QA:Test Cases
revision_date: 2022-05-06
---

This page lists all test cases in work and who is working on them...

## Initialization Requirements

| Requirement                                         | Test Case                                                                | Assignee                | Status                                  |
| --------------------------------------------------- | ------------------------------------------------------------------------ | ----------------------- | --------------------------------------- |
| [Release-blocking images must boot](9_release_criteria.md#release-blocking-images-must-boot) | [QA:Testcase Boot Methods Boot ISO](Testcase_Boot_Methods_Boot_Iso.md) | @tcooper | template exists, openQA covered (ref) |
| [Release-blocking images must boot](9_release_criteria.md#release-blocking-images-must-boot) | [QA:Testcase Boot Methods DVD](Testcase_Boot_Methods_Dvd.md) | @tcooper | template exists, openQA covered (ref) |
| [Basic Graphics Mode behaviors](9_release_criteria.md#basic-graphics-mode-behaviors) | [QA:Testcase Basic Graphics Mode](Testcase_Basic_Graphics_Mode.md) | @tcooper | manual and/or new openQA TestCase |
| [No Broken Packages](9_release_criteria.md#no-broken-packages) | [QA:Testcase Media Repoclosure](Testcase_Media_Repoclosure.md)<br>[QA:Testcase Media File Conflicts](Testcase_Media_File_Conflicts.md) | @tcooper | manual using scripts or automated in CI |
| [Repositories Must Match Upstream](9_release_criteria.md#repositories-must-match-upstream) | [QA:Testcase repocompare](Testcase_Repo_Compare.md) | @tcooper | manual using Skip's repocompare |
| [Debranding](9_release_criteria.md#debranding) | [QA:Testcase Debranding Analysis](Testcase_Debranding.md) | @tcooper | process TBD |


## Installer Requirements

| Requirement                                         | Test Case                                                                | Assignee                | Status                                  |
| --------------------------------------------------- | ------------------------------------------------------------------------ | ----------------------- | --------------------------------------- |
| Media Consistency Verification                      | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Packages and Installer Sources                      | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    | Implemented in openQA, document         |
| NAS (Network Attached Storage)                      | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Installation Interfaces                             | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    | Implemented in openQA, document         |
| Minimal Installation                                | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    | Implemented in openQA, document         |
| Kickstart Installation                              | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    | Implemented in openQA, document         |
| Disk Layouts                                        | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    | Implemented in openQA, document         |
| Firmware RAID                                       | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Bootloader Disk Selection                           | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Storage Volume Resize                               | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    | Implemented in openQA, document         |
| Update Image                                        | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    | Implemented in openQA, document         |
| Installer Help                                      | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    | Implemented in openQA, document         |
| Installer Translations                              | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    | Implemented in openQA, document         |


## Cloud Image Requirements

| Requirement                                         | Test Case                                                                | Assignee                | Status                                  |
| --------------------------------------------------- | ------------------------------------------------------------------------ | ----------------------- | --------------------------------------- |
| Images Published to Cloud Providers                 | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |


## Post-Installation Requirements

| Requirement                                         | Test Case                                                                                                         | Assignee                | Status                                  |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------- | --------------------------------------- |
| System Services                                     | [QA:Testcase System Services](Testcase_Template.md)                                                               | @lumarel                | testcase filename reserved              |
| Keyboard Layout                                     | [QA:Testcase Keyboard Layout](Testcase_Template.md)                                                               | @lumarel                | testcase filename reserved              |
| SELinux Errors (Server)                             | [QA:Testcase SELinux Errors on Server installations](Testcase_Template.md)                                        | @lumarel, @raktajino    | testcase filename reserved              |
| SELinux and Crash Notifications (Desktop Only)      | [QA:Testcase SELinux Errors on Desktop clients](Testcase_Template.md)                                             | @lumarel, @raktajino    | testcase filename reserved              |
| Default Application Functionality (Desktop Only)    | [QA:Testcase Application Functionality](Testcase_Template.md)                                                     | @lumarel                | testcase filename reserved              |
| Default Panel Functionality (Desktop Only)          | [QA:Testcase GNOME UI Functionality](Testcase_Template.md)                                                        | @lumarel                | testcase filename reserved              |
| Dual Monitor Setup (Desktop Only)                   | [QA:Testcase Multimonitor Setup](Testcase_Template.md)                                                            | @lumarel                | testcase filename reserved              |
| Artwork and Assets (Server and Desktop)             | [QA:Testcase Artwork and Assets](Testcase_Template.md)                                                            | @lumarel                | testcase filename reserved              |
| Packages and Module Installation                    | [QA:Testcase Basic Package installs](Testcase_Template.md)<br>[QA:Testcase Module Streams](Testcase_Template.md)  | @lumarel                |                                         |


{% include 'content_bottom.md' %}
