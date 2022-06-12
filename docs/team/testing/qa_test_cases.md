---
title: QA:Test Cases
revision_date: 2022-05-19
rc:
  prod: Rocky Linux
---

This page lists all test cases in work and who is working on them...

## Initialization Requirements

| Requirement                                         | Test Case                                                                | Assignee                | Status                                  |
| --------------------------------------------------- | ------------------------------------------------------------------------ | ----------------------- | --------------------------------------- |
| Release-blocking images must boot<br>[{{ rc.prod }} 8](8_release_criteria.md#release-blocking-images-must-boot) [{{ rc.prod }} 9](9_release_criteria.md#release-blocking-images-must-boot) | [QA:Testcase Boot Methods Boot ISO](Testcase_Boot_Methods_Boot_Iso.md) | @tcooper | template exists, openQA covered (ref) |
| Release-blocking images must boot<br>[{{ rc.prod }} 8](8_release_criteria.md#release-blocking-images-must-boot) [{{ rc.prod }} 9](9_release_criteria.md#release-blocking-images-must-boot) | [QA:Testcase Boot Methods DVD](Testcase_Boot_Methods_Dvd.md) | @tcooper | template exists, openQA covered (ref) |
| Basic Graphics Mode behaviors<br>[{{ rc.prod }} 8](8_release_criteria.md#basic-graphics-mode-behaviors) [{{ rc.prod }} 9](9_release_criteria.md#basic-graphics-mode-behaviors) | [QA:Testcase Basic Graphics Mode](Testcase_Basic_Graphics_Mode.md) | @tcooper | manual and/or new openQA TestCase |
| No Broken Packages<br>[{{ rc.prod }} 8](8_release_criteria.md#no-broken-packages) [{{ rc.prod }} 9](9_release_criteria.md#no-broken-packages) | [QA:Testcase Media Repoclosure](Testcase_Media_Repoclosure.md)<br>[QA:Testcase Media File Conflicts](Testcase_Media_File_Conflicts.md) | @tcooper | manual using scripts or automated in CI |
| Repositories Must Match Upstream<br>[{{ rc.prod }} 8](8_release_criteria.md#repositories-must-match-upstream) [{{ rc.prod }} 9 ](9_release_criteria.md#repositories-must-match-upstream) | [QA:Testcase repocompare](Testcase_Repo_Compare.md) | @tcooper | manual using Skip's repocompare |
| Debranding<br>[{{ rc.prod }} 8](8_release_criteria.md#debranding) [{{ rc.prod }} 9](9_release_criteria.md#debranding) | [QA:Testcase Debranding Analysis](Testcase_Debranding.md) | @tcooper | process TBD |


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

| Requirement                                      | Test Case                                                                                                                                | Assignee | Status                                                               |
|--------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|----------|----------------------------------------------------------------------|
| System Services                                  | [QA:Testcase System Services](Testcase_Post_System_Services.md)                                                                          | @lumarel | manual guide documented or needs new openQA testcase                 |
| Keyboard Layout                                  | [QA:Testcase Keyboard Layout](Testcase_Post_Keyboard_Layout.md)                                                                          | @lumarel | implemented in openQA                                                |
| SELinux Errors (Server)                          | [QA:Testcase SELinux Errors on Server](Testcase_Post_SELinux_Errors_Server.md)                                                           | @lumarel | implemented in openQA                                                |
| SELinux and Crash Notifications (Desktop Only)   | [QA:Testcase SELinux Errors on Desktop](Testcase_Post_SELinux_Errors_Desktop.md)                                                         | @lumarel | partly implemented in openQA                                         |
| Default Application Functionality (Desktop Only) | [QA:Testcase Application Functionality](Testcase_Post_Application_Functionality.md)                                                      | @lumarel | manual guide documented                                              |
| Default Panel Functionality (Desktop Only)       | [QA:Testcase GNOME UI Functionality](Testcase_Post_GNOME_UI_Functionality.md)                                                            | @lumarel | implemented in openQA, additionally documented for manual inspection |
| Dual Monitor Setup (Desktop Only)                | [QA:Testcase Multimonitor Setup](Testcase_Post_Multimonitor_Setup.md)                                                                    | @lumarel | manual guide documented                                              |
| Artwork and Assets (Server and Desktop)          | [QA:Testcase Artwork and Assets](Testcase_Post_Artwork_and_Assets.md)                                                                    | @lumarel | implemented in openQA, additionally documented for manual inspection |
| Packages and Module Installation                 | [QA:Testcase Basic Package installs](Testcase_Post_Package_installs.md)<br>[QA:Testcase Module Streams](Testcase_Post_Module_Streams.md) | @lumarel | partly implemented in openQA, manual guide documented                |


{% include 'content_bottom.md' %}
