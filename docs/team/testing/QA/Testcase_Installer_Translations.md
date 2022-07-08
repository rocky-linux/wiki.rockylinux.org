---
title: QA:Testcase Installer Translations
author: Al Bowles
revision_date: 2022-07-08
rc:
  prod: Rocky Linux
  ver:
  - 8
  - 9
  level: Final
---

!!! info "Associated release criterion"
    This test case is associated with the [Release_Criteria#Installer Translations](9_release_criteria.md#installer-translations) release criterion. If you are doing release validation testing, a failure of this test case may be a breach of that release criterion.

## Description
The installer must correctly display all complete translations that are available for use.

## Setup
{% include 'testing/qa_setup_boot_to_media.md' %}

## How to test
1. From the Language Selection spoke, select a language.

## Expected Results
1. All spokes should display at least some of the content in the selected language.
2. It is expected to still see some content displayed in Latin characters even if a language that does not use Latin characters is selected.

## Testing in openQA
The following openQA test suites satisfy this release criteria:

- `install_asian_language`
- `install_arabic_language`
- `install_cyrillic_language`
- `install_european_language`

{% include 'testing/qa_testcase_bottom.md' %}
