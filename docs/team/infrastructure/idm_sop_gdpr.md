---
title: 'SOP: Personal Data Request - Deletion'
---

This SOP covers how the Rocky Enterprise Software Foundation (RESF) and Rocky Linux Infrastructure Team handles GDRP (General Data Protection Regulation) data delete requests. It contains information about how System Administrators will use Ansible and other tooling to respond to delete requests.

## Contact Information
| | |
| - | - |
| **Owner** | Infrastructure Team & Identity Management Team |
| **Email Contact** | infrastructure@rockylinux.org |
| **Email Contact** | identitymanagement@rockylinux.org |
| **Mattermost Contacts** | `@label` |
| **Mattermost Channels** | `~Infrastructure` |

## Responding to a Deletion Request

This section covers how a system administrator will use our `adhoc-ipauser-disable-pdr.yml` playbook to respond to a delete request. 

If a request has been received via email, perform the following steps:

0. If request was received by email: Open a ticket at the [bugzilla](https://bugs.rockylinux.org) under the `Account Services` product (Click "New" and select Account Services)
  a. Set component to `Personal Data Request`
  b. Assign to yourself if possible
  c. Summary should be set: `PDR - Email Delete Request for <USER/EMAIL>`
  d. Description should be set to the template `PDR - Delete Form` or copied directly from the email if the template was followed.
  e. Use the ID for the ansible playbook
1. On the ansible host, run the necessary ansible playbook: `ansible-playbook -i inventories/production/hosts.ini playbooks/adhoc-ipauser-disable-pdr.yml --extra-vars='ipa_user=<USER> ticket_id=BZ<TICKET>'`
2. Leave a comment on the issue that the disable request was performed.
3. Email the affected user:

```
Hello. We have reviewed your account request and have performed the requested
changes. The ticket <ID> has been closed and set to private.

Please note that some public content such as mailing lists cannot be deleted
since some information is meant to serve the RESF legitimate business
interests, the public interest, and the interest of the open source community.

Thank you, please let us know if you have any further questions.
```
4. Set ticket to `RESOLVED`
