---
title: Local Module Builds
---

Within the Fedora and Red Hat ecosystem, modularity is unfortunately a piece
that is a blessing and a curse. It might be more one way or the other.

This page is primarily to talk about how to do local builds for modules,
including the final formatting of the module yaml description that will have to
be imported into the repo via `modifyrepo_c`.

Note that the below is based on how `lazybuilder` performs module builds, which
was made to be close to MBS+Koji and is not perfect. This is mostly used as a
reference.

## Contact Information
| | |
| - | - |
| **Owner** | Release Engineering Team |
| **Email Contact** | releng@rockylinux.org |
| **Email Contact** | infrastructure@rockylinux.org |
| **Mattermost Contacts** | `@label` `@mustafa` `@neil` `@tgo` |
| **Mattermost Channels** | `~Development` |

## Building Local Modules

This section explains what it's like to build local modules, what you can do,
and what you can expect.

### Module Source, "transmodrification", pulling sources

### Configuring Macros and Contexts

Traditionally within an MBS and Koji system, there are several macros that
are created and are usually unique per module stream. There are certain
components that work together to create a unique `%dist` tag based on several
factors. To summarize, here's what generally happens:

* **A module version is formed as** `M0m0YYYYMMDDhhmmss`**, which would be the major version, 0, minor version, 0, and then a timestamp.**
* **Select components are brought together and a sha1 hash is made, shortened to 8 characters for the context**

  * The runtime context is typically the "dependencies" section of the module source, calculated to sha1
  * The build context is the `xmd['mbs']['buildrequires']` data that koji generates and is output into `module.txt`, calculated to sha1
  * The runtime and build contexts are combined `BUILD:RUNTIME`, a sha1 is calculated, and then shortened to 8
  * This context is typically the one that changes less often

* **Select components are brought together and a sha1 hash is made, shortened to 8 characters for the dist tag**

  * The module name, stream, version, and context are all brought together as `name.stream.version.context`, calculated to sha1

* **The `%dist` tag is given a format of** `.module_elX.Y.Z+000+00000000`

  * X is the major version, Y is the minor version, Z is typically 0.
  * The second number is the iteration, aka the module number. If you've done 500 module builds, the next one would be 501, regardless of module.
  * The last set is a context hash generated earlier in the step above

#### Built Module Example

Let's break down an example of `389-ds` - It's a simple module. Let's start
with `modulemd.txt`. Notice how it has `xmd` data. That is an integral part
of making the context, though it's mostly information for koji and MBS and
is generated on the fly. In the context of lazybuilder, it creates fake data
to essentially fill the gap of not having MBS+Koji in the first place. The
comments will point out what's used to make the contexts.

Below is a version meant to be imported into a repo. This is after the build's
completion. You'll notice that some fields are either empty or missing from
above or even from the git repo's source that we pulled from initially.

The final "repo" of modules (per arch) is eventually made with a designation
like:

```
module-NAME-STREAM-VERSION-CONTEXT
```

This is what pungi and other utilities bring in and then combine into a single
repo, generally, taking care of the module.yaml.

#### Default Modules

Most modules will have a set default that would be expected if a dnf install
was called. For example, in EL8 if you said `dnf install postgresql-server`,
the package that gets installed is version 10. If a module doesn't have a
default set, a `dnf install` will traditionally not work. To ensure a module
package will install without having to enable them and to use the default,
you need default information. Here's the postgresql example.

```
---
document: modulemd-defaults
version: 1
data:
  module: postgresql
  stream: 10
  profiles:
    9.6: [server]
    10: [server]
    12: [server]
    13: [server]
...
```

Even if a module only has one stream, default module information is still
needed to ensure that a package can be installed without enabling the module
explicitly. Here's an example.

```
---
document: modulemd-defaults
version: 1
data:
  module: httpd
  stream: 2.4
  profiles:
    2.4: [common]
...
```

This type of information is expected by pungi as a default modules repo that
can be configured. These YAML's are not with the modules themselves. They are
brought in when the repos are being created in the first place.

In the context of lazybuilder, it checks for defaults if enabled and then the
final repo that's made of the results will immediately have the information
at the top. See the references below for the jinja template that lazybuilder
uses to generate this information.

As a final note, let's say an update comes in for postgresql and you want to
ensure that the old version of postgresql 10 and the updated version of 10
can stay together. This is when the final module data is combined together
and then it's added into the repo using `modifyrepo_c`. Note though, you do
*not* have to have the modulemd-defaults provided again. You can have it once
such as the first time you made the repo in the first place, and it will still
work.

### Building the packages

So we have an idea of how the module data itself is made and managed. All there
is left to do is to do a chain build in mock. The kicker is you need to pay
attention to the build order that is assigned to each package being built. As
mentioned before, if a build order isn't assigned, assume that it's group 0 and
will be built first. For example:

```
    components:
        rpms:
            first:
                rationale: core functions
                ref: 3.0
                buildorder: 0
            second:
                rationale: ui
                ref: latest
                buildorder: 0
            third:
                rationale: front end
                ref: latest
                buildorder: 1
```

What this shows is that the packages in build group 0 can be built simultaneously
in the context of Koji+MBS. For a local build, you'd just put them first in the
list. Basically each of these groups have to be done, completed, and available
right away for the next package or set of packages. For koji+mbs, they do this
automatically since they have a tag/repo that gets updated on each completion
and the builds are done in parallel.

For mock, a chain build will always have an internal repo that it uses, so each
completed package will have a final createrepo done on it before moving on to the
next package in the list. It's not parallel like koji, but it's still consistent.

Essentially a mock command would look like:

```
mock -r module.cfg \
  --chain \
  --localrepo /var/lib/mock/modulename \
  first.src.rpm \
  second.src.rpm \
  third.src.rpm
```

### Making the final YAML and repo

It's probably wise to have a template to make the module repo data off of. Having
a template will simplify a lot of things and will make it easier to convert the
data from git and then the final build artifacts and data that makes the module
data. The lazybuilder template is a good starting point, though it is a bit ugly.

Regardless, you should have it templated or scripted somehow. See the references
below.

## Reference

Below is a reference for what's in a module's data. Some keys are optional.
There'll also be an example from lazybuilder, which uses jinja to template out
the final data that is used in a repo.

### Module Template and Known Keys

### Module Template and Keys using jinja

```
{% if module_default_data is defined %}
---
document: modulemd-defaults
version: {{ module_default_data.version }}
data:
  module: {{ module_default_data.data.module }}
  stream: {{ module_default_data.data.stream }}
  profiles:
{% for k in module_default_data.data.profiles %}
    {{ k }}: [{{ module_default_data.data.profiles[k]|join(', ') }}]
{% endfor %}
...
{% endif %}
---
document: {{ module_data.document }}
version: {{ module_data.version }}
data:
  name: {{ source_name | default("source") }}
  stream: "{{ module_data.data.stream }}"
  version: {{ module_version | default(8040) }}
  context: {{ module_context | default('01010110') }}
  arch: {{ mock_arch | default(ansible_architecture) }}
  summary: {{ module_data.data.summary | wordwrap(width=79) | indent(width=4) }}
  description: {{ module_data.data.description | wordwrap(width=79) | indent(width=4) }}
  license:
{% for (key, value) in module_data.data.license.items() %}
    {{ key }}:
    - {{ value | join('\n    - ') }}
{% endfor %}
  xmd: {}
{% if module_data.data.dependencies is defined %}
  dependencies:
{% for l in module_data.data.dependencies %}
{% for r in l.keys() %}
{% if loop.index == 1 %}
  - {{ r }}:
{% else %}
    {{ r }}:
{% endif %}
{% for (m, n) in l[r].items() %}
      {{ m }}: [{{ n | join(', ') }}]
{% endfor %}
{% endfor %}
{% endfor %}
{% endif %}
{% if module_data.data.filter is defined %}
  filter:
{% for (key, value) in module_data.data.filter.items() %}
    {{ key }}:
    - {{ value | join('\n    - ') }}
{% endfor %}
{% endif %}
{% if module_data.data.profiles is defined %}
  profiles:
{% for (key, value) in module_data.data.profiles.items() %}
    {{ key }}:
{% for (key, value) in value.items() %}
{% if value is iterable and (value is not string and value is not mapping) %}
      {{ key | indent(width=6) }}:
      - {{ value | join('\n      - ') }}
{% else %}
      {{ key | indent(width=6) }}: {{ value }}
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}
{% if module_data.data.api is defined %}
  api:
{% for (key, value) in module_data.data.api.items() %}
    {{ key }}:
    - {{ value | join('\n    - ') }}
{% endfor %}
{% endif %}
{% if module_data.data.buildopts is defined %}
  buildopts:
{% for (key, value) in module_data.data.buildopts.items() %}
    {{ key }}:
{% for (key, value) in value.items() %}
      {{ key }}: |
        {{ value | indent(width=8) }}
{% endfor %}
{% endfor %}
{% endif %}
{% if module_data.data.references is defined %}
  references:
{% for (key, value) in module_data.data.references.items() %}
    {{ key }}: {{ value }}
{% endfor %}
{% endif %}
{% if module_data.data.components is defined %}
  components:
{% for (key, value) in module_data.data.components.items() %}
    {{ key }}:
{% for (key, value) in value.items() %}
      {{ key }}:
{% for (key, value) in value.items() %}
{% if value is iterable and (value is not string and value is not mapping) %}
        {{ key | indent(width=8) }}: [{{ value | join(', ') }}]
{% else %}
        {{ key | indent(width=8) }}: {{ value }}
{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endif %}
{% if artifacts is defined %}
  artifacts:
{% for (key, value) in artifacts.items() %}
    {{ key }}:
    - {{ value | join('\n    - ') }}
{% endfor %}
{% endif %}
...
```
