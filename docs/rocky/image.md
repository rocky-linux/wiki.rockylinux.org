---
title: Rocky Linux ISOs and Images
---

For a given Rocky Linux release, ISOs and images are generated and provided to the community, providing different means of installing Rocky Linux, whether that be a full DVD iso image, a boot iso, live desktop images, or even cloud images.

It is important to note that the images provided and what they provide may differ between major releases (such as provided packages, installable/installed groups, and so on).

## About ISO Images

| Version        | boot | minimal | dvd | Architectures                   |
|----------------|------|---------|-----|---------------------------------|
| Rocky Linux 8  | Yes  | Yes     | Yes | x86_64, aarch64                 |
| Rocky Linux 9  | Yes  | Yes     | Yes | x86_64, aarch64, ppc64le, s390x |

Every Rocky Linux release gets a set of ISO's. These ISO's are made by the tooling used to make and finalize the distribution. For a given Rocky Linux release, they will live in an `isos` directory at the root of a Rocky Linux release. There are three formats for the ISO's:

### Notes about: Multiple ISO images, what is what?

There are multiple templated formats for each ISO you may see.

| Format                   | Type     | Context                   |
|--------------------------|----------|---------------------------|
| Rocky-X.Y-ARCH-TYPE      | ISO File | Day of release ISO        |
| Rocky-X.Y-DATE-ARCH-TYPE | ISO File | Rebuilt ISO               |
| Rocky-ARCH-TYPE          | Symlink  | Symlink to the latest ISO |

* X is the major version
* Y is the minor version
* ARCH is the architecture
* DATE will be the date the ISO was built (if applicable)
* TYPE will be the type of ISO (boot, dvd, minimal)

The first format is the most common and is the day-of-release ISO.

The second format is in the case of rebuilt ISO's, typically in the case of addressing a bug or providing updated images (in the case of a newer kernel, a new secure boot shim, and so on).

The third format is a symlink to the "latest" ISO. Currently, this is not advertised on the main site but may be in the future. This unversioned image is for these cases:

* A pre-determined download location for users/mirrors/service providers who want an always available and deterministic download location, which can be easier to script
* osinfo database / libvirt use where if a user selects Rocky Linux X, it should be aware of and be able to download from that location. This should be fully supported in Rocky Linux 8.7 and 9.1, and future Fedora versions.

## About Cloud Images

Every Rocky Linux release gets a set of cloud images that can be consumed into their cloud infrastructure as they see fit. They will live in an `images` directory at the root of a Rocky Linux release.

| Version        | Generic Cloud                   | EC2                   |
|----------------|---------------------------------|-----------------------|
| Rocky Linux 8  | Yes (x86_64, aarch64)           | Yes (x86_64, aarch64) |
| Rocky Linux 9  | Yes (x86_64, aarch64, others\*) | Yes (x86_64, aarch64) |

There are two formats for the images:

| Format                             | Type       | Context                     |
|------------------------------------|------------|-----------------------------|
| Rocky-X-CLOUD-X.Y-DATE-ARCH.FORMAT | Image File | Any given cloud image       |
| Rocky-X-CLOUD.latest.ARCH.FORMAT   | Symlink    | Symlink to the latest image |

* X is the major version
* Y is the minor version
* ARCH is the architecture
* DATE will be the date of when the image was produced
* CLOUD will the type of cloud image (eg GenericCloud)
* FORMAT will be `raw` or `qcow2`

The first format will always be a constant. Cloud images will appear in this format in majority of cases and there may be more than one at any given time. Updates can occur for newer kernels or to address issues in previous versions.

The second format is symlinked to the latest available image. This allows users/mirrors/service providers to have an always available and deterministic download location that can be scripted if they wish to always pull the latest available.

### Notes about: Other Architectures

There are plans to provide cloud images for our other primary architectures (ppc64le, s390x). At this time they are not available, but may soon be.

## About Live Images

Every Rocky Linux release provides a set of live images that a user can download, boot, use, and optionally install to their systems. The live images are desktop oriented images that are primarily for desktop use cases and try to closely match similarly to what Fedora provides for their releases.

| Version        | GNOME / Workstation | KDE     | XFCE | Architectures |
|----------------|---------------------|---------|------|---------------|
| Rocky Linux 8  | Yes                 | Yes     | Yes  | x86_64        |
| Rocky Linux 9  | Yes                 | Yes     | Yes  | x86_64        |

### Notes about: Missing architectures

There are plans to potentially provide aarch64 live images, as ARM workstations are starting to become more and more prevalent. This is on top of raspberry pi support that we already provide (but are provided and supported by other means).

### Notes about: Kickstarts

The kickstarts that help generate these live images can be found at [https://git.resf.org/sig_core/kickstarts](https://git.resf.org/sig_core/kickstarts) and the mirror at [https://github.com/rocky-linux/kickstarts](https://github.com/rocky-linux/kickstarts).

## About Pi Images (maintained by SIG/AltArch)

The raspberry pi images are exactly what's labeled on the tin, images for the means of installing to an sd card to run Rocky Linux on a raspberry pi. These images are supported by SIG/AltArch community members.

Traditionally, the repositories and images would be in the same directory as a major release (eg `/pub/rocky/9/rockyrpi`). They are now provided in [SIG](http://dl.rockylinux.org/pub/sig/) directories for Rocky Linux 9 and will likely be backported in the future.

The git repository that contains the kickstart and other data related to the creation of these images are located at [https://git.resf.org/sig_altarch/RockyRpi](https://git.resf.org/sig_altarch/RockyRpi).
