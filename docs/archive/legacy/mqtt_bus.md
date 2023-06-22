---
title: CentOS MQTT message bus
---

!!! danger
  As of 2023-06-21, [updates are no longer published to git.centos.org](https://www.redhat.com/en/blog/furthering-evolution-centos-stream). This page will eventually be replaced with documentation on the Fedora MessageBus which contains the events for publishing into gitlab.com/redhat/centos-stream, and how we have implemented inside our build system.

  As such, the information below should be considered historical and may move to the Archive at some time in the future. Proceed with caution.


CentOS provides a message bus which can be used for subscribing to certain messages on their git repository.

More information, and setup on subscribing to their message bus can be found at [https://wiki.centos.org/Sources?highlight=%28mqtt%29#Message_Broker_.28MQTT.29](https://wiki.centos.org/Sources?highlight=%28mqtt%29#Message_Broker_.28MQTT.29).


## Example message

```
git.centos.org/git.receive
{
  "forced": false,
  "agent": "pgreco",
  "repo": {
    "custom_keys": [],
    "name": "kernel",
    "parent": null,
    "date_modified": "1553617543",
    "access_users": {
      "owner": [
        "centosrcm"
      ],
      "admin": [],
      "ticket": [],
      "commit": []
    },
    "namespace": "rpms",
    "priorities": {},
    "close_status": [],
    "access_groups": {
      "admin": [],
      "commit": [],
      "ticket": []
    },
    "milestones": {},
    "user": {
      "fullname": "CentOS Sources",
      "name": "centosrcm"
    },
    "date_created": "1553617543",
    "fullname": "rpms/kernel",
    "url_path": "rpms/kernel",
    "id": 918,
    "tags": [],
    "description": " The Linux kernel "
  },
  "old_commit": "dbbb1cc79ab5878344c3e3df4b53b7ac7acdddfc",
  "branch": "c7-sig-altarch-lts-5-4",
  "authors": [
    "Pablo Greco"
  ],
  "total_commits": 1,
  "start_commit": "b7d48e1265407b755f7827d0245547847cdba375",
  "end_commit": "b7d48e1265407b755f7827d0245547847cdba375"
}

```
