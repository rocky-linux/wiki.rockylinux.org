---
title: QA:Testcase Storage Volume Resize
author: Al Bowles
revision_date: 2022-05-18
rc:
  prod: Rocky Linux
  ver: 8
  level: Final
---

!!! info "Associated release criterion"
    This test case is associated with the [Release_Criteria#Storage Volume Resize](../release_criteria.md#storage-volume-resize) release criterion. If you are doing release validation testing, a failure of this test case may be a breach of that release criterion.

## Description
This test case verifies that the installer will successfully resize or delete and overwrite existing partitions on storage volumes.

{% include 'testing/qa_data_loss_warning.md' %}

## Setup
{% include 'testing/qa_setup_boot_to_media.md' %}

## How to test
1. Do this first...
2. Then do this...

## Expected Results
1. This is what you should see/verify.
2. You should also see/verify this.

## Testing in openQA
The following openQA test suites satisfy this release criteria:
- `install_delete_partial`

{% include 'testing/qa_testcase_bottom.md' %}
