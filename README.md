# Meteor Builder Docker Images <!-- omit in toc -->

This repository contains the Dockerfile and scripts for creating [Docker]
containers for building [Meteor] apps.
The base image is from [Debian].

[Docker]: https://www.docker.com/
[Meteor]: https://www.meteor.com/
[Debian]: https://hub.docker.com/_/debian

## Table of Contents <!-- omit in toc -->

- [Image Tags](#image-tags)
- [Supported Meteor and Debian Versions](#supported-meteor-and-debian-versions)
- [Configuring Image Tags](#configuring-image-tags)
  - [Meteor Versions](#meteor-versions)
    - [Examples](#examples)
  - [Debian Versions](#debian-versions)
    - [Example](#example)

## Image Tags

The tags of the images are in the form of `<meteor version>-<debian version>`.
The [Debian] version is omitted for images with the default [Debian] version.
The [Meteor] version is omitted for images with the latest [Meteor] version.
The image with the default [Debian] version and the latest [Meteor] version gets
the `latest` tag.

Examples:

- `1.9.2-buster`
- `1.8.0.2-debian8`
- `1.9.1` (default [Debian] version)
- `stretch` (latest [Meteor] version)
- `latest` (latest [Meteor] on default [Debian] version)

## Supported Meteor and Debian Versions

For [Meteor], the list of supported versions is as follows.

| [Meteor] Version |  Image Tags   |
| :--------------: | :-----------: |
|      1.9.2       | 1.9.2, 1.9, 1 |
|      1.9.1       |     1.9.1     |
|       1.9        |     1.9.0     |
|      1.8.3       |  1.8.3, 1.8   |
|      1.8.2       |     1.8.2     |
|     1.8.0.2      |    1.8.0.2    |
|     1.8.0.1      |    1.8.0.1    |
|       1.8        |     1.8.0     |

For [Debian], the default is stretch(9).

| [Debian] Version | Version Number |    Image Tags    |
| :--------------: | :------------: | :--------------: |
|      buster      |       10       | buster, debian10 |
|     stretch      |       9        | stretch, debian9 |
|      jessie      |       8        | jessie, debian8  |

## Configuring Image Tags

The [Meteor] and [Debian] versions used can be configured in the
[`vars.sh`][vars] file.

[vars]: scripts/vars.sh

### Meteor Versions

The [Meteor] versions list should be ordered in a descending order.
They also have to be in the [semver] format with three parts, unless the [Meteor]
version itself is longer.

[semver]: https://semver.org/

#### Examples

```sh
# Invalid format
METEOR_VERSIONS=(1.8.2 1.8 1.9 1.9.1 1.7)

# Valid format
# Note the order of the versions and additional `.0` after each new minor release.
METEOR_VERSIONS=(1.9.2 1.9.1 1.9.0 1.8.3 1.8.2 1.8.1 1.8.0.2 1.8.0.1 1.8.0)
```

### Debian Versions

The order of the [Debian] versions list do not matter except for the first one.
The first one in the list is the default version.
There are two lists: one with the official [Debian] version names and the other with
numerical versions.
If the number of elements in the two lists do not match, the [`vars.sh`][vars] script
will print the error message and exit with code `1`.

#### Example

```sh
# The numbers of the elements in two lists should match.
DEBIAN_VERSIONS=(stretch buster jessie)
DEBIAN_NUM_VERSIONS=(9 10 8)
```
