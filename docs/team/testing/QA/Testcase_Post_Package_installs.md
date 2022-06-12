---
title: QA:Testcase Basic Package installs
author: Lukas Magauer
revision_date: 2022-05-31
rc:
  prod: Rocky Linux
  ver: 8
  level: Final
---

!!! error "REFERENCED RELEASE CRITERIA IS OVERLY GENERAL AND UNTESTABLE"
    The associated release criteria, [Release_Criteria#packages-and-module-installation](9_release_criteria.md#packages-and-module-installation), for this test case is overly general and **must** be modified to specific enough to be testable.

!!! info "Associated release criterion"
    This test case is associated with the [Release_Criteria#packages-and-module-installation](9_release_criteria.md#packages-and-module-installation) release criterion. If you are doing release validation testing, a failure of this test case may be a breach of that release criterion.

## Description

Installing several packages should work without any issues.

## Setup

Obtain access to a suitable system where any of the tested packages can be installed without any issues.

## How to test

1. Install a list of packages or usecases

## Expected Results

Installs work without any issues.

{% include 'testing/qa_testcase_bottom.md' %}
