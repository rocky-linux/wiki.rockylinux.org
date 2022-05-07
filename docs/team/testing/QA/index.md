---
title: QA:Test Cases
revision_date: 2022-04-20
---

This page lists all test cases in work and who is working on them...

## Initialization Requirements

| Requirement                                         | Test Case                                                                | Assignee                | Status                                  |
| --------------------------------------------------- | ------------------------------------------------------------------------ | ----------------------- | --------------------------------------- |
| [Release-blocking images must boot](release_criteria.md#release-blocking-images-must-boot) | [QA:Testcase Boot Methods Boot ISO](Testcase_Boot_Methods_Boot_Iso.md) | @tcooper | template exists, openQA covered (ref) |
| [Release-blocking images must boot](release_criteria.md#release-blocking-images-must-boot) | [QA:Testcase Boot Methods DVD](Testcase_Boot_Methods_Dvd.md) | @tcooper | template exists, openQA covered (ref) |
| [Basic Graphics Mode behaviors](release_criteria.md#basic-graphics-mode-behaviors) | [QA:Testcase Basic Graphics Mode](Testcase_Basic_Graphics_Mode.md) | @tcooper | manual and/or new openQA TestCase |
| [No Broken Packages](release_criteria.md#no-broken-packages) | [QA:Testcase Media Repoclosure](Testcase_Media_Repoclosure.md)<br>[QA:Testcase Media File Conflicts](Testcase_Media_File_Conflicts.md) | @tcooper | manual using scripts or automated in CI |
| [Repositories Must Match Upstream](release_criteria.md#repositories-must-match-upstream) | [QA:Testcase repocompare](Testcase_Repo_Compare.md) | @tcooper | manual using Skip's repocompare |
| [Debranding](release_criteria.md#debranding) | [QA:Testcase Debranding Analysis](Testcase_Debranding.md) | @tcooper | process TBD |


## Installer Requirements

| Requirement                                         | Test Case                                                                | Assignee                | Status                                  |
| --------------------------------------------------- | ------------------------------------------------------------------------ | ----------------------- | --------------------------------------- |
| Media Consistency Verification                      | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Packages and Installer Sources                      | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| NAS (Network Attached Storage)                      | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Installation Interfaces                             | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Minimal Installation                                | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Kickstart Installation                              | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Disk Layouts                                        | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Firmware RAID                                       | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Bootloader Disk Selection                           | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Storage Volume Resize                               | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Update Image                                        | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Installer Help                                      | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Installer Translations                              | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |


## Cloud Image Requirements

| Requirement                                         | Test Case                                                                | Assignee                | Status                                  |
| --------------------------------------------------- | ------------------------------------------------------------------------ | ----------------------- | --------------------------------------- |
| Images Published to Cloud Providers                 | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |


## Post-Installation Requirements

| Requirement                                         | Test Case                                                                | Assignee                | Status                                  |
| --------------------------------------------------- | ------------------------------------------------------------------------ | ----------------------- | --------------------------------------- |
| System Services                                     | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Keyboard Layout                                     | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| SELinux Errors (Server)                             | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| SELinux and Crash Notifications (Desktop Only)      | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Default Application Functionality (Desktop Only)    | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Default Panel Functionality (Desktop Only)          | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Dual Monitor Setup (Desktop Only)                   | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Artwork and Assets (Server and Desktop)             | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |
| Packages and Module Installation                    | [QA:Testcase TBD](Testcase_Template.md)                                  | @tbd                    |                                         |


{% include 'content_bottom.md' %}
