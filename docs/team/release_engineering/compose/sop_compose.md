---
title: 'SOP: Compose and Repo Sync for Rocky Linux and Peridot'
---

This SOP covers how the Rocky Linux Release Engineering Team handles composes and repository syncs for the distribution. It contains information of the scripts that are utilized and in what order, depending on the use case.

## Contact Information
| | |
| - | - |
| **Owner** | Release Engineering Team |
| **Email Contact** | releng@rockylinux.org |
| **Email Contact** | infrastructure@rockylinux.org |
| **Mattermost Contacts** | `@label` `@mustafa` `@neil` `@tgo` |
| **Mattermost Channels** | `~Development` |

## Related Git Repositories

There are several git repositories used in the overall composition of a repository or a set of repositories.

[Pungi](https://git.rockylinux.org/rocky/pungi-rocky) - This repository contains all the necessary pungi configuration files that peridot translates into its own configuration. Pungi is no longer used for Rocky Linux.

[Comps](https://git.rockylinux.org/rocky/comps) - This repository contains all the necessary comps (which are groups and other data) for a given major version. Peridot (and pungi) use this information to properly build repositories.

[Toolkit](https://github.com/rocky-linux/sig-core-toolkit) - This repository contains various scripts and utilities used by Release Engineering, such as syncing composes, functionality testing, and mirror maintenance.

## Composing Repositories

### Mount Structure

There is a designated system that takes care of composing repositories. These systems contain the necessary EFS/NFS mounts for the staging and production repositories as well as composes.

* `/mnt/compose` -> Compose data
* `/mnt/repos-staging` -> Staging
* `/mnt/repos-production` -> Production

### Empanadas

Each repository or set of repositories are controlled by various comps and pungi configurations that are translated into peridot. Empanadas is used to run a reposync from peridot's yumrepofs repositories, generate ISO's, and create a pungi compose look-a-like. Because of this, the comps and pungi-rocky configuration is not referenced with empanadas.

### Running a Compose

First, the toolkit must be cloned. In the `iso/empanadas` directory, run `poetry install`. You'll then have access to the various commands needed:

* `sync_from_peridot`
* `build-iso`
* `build-iso-extra`
* `pull-unpack-tree`
* `pull-cloud-image`
* `finalize_compose`

To perform a full compose, this order is expected (replacing X with major version or config profile)

```
# This creates a brand new directory under /mnt/compose/X and symlinks it to latest-Rocky-X
poertry run sync_from_peridot --release X --hashed --repoclosure --full-run

# On each architecture, this must be ran to generate the lorax images
# !! Use --rc if the image is a release candidate or a beta image
# Note: This is typically done using kubernetes and uploaded to a bucket
poetry run build-iso --release X --isolation=None

# The images are pulled from the bucket
poetry run pull-unpack-tree --release X

# The extra ISO's (usually just DVD) are generated
# !! Use --rc if the image is a release candidate or a beta image
# !! Set --extra-iso-mode to mock if desired
# !! If there is more than the dvd, remove --extra-iso dvd
poetry run build-iso-extra --release X --extra-iso dvd --extra-iso-mode podman

# This pulls the generic and EC2 cloud images
poetry run pull-cloud-image --release X

# This ensures everything is closed out for a release. This copies iso's, images,
# generates metadata, and the like.
# !! DO NOT RUN DURING INCREMENTAL UPDATES !!
poetry run finalize_compose --release X
```

## Syncing Composes

Syncing utilizes the sync scripts provided in the release engineering toolkit.

When the scripts are being ran, they are usually ran with a specific purpose or a reason. As such, the correct scripts should be ran.

The below are common vars files. common_X will override what's in common. Typically these set what repositories exist and how they are named or look at the top level. These also set the current major.minor release as necessary.

```
.
├── common
├── common_8
├── common_9
```

These are for the releases in general. What they do is noted below.

```
├── gen-torrents.sh                  -> Generates torrents for images
├── minor-release-sync-to-staging.sh -> Syncs a minor release to staging
├── prep-staging-X.sh                -> Preps staging updates and signs repos (only for 8)
├── sign-repos-only.sh               -> Signs the repomd (only for 8)
├── sync-file-list-parallel.sh       -> Generates file lists in parallel for mirror sync scripts
├── sync-to-prod.sh                  -> Syncs staging to production
├── sync-to-prod.delete.sh           -> Syncs staging to production (deletes artifacts that are no longer in staging)
├── sync-to-prod-sig.sh              -> Syncs a sig provided compose to production
├── sync-to-staging.sh               -> Syncs a provided compose to staging
├── sync-to-staging.delete.sh        -> Syncs a provided compose to staging (deletes artifacts that are no longer in the compose)
├── sync-to-staging-sig.sh           -> Syncs a sig provided compose to staging
```

Generally, you will only run `sync-to-staging.sh` or `sync-to-staging.delete.sh` to sync. The former is for older releases, the latter is for newer releases.

```
# The below syncs to staging for Rocky Linux 8
RLVER=8 bash sync-to-staging.sh Rocky
# The below syncs to staging for Rocky Linux 9
RLVER=9 bash sync-to-staging.delete.sh Rocky
```

Once the syncs are done, staging must be tested and vetted before being sent to production. Once staging is completed, it is synced to production.

```
bash RLVER=8 sync-to-prod.sh
bash RLVER=9 sync-to-prod.delete.sh
bash sync-file-list-parallel.sh
```

During this phase, staging is rsynced with production, the file list is updated, and the full time list is also updated to allow mirrors to know that the repositories have been updated and that they can sync.

**Note**: If multiple releases are being updated, it is important to run the syncs to completion before running the file list parallel script.
