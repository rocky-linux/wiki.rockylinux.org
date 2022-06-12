---
title: QA:Testcase Multimonitor Setup
author: Lukas Magauer
revision_date: 2022-05-31
rc:
  prod: Rocky Linux
  ver: 8
  level: Final
---

!!! info "Associated release criterion"
    This test case is associated with the [Release_Criteria#dual-monitor-setup-desktop-only](9_release_criteria.md#dual-monitor-setup-desktop-only) release criterion. If you are doing release validation testing, a failure of this test case may be a breach of that release criterion.

## Description

This test covers the check if GNOME behaves as it should in multi-monitor setups.

## Setup

You will need either a machine which can be reinstalled with multiple screens, or a virtualization software which is capable of providing multiple screens (like VMware Workstation, but there is also a hack for VMware ESXi)

## How to test

1. Run installer with multiple screens connected and install with either the Workstation or Graphical Server group
2. Login to the machine after the finished install

## Expected Results

There shouldn't be any graphical glitches, or scaling issues through the install and the usage.

{% include 'testing/qa_testcase_bottom.md' %}
