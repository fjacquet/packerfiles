# Packer HCL2 Templates for BSD

## Overview

This repository contains [Packer](https://packer.io/) HCL2 templates for creating BSD Vagrant boxes.

## Supported BSD Flavors

| OS | Version | Template | Variant |
|----|---------|----------|---------|
| FreeBSD | 14.2 | `templates/freebsd/` | `vars/freebsd/freebsd-14.pkrvars.hcl` |
| OpenBSD | 7.6 | `templates/openbsd/` | `vars/openbsd/openbsd-76.pkrvars.hcl` |
| NetBSD | 10.1 | `templates/netbsd/` | `vars/netbsd/netbsd-10.pkrvars.hcl` |
| DragonFlyBSD | 6.4.2 | `templates/dragonflybsd/` | `vars/dragonflybsd/dragonflybsd-64.pkrvars.hcl` |

## Building

All commands run from the repository root. You need [VirtualBox](https://www.virtualbox.org/wiki/Downloads),
[VMware Fusion](https://www.vmware.com/products/fusion)/[VMware Workstation](https://www.vmware.com/products/workstation) or
[Parallels](http://www.parallels.com/products/desktop/whats-new/) installed.

```bash
# Initialize plugins (one-time)
packer init templates/freebsd/

# Validate
packer validate -var-file=vars/freebsd/freebsd-14.pkrvars.hcl templates/freebsd/

# Build for all hypervisors
packer build -var-file=vars/freebsd/freebsd-14.pkrvars.hcl templates/freebsd/

# Build for a specific hypervisor
packer build -only='vmware-iso.freebsd' -var-file=vars/freebsd/freebsd-14.pkrvars.hcl templates/freebsd/
```

Or using the Makefile:

```bash
make validate OS=freebsd VARIANT=freebsd-14
make build OS=freebsd VARIANT=freebsd-14
make build-only OS=freebsd VARIANT=freebsd-14 BUILDER=virtualbox-iso.freebsd
```

## Hypervisor Support

All BSD templates support three hypervisors:

- `vmware-iso` - VMware Fusion / Workstation
- `virtualbox-iso` - VirtualBox
- `parallels-iso` - Parallels Desktop (Pro Edition required)

Parallels Tools are disabled for all BSD guests (`parallels_tools_mode = "disable"`).

## Boot Command Differences

BSD templates use per-hypervisor boot commands due to different disk device names:

- **FreeBSD**: `da0` (VMware/VBox), `ada0` (Parallels)
- **NetBSD**: `sd0` (VMware), `wd0` (VBox/Parallels)
- **DragonFlyBSD**: `da0` (VMware/VBox), `ad0` (Parallels)
- **OpenBSD**: Consistent across hypervisors

## Privilege Escalation

- **FreeBSD**: Uses `su` (`echo 'vagrant' | su -m root -c 'sh -eux {{.Path}}'`)
- **OpenBSD**: Uses `doas`
- **NetBSD/DragonFlyBSD**: Uses `su`

## Proxy Settings

The templates respect these network proxy environment variables:

- `http_proxy`
- `https_proxy`
- `ftp_proxy`
- `rsync_proxy`
- `no_proxy`

## Known Issues

The NetBSD box may time out on `vagrant up` waiting on SSH, but `vagrant ssh` works fine. See [mitchellh/vagrant#6640](https://github.com/mitchellh/vagrant/issues/6640).
