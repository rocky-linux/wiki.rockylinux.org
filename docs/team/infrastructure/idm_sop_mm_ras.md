---
title: 'SOP: Mattermost and RAS Group Sync'
---

This SOP covers how the Rocky Enterprise Software Foundation (RESF) and Rocky Linux Infrastructure handles group syncing between the Rocky Account Services and Mattermost Channels. It contains information about how System Administrators will create groups, the templates, and how to setup syncing within Mattermost.

## Contact Information
| | |
| - | - |
| **Owner** | Infrastructure Team & Identity Management Team |
| **Email Contact** | infrastructure@rockylinux.org |
| **Email Contact** | identitymanagement@rockylinux.org |
| **Mattermost Contacts** | `@label` |
| **Mattermost Contacts** | `@neil` |
| **Mattermost Channels** | `~Infrastructure` |

## Creating the necessary group

This section covers how a system administrator will create a group Rocky Account Services using ansible. The playbook utilized will be `adhoc-ipagroup.yml`.

0. First, determine where and how the group will be utilized. The starting template will be `mm_X_name`. `mm` is for mattermost, `X` will be for the designated part of Mattermost (eg resf, rl, and so on), and `name` will be the name of the group in question.
1. On the ansible host, run the necessary ansible playbook: `ansible-playbook -i inventories/production/hosts.ini ansible-ipa-management/adhoc-ipagroup.yml --extra-vars='ipa_group=<GROUP> ipa_description="<DESC>" ipa_nonposix=false ipa_fas=true'`
  a. Ensure that the description is set in a way that it explains what it is for
  b. It is unlikely the group will need to have a GID assigned. Assigning the group as nonposix should be sufficient.
  c. Setting the group with `ipa_fas=true` ensures that the group will appear in Rocky Account Services and can be managed there.
2. Set the member managers for the groups so that they can be managed by non-admins. A playbook may not exist for this and may need to be performed manually on an IPA system.
