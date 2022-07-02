---
title: QA:Testcase Basic Package installs
author: Lukas Magauer
revision_date: 2022-05-31
rc:
  prod: Rocky Linux
  ver:
    - 8
    - 9
  level: Final
---

!!! info "Release relevance"
    This Testcase applies the following versions of {{ rc.prod }}: {% for version in rc.ver %}{{ version }}{% if not loop.last %}, {% endif %}{% endfor %}

!!! info "Associated release criterion"
    This test case is associated with the [Release_Criteria#packages-and-module-installation](9_release_criteria.md#packages-and-module-installation) release criterion. If you are doing release validation testing, a failure of this test case may be a breach of that release criterion.

!!! error "REFERENCED RELEASE CRITERIA IS OVERLY GENERAL AND UNTESTABLE"
    The associated release criteria, [Release_Criteria#packages-and-module-installation](9_release_criteria.md#packages-and-module-installation), for this test case is overly general and **must** be modified to specific enough to be testable.

## Description

Installing several packages should work without any issues.

Please also test these usecases (it's basically the fun of learning to install software, it's even good if it's done differently each other time):

- httpd
- httpd with php and ssl
- nginx
- nginx with php and ssl
- mysql-server
- mysql-server with secure setup
- mariadb-server
- postgresql-server
- postgresql-server with secure setup
- compiling packages with:
    - cmake
    - g++
- ipa-server
- ipa-server with dns

## Setup

Obtain access to a suitable system where any of the tested packages can be installed without any issues.

## How to test

1. Install a list of packages or usecases

## Expected Results

Installs work without any issues.

{% include 'testing/qa_testcase_bottom.md' %}
