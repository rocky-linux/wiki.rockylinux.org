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

0. If request was received by email: Open a ticket at the [bug tracker](https://bugs.rockylinux.org) under the `Account Services` product (Click the drop down in the top right corner, click "Account Services", select "Report Issue")

    * Set category to `Account Requests - Personal Data Request`
    * Assign to yourself if possible
    * Summary should be set: `PDR - Email Delete Request for <USER/EMAIL>`
    * Description should be set to the snippet `PDR Request - Remove Personal Information` or copied directly from the email if the template was followed.
    * Use the ID for the ansible playbook

1. On the ansible host, run the necessary ansible playbook: `ansible-playbook -i inventories/production/hosts.ini playbooks/adhoc-ipauser-disable-pdr.yml --extra-vars='ipa_user=<USER> ticket_id=BT<TICKET>'`
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
