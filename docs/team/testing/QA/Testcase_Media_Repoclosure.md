---
title: QA:Testcase Media Repoclosure
author: Trevor Cooper
revision_date: 2022-04-24
rc:
  prod: Rocky Linux
  ver: 8
  level: Final
---

!!! info "Associated release criterion"
    This test case is associated with the [Release_Criteria#no-broken-packages](../release_criteria.md#no-broken-packages) release criterion. If you are doing release validation testing, a failure of this test case may be a breach of that release criterion.

## Description
This testcase will verify that the offline repository included on release blocking images will not contain broken dependencies.

## Setup
1. Obtain access to an environment with the `dnf repoclosure` command.
2. Download the ISO to be tested to that machine.

## How to test
1. Mount the ISO to be tested locally.
2. Determine the path to the `repodata` directory(ies) on the ISO.
3. Run the `dnf repoclosure` command on the mounted ISO.
4. Unmount the ISO.

## Expected Results
1. The `dnf repoclosure` command does not generate any errors.

{% include 'testing/qa_testcase_bottom.md' %}
