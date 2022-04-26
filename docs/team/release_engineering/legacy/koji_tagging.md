---
title: Koji Tagging Strategy
---

This document covers how the Rocky Linux Release Engineering Team handles the tagging for builds in Koji and how it affects the overall build process.

## Contact Information
| | |
| - | - |
| **Owner** | Release Engineering Team |
| **Email Contact** | releng@rockylinux.org |
| **Mattermost Contacts** | `@label` `@mustafa` `@neil` `@tgo` |
| **Mattermost Channels** | `~Development` |

## What is Koji?

Koji is the build system used for Rocky Linux, as well as CentOS, Fedora, and likely others. Red Hat is likely to use a variant of Koji called "brew" with similar functionality and usage. Koji uses mock, a common RPM building utility, to build RPMs in a chroot environment.

## Architecture of Koji

### Components

Koji comprises of multiple components:

* `koji-hub`, which is the center of all Koji operations. It runs XML-RPC and relies on other components to call it for actions. This piece will also talk to the database and is one component that has write access to the filesystem.
* `kojid`, which is the daemon that runs on the builder nodes. It's responsibility is to talk to the hub for actions in which it can or has to perform, for example, building an RPM or install images. But that is not all that it can do.
* `koji-web` is a set of scripts that provides the web interface that anyone can see at our [koji](https://kojidev.rockylinux.org). 
* `koji` is the command line utility that is commonly used - It is a wrapper of the various API commands that can be called. In our environment, it requires a login via kerberos.
* `kojira` is a component that ensures repodata is updated among the build tags.

### Tags

Tags are the most important part of the koji ecosystem. With tags, you can have specific repository build roots for the entire distribution or just a simple subset of builds that should not polute the main build tags (for example, for SIGs where a package or two might be newer (or even older) than what's in BaseOS/AppStream.

Using tags, you can setup what is called "inheritance". So for example. You can have a tag named `dist-rocky8-build` but it happens to inherit `dist-rocky8-updates-build`, which will likely have a newer set of packages than the former. Inheritance, in a way, can be considered setting "dnf priorities" if you've done that before. Another way to look at it is "ordering" and "what comes first".

Targets call tags to send packages to build in, generally. 

## Tag Strategy

The question that we get is "what's the difference between a build and an updates-build tag" - It's all about the inheritance. For example, let's take a look at `dist-rocky8-build`

```
  dist-rocky8-build
    el8
    dist-rocky8
    build-modules
       . . .
```

In this tag, you can see that this build tag inherits el8 packages first, and then the packages in dist-rocky8, and then build-modules. This is where "base" packages start out at, generally and a lot of them won't be updated or even change with the lifecycle of the version.

```
dist-rocky8-updates-build
    el8
    dist-rocky8-updates
        dist-rocky8
    dist-rocky8-build
        build-modules 
        
```

This one is a bit different. Notice that it inherits el8 first, and then dist-rocky8-updates, which inherits dist-rocky8. And then it also pulls in dist-rocky8-build, the previous tag we were talking about. This tag is where updates for a minor release are sent to.

```
dist-rocky8_4-updates-build
    el8_4
    dist-rocky8-updates
        dist-rocky8
    dist-rocky8-build
        el8
        build-modules 
```

Here's a more interesting one. Notice something? It's pretty similar to the last one, but see how it's named el8_4 instead? This is where updates during 8.4 are basically sent to and that's how they get tagged as `.el8_4` on the RPM's. The `el8_4` tag contains a build macros package that instructs the `%dist` tag to be set that way. When 8.5 comes out, we'll basically have the same setup.

At the end of the day, builds that happen in these updates-build tags get dropped in dist-rocky8-updates.

### What about modules?

Modules are a bit tricky. We generally don't touch how MBS does its tags or what's going on there. When builds are being done with the modules, they do end up using the el8 packages in some manner or form. The modules are separated entirely from the main tags though, so they don't polute the main tags. You don't want a situation where say, you build the latest ruby, but something builds off the default version of ruby provided in `el8` and now you're in trouble and get dnf filtering issues.

### How do we determine what is part of a compose?

There are special tags that have a `-compose` suffix. These tags are used as a way to pull down packages for repository building during the pungi process. 
