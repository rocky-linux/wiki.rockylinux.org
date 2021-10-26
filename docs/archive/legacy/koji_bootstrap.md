---
title: Koji Bootstrap (setup)
---
Usually builds use the internal Koji repository to satisfy dependencies. To start with, there are no packages so we need to bootstrap (as some packages needs themselves to build themselves).

#### Tags and build tags
Create new tags that will be the new distribution. Let's call them rocky.
```
koji add-tag dist-rocky8
koji add-tag --parent dist-rocky8 --arches=i686,x86_64,ppc64le,aarch64 -x mock.yum.module_hotfixes=1 dist-rocky8-build
koji add-target dist-rocky8 dist-rocky8-build dist-rocky8
```

#### External repositories
Repositories from Sherif:
```
koji add-external-repo -m bare -t dist-rocky8-build centos-8-baseos-external http://mirror.centos.org/centos-8/8.3.2011/BaseOS/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-appstream-external http://mirror.centos.org/centos-8/8.3.2011/AppStream/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-devel-external http://mirror.centos.org/centos-8/8.3.2011/Devel/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-ha-external http://mirror.centos.org/centos-8/8.3.2011/HighAvailability/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-pt-external http://mirror.centos.org/centos-8/8.3.2011/PowerTools/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-cp-external http://mirror.centos.org/centos-8/8.3.2011/centosplus/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-cr-external http://mirror.centos.org/centos-8/8.3.2011/cr/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-extras-external http://mirror.centos.org/centos-8/8.3.2011/extras/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-fasttrack-external http://mirror.centos.org/centos-8/8.3.2011/fasttrack/\$arch/os/
koji add-external-repo -m bare -t dist-rocky8-build centos-8-debuginfo-external http://debuginfo.centos.org/8/\$arch/
```
