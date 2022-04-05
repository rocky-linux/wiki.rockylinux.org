---
title: QA:Testcase Boot Methods Boot Iso
author: Trevor Cooper
revision_date: 2022-04-01
rc:
  prod: Rocky Linux
  ver: 8
  level: Final
---

{% include 'testing/qa_content_example_only.md' %}

!!! info "Associated release criterion"
    This test case is associated with the [Release_Criteria#initialization-requirements](../release_criteria.md#initialization-requirements) release criterion. If you are doing release validation testing, a failure of this test case may be a breach of that release criterion.

## Description
This is to verify that the Anaconda installer starts correctly when booting from netinst.iso (or boot.iso, which is just a different name for the same file).

## Setup
1. Prepare your system for booting a netinst.iso image. This may involve writing the image to a USB key, or burning it to an optical disk.

## How to test
1. Boot the system from the prepared optical or USB media.
2. In the boot menu select the appropriate option to boot the installer.

## Expected Results
1. Graphical boot menu is displayed for users to select install options. Navigating the menu and selecting entries must work. If no option is selected, the installer should load after a reasonable timeout.
2. System boots into the Anaconda installer.

{% include 'testing/qa_testcase_bottom.md' %}
