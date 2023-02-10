---
title: Bug Tracker Guidelines
---

These set of guidelines are what to expect using the Bug Tracker system. While
we do not require contributors or bug reports to sign this as an agreement in
account services nothing is stopping you from doing so to show confirmation that
you have.

## Preface

Bugzilla is a core part of the Rocky Linux distribution and Rocky Enterprise
Software Foundation as a whole. Whether you're a bug reporter, a contributor,
or perhaps on the Release Engineering team, the Bug Tracker is a utility for
everyone to be able to read and engage with others to find solutions to issues
affecting the software that is shipped and available in Rocky Linux.

## General Guidelines

As a reporter, there are guidelines in which you (the user) and others must
follow when reporting issues or bugs on the Bug Tracker. Below are some things
to be aware of:

* Moderation is enforced - As is done in the Rocky Linux MatterMost chat, it is
  important to mind your language and word choice. Speak to others as you would
  want them to speak to you.

* The Bug Tracker is not a place for support - The Bug Tracker is meant for
  issues, bugs, and problems with the packages and software that is provided in
  Rocky Linux. Tickets opened that are asking for support on the operating
  system or software will be closed. You are encouraged to go to our subreddit,
  Libera IRC channel (#rockylinux), mattermost, or our forums.

## Expectations

As a reporter, there are expectations in which you (the user) and others should
adhere to in order to keep the queues clean and consistent, as well as the
the reports readable so that the responsible party can address the issue in a
proper manner.

* Ensure your report goes to the correct project - There is a list of projects
  that accept bug reports or issues. The drop down is on the top right. Choose
  the one most appropriate to your issue.

* Ensure that you provide relevant information - When submitting a report that
  may be a bug or issue, ensure that you provide relevant logs and output that
  can help the responsible parties to address your issue. This includes:

    * Logs from /var/log
    * journalctl logs
    * Console output in your shell/session
    * An archive created by sosreport
    * Patch files or workarounds

* Do not submit support questions - The Bug Tracker is not a support desk; as
  such the tickets will be closed if they are asking for assistance or support.
  You are recommended to go to our reddit, Freenode channel (#rockylinux), or
  our forum.

## Types of Tickets

While reporting bugs and issues are common with bug trackers, the tracker also
accepts other reports. Such as:

* Account Removal - If you are requesting your account be removed or disabled,
  this can be done in the Account Services section of the bug tracker.

* GitLab Request - There may be patch repos missing or something else may be
  requested that involves a group or even a SIG.

* Rocky Services - This could be the bug tracker itself, the wiki, or other
  pieces of infrastructure.
