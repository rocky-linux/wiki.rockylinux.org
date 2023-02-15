---
title: 'AWX / Ansible SCM Guidelines'
---

This document covers the guidelines as set out by the Infrastructure/Core group for designing modular repositories that may be used in the Rocky AWX instance or local execution based on team needs. This is meant to supersede the guidelines in the ansible-awx-template repository.

This does not cover detailed examples, but is meant to get teams and their contributors started in designing or improving upon all ansible related activities for their group.

!!! note
    This guide may be moved to the Core rocky.page wiki in the future.

## Contact Information
|   |   |
| - | - |
| **Owner**               | Infrastructure Team           |
| **Email Contact**       | infrastructure@rockylinux.org |
| **Mattermost Contacts** | `@label`                      |
| **Mattermost Contacts** | `@neil`                       |
| **Mattermost Contacts** | `@tgo`                        |
| **Mattermost Channels** | `~Infrastructure`             |

## Guidelines

This section covers the basics for your AWX project. It is absolutely important that you start with these as an absolute bare minimum. While you will be forking/cloning off of `infrastructure/ansible-awx-template` and using that as the starting point, the next few sections will explain the basic structure and basic design principals.

### Root Structure

The general structure will always start from this:

```
.
├── somePlaybook.yml
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── tasks
│   └── main.yml
├── templates
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```

This structure follows the basic expected structure for ansible (this means ignoring AWX/Tower). If you are familiar with ansible already, you may already know how these files and directories work at an operational level. The gist of it is:

* All playbooks should be in the root and import tasks from `./tasks` if needed
* Vars should be clearly defined where needed in vars, defaults, and/or playbooks
* Files and templates should be created with a purpose
* Handlers should be clearly defined and used
* There should be wiggle room to add callback_plugins, filter_plugins, libraries

With these basic ideas in mind, we can now move deeper.

### Designing Playbooks

Generally, your playbooks should be doing the following:

1. Checking if ansible can be ran on a specific host
2. Asserting if variables are filled and are correctly formed, if applicable
3. Importing tasks from the `./tasks` directory
4. Importing roles, if necessary
5. Post tasks, if necessary

**At no point should you be using** `./tasks/main.yml` **under any circumstance.**

#### Pre-flight and Post-flight Tasks

In majority of cases, you will need to have pre-flight and post-flight tasks. These aren't needed in *all* cases, but they should be used as a starting point.

```
  pre_tasks:
    - name: Check if ansible cannot be run here
      ansible.builtin.stat:
        path: /etc/no-ansible
      register: no_ansible

    - name: Verify if we can run ansible
      ansible.builtin.assert:
        that:
          - "not no_ansible.stat.exists"
        success_msg: "We are able to run on this node"
        fail_msg: "/etc/no-ansible exists - skipping run on this node"

    # Assertions and other checks here

  # Import roles/tasks here

  post_tasks:
    - name: Touching run file that ansible has ran here
      ansible.builtin.file:
        path: /var/log/ansible.run
        state: touch
        mode: '0644'
        owner: root
        group: root
```

#### Tasks General Information

Ensure that your tasks are using FQCN. This means, even for the simple modules such as `file`, you should be using `ansible.builtin.file` to be compliant with ansible-lint 6+ and ansible 2.12+.

### Comments

Each playbook should have comments or a name descriptor that explains what the playbook does or how it is used. If not available, `README-...` can be used in place, especially in the case of adhoc playbooks that take or require input. Documentation for each playbook/role does not have to be on a wiki. Comments or README's should be perfectly sufficient.

#### Tags

Ensure that you are using relevant tags where necessary for your tasks. This will allow you or the deployers to have deeper control of what is ran or called in AWX.

#### Playbook Naming System

When making playbooks, there is a set of predefined prefixes you will need to set. It is highly discouraged to step outside of these prefixes.

```
init-* -> Starting playbooks that run solo or import other playbooks that start
          with import-. Can also be used to run updates or repetive tasks that
          adhoc may not suffice and running a role playbook is too much overhead.

adhoc  -> These playbooks are one-off playbooks that can be used on the CLI or
          in AWX. These are typically for basic tasks.

import -> Playbooks that should be imported from the top level playbooks or
          used to "import" or "add" data somewhere (e.g., a database or LDAP)

role-* -> These playbooks call roles for potential infrastructure tasks or even
          roles in general.
```

!!! note "Using the role prefix without an ansible role"
    While it is feasible to use `role-` as a way to say "this system will do X" without calling out to an ansible role, you are encouraged to use `init-` instead in these cases. This is **not** a strict requirement. Go with what feels right for your project.

#### Defining Hosts

There will likely be multiple dynamic inventory sources used for hosts managed by AWX, and as a result, there will be a lot of groups defined with one or more hosts at a time. As this is the case, here are some things to keep in mind:

* Use group names where necessary
* Use localhost if you aren't actually doing anything to a system (e.g., you're calling an API) *and* you don't have to connect to a system to use said API
* When filling in the `hosts` directive, follow these general guidelines:

    * If it applies to all hosts in an inventory, use `all`
    * If you want the host or or a group of hosts to be selectable (via dropdown or manual input), create in your playbook and set a variable such as `{{ host }}`
    * If the above two are not applicable and you must set a hostname, you may do so. Note that this will require you to be more vigilant in keeping your repository up to date.

##### Local Inventory Files

Generally local inventory files are not recommended. If you are running anything locally outside of AWX, an inventory is allowed but should not be committed to the repository. Using `.gitignore` to prevent this is recommended.

Note that using a name that isn't `inventory` is fine as well, as it will not be picked up by default.

##### Local ansible.cfg files

General ansible.cfg files are not recommended as they would be picked up during normal operation. These should be provided only for special cases. Optionally, you may provide it under another name that a user can reference for local execution outside of AWX.

#### Collections and Roles

Collections and roles should be defined in a `requirements.yml` in their respective directories. AWX will pick them up. Optionally, you can provide a playbook or script to install roles and collections locally. Example commands that could be in a script or playbook:

```
ansible-galaxy collection install -r collections/requirements.yml
ansible-galaxy role install -r roles/requirements.yml
```

Tools like `ansible-navigator` and `ansible-builder` can also help in this area as well.

#### Pre-commits / linting

When committing, pre-commit must run to verify your changes. They must be passing to be pushed up. This is an absolute requirement, even for roles. There are very rare exceptions to this rule and they may be granted depending on what it is.

When the linter passes, a push can be performed. After that, if a PR is necessary, open one. Otherwise, it should be free to use locally or in AWX.

#### Tests

A template generally comes with a `tests` directory. While not strictly required, it is recommended to create a suite of tests to ensure most, if not all of your playbooks are in working order. This is similar to providing tests to ansible collections, in that they should test at least basic functionality.

Complex situations can be tested for as well and is encouraged.

