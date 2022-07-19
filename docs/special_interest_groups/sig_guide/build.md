---
title: Building Packages
---

This section goes over building your packages/content in the Community Build System.

## CBS (Community Build System)

The Community Build System is an extension of Peridot, the build system that is used to build Rocky Linux. Users have an opportunity to use this build system for themselves (like OBS or Copr) or as part of a Special Interest Group.

### Building in the CBS

TBD

### dist tags

It is expected that your SIG will have a "shorthand" name assigned to you (either by core or yourself during the proposal). Because of this, it is a requirement that the group project's packages all have it set for the entire scope of the group. For example, if the SIG's name is "Messaging and Communication", the shorthand would be "mc", and the package would be named:

`erlang-22.0.7-1.el9.mc.x86_64.rpm`

Some single word SIGs can be abbreviated too. Like `hyperscale` can become `hs`. There may be cases where this isn't possible and exceptions can be granted. `cloud` is an example of this.

More examples of dist tags are below:

| SIG        | Dist Tag    |
|------------|-------------|
| altarch    | elX.altarch |
| cloud      | elX.cloud   |
| core       | elX.core    |
| hyperscale | elX.hs      |

{% include "releng/resources_bottom.md" %}
