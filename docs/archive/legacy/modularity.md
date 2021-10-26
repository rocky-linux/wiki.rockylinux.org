---
title: Modularity
---
There are some packages that utilise a functionality called streams. Modularity makes it possible to have multiple versions of the same package in the same repository and enables version switching. To be able to build module packages, we are using something called `Module Build Service`, `MBS` for short. It is also called `fm-orchestrator`.

Packages that have modular entries should not be built directly from their `dist/` repository as that will not tag that package correctly as a stream.

The correct `{name}.yaml` file is generated during import with `srpmproc` and is derived from `SOURCES/modulemd.src.txt`.

### Koji setup
MBS should be able to use content generators so Koji can manage artifacts. To enable content generation run the following queries against the database:
```
insert into content_generator (name) values ('module-build-service');
insert into btype (name) values ('module');
```

Grant the `mbs` user on koji `cg-access` with:
```
koji grant-cg-access mbs module-build-service
```

Also create a tag named `modular-updates-candidate` with:
```
koji add-tag modular-updates-candidate
```

Modular packages should be added to this tag.

### MBS
Latest MBS version is required. Version 2.32 lacks the `mock.yum.module_hotfixes=1` flag on the tags and DNF fail-safe mechanisms break the build.


*More info on Modularity here and how we utilise MBS*
