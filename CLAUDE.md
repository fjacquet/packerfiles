# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Collection of HashiCorp Packer HCL2 templates for building Vagrant-compatible VM images across 11 OS families and 3 hypervisors (VMware, VirtualBox, Parallels). Windows also supports Amazon EBS (currently disabled in build). Legacy JSON templates are archived in `archive/json-legacy/`.

Requires Packer 1.7+ with HCL2 support. Currently validated with Packer 1.15.0.

## Build Commands

All commands must be run from the repository root.

Initialize plugins (one-time per OS):

```bash
packer init templates/ubuntu/
```

Validate a template:

```bash
packer validate -var-file=vars/ubuntu/ubuntu-2204-server.pkrvars.hcl templates/ubuntu/
```

Build an image:

```bash
packer build -var-file=vars/ubuntu/ubuntu-2204-server.pkrvars.hcl templates/ubuntu/
```

Build for a specific builder:

```bash
packer build -only='vmware-iso.ubuntu' -var-file=vars/ubuntu/ubuntu-2204-server.pkrvars.hcl templates/ubuntu/
```

Using the Makefile:

```bash
make validate OS=ubuntu VARIANT=ubuntu-2204-server
make build OS=ubuntu VARIANT=ubuntu-2204-server
make build-only OS=ubuntu VARIANT=ubuntu-2204-server BUILDER=vmware-iso.ubuntu
make validate-all
```

## Architecture

### Template Pattern (Two-Part System)

**Template directories** (`templates/<os>/`) contain 4 HCL2 files:

- `plugins.pkr.hcl` - `required_plugins` block
- `variables.pkr.hcl` - Variable declarations with types and defaults
- `sources.pkr.hcl` - Source blocks for each hypervisor (vmware-iso, virtualbox-iso, parallels-iso)
- `build.pkr.hcl` - Build block with provisioners

Windows also has `locals.pkr.hcl` for dynamic floppy file list construction.

**Variant files** (`vars/<os>/*.pkrvars.hcl`) override variables per OS version:

- ISO URL and checksum (algorithm prefix in value, e.g. `"sha256:abc..."`)
- VM name, memory, CPUs
- Guest OS type per hypervisor
- Passed via `-var-file=` flag

### Directory Layout

- `templates/` - HCL2 Packer templates (11 OS families)
- `vars/` - Variable value files (.pkrvars.hcl), organized by OS family
- `http/` - Preseed (Debian/Ubuntu), Kickstart (CentOS/Fedora/Oracle), autoinstall configs
- `floppy/` - Windows install-time scripts and per-edition Autounattend.xml
- `scripts/bash/<distro>/` - Linux provisioning scripts
- `scripts/batch/` - Windows batch provisioning scripts
- `scripts/powershell/` - Windows PowerShell provisioning scripts
- `vagrant/` - Vagrantfile templates
- `iso/` - Local ISO cache (gitignored)
- `archive/` - Legacy JSON templates, EOL OS files, orphaned scripts

### Provisioning Pipeline

**Linux** runs shell scripts in order: update -> desktop (optional) -> vagrant user setup -> sshd -> hypervisor tools (vmware/virtualbox/parallels) -> motd -> minimize -> cleanup

**Windows** uses a two-phase approach:

1. Floppy-based scripts during install (Autounattend.xml triggers `00-run-all-scripts.cmd` which runs wget install, Cygwin/OpenSSH setup, WinRM)
2. Post-install batch provisioners (vagrant user, config management tools, VM tools, cleanup, defrag, sdelete)

**BSD** uses su-based (FreeBSD) or doas-based (OpenBSD) privilege escalation. Parallels tools are disabled for all BSD guests.

### HCL2 Conventions

- `iso_checksum` includes algorithm prefix: `"sha256:abc..."` (no separate `iso_checksum_type`)
- `ssh_timeout` (not `ssh_wait_timeout`)
- `var.X` syntax (not `{{ user "X" }}`)
- Go template syntax preserved in `boot_command` (e.g. `{{.Name}}`, `{{ .HTTPIP }}`)
- `sensitive = true` on password and AWS key variables
- Proxy variables use `default = env("http_proxy")` pattern

### OS-Specific Notes

- **Ubuntu 22.04+**: Uses autoinstall (cloud-init), not legacy preseed
- **BSD**: Per-hypervisor boot commands due to different disk device names (wd0/sd0/da0/ad0)
- **Windows**: `autounattend_dir` variable selects the correct floppy subdirectory per edition
- **Windows 11**: Includes TPM/SecureBoot/RAM bypass registry keys for VM install
- **ESXi**: VMware-only builder with nested virtualization (vhv.enable=TRUE)

### Naming Conventions

- Templates: `templates/<os-family>/`
- Variants: `vars/<os-family>/<name>.pkrvars.hcl`
- Source blocks: `source "<builder>" "<os-family>"` (e.g. `source "vmware-iso" "ubuntu"`)

Default credentials: `vagrant`/`vagrant` (standard for Vagrant boxes).
