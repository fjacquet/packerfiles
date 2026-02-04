# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Collection of HashiCorp Packer templates (JSON format, no HCL) for building Vagrant-compatible VM images across multiple operating systems and hypervisors. Originally forked from VeeWee Windows templates.

Requires Packer 0.5.1+. All templates use legacy JSON format.

## Build Commands

Build a Linux image (base template + variant file):
```bash
packer build -var-file=ubuntu1804-server.json ubuntu.json
packer build -var-file=centos7-server.json centos.json
packer build -var-file=fedora-28-server.json fedora.json
```

Build a Windows image (variant file includes all config):
```bash
packer build -var-file=eval-win2016-standard-cygwin.json windows.json
```

Build with custom ISO:
```bash
packer build -var iso_url=./iso/my.iso -var iso_checksum=abc123 windows.json
```

Validate a template:
```bash
packer validate -var-file=ubuntu1804-server.json ubuntu.json
```

## Architecture

### Template Pattern (Two-File System)

**Base templates** (e.g., `ubuntu.json`, `centos.json`, `fedora.json`, `windows.json`, `oraclelinux.json`, `freebsd.json`) contain:
- Builder definitions for all hypervisors (vmware-iso, virtualbox-iso, parallels-iso; windows.json also has amazon-ebs)
- Provisioner scripts (shell scripts executed in order)
- Default variable values with `{{ user 'variable_name' }}` references

**Variant files** (e.g., `ubuntu1804-server.json`, `centos7-desktop.json`, `eval-win2016-standard-cygwin.json`) contain:
- Only variable overrides (ISO URLs, checksums, VM names, memory/CPU)
- No builders or provisioners
- Passed via `-var-file=` flag

### Directory Layout

- `*.json` (root) - Packer templates and variant files (~146 files)
- `http/` - Preseed (Debian/Ubuntu) and Kickstart (CentOS/Fedora/Oracle) files for unattended Linux installs
- `answer_files/` - Windows Autounattend.xml files per edition
- `floppy/` - Windows install-time scripts (.cmd, .bat, .ps1, .vbs) and per-edition Autounattend.xml
- `scripts/bash/{distro}/` - Linux provisioning scripts (update, vagrant, sshd, vmware, virtualbox, parallels, cleanup, minimize)
- `scripts/batch/` - Windows provisioning batch scripts
- `scripts/powershell/` - Windows provisioning PowerShell scripts
- `vagrant/` - Vagrantfile templates for output boxes
- `iso/` - Local ISO cache (gitignored)
- `old/` - Deprecated templates

### Provisioning Pipeline

**Linux** runs shell scripts in order: update -> desktop (optional) -> vagrant user setup -> sshd -> hypervisor tools (vmware/virtualbox/parallels) -> motd -> minimize -> cleanup

**Windows** uses a two-phase approach:
1. Floppy-based scripts during install (Autounattend.xml triggers `00-run-all-scripts.cmd` which runs wget install, Cygwin/OpenSSH setup, WinRM)
2. Post-install batch provisioners (vagrant user, config management tools, VM tools, cleanup, defrag, sdelete)

### Conventions

- Default credentials: `vagrant`/`vagrant` (standard for Vagrant boxes)
- Proxy support: All Linux templates read `http_proxy`, `https_proxy`, `ftp_proxy`, `rsync_proxy`, `no_proxy` from environment variables
- Windows SSH: Via Cygwin (primary) or OpenSSH; WinRM available on port 5985 but SSH is the Packer communicator
- Windows uses trial/evaluation ISOs by default (180-day); retail ISOs go in `iso/` with custom `-var` overrides
- Output directories follow `output-{vm_name}-{builder}/` pattern (gitignored)

### OS Naming Conventions

- Ubuntu: `ubuntu{YYMM}-{server|desktop}.json`
- CentOS: `centos{major}-{server|desktop}.json`
- Fedora: `fedora-{version}-{server|desktop}.json`
- Oracle Linux: `ol{major}{minor}[-desktop][-i386].json`
- Windows: `eval-win{version}-{edition}[-cygwin|-ssh].json`
- BSD: `{distro}{version}.json` (freebsd, openbsd, netbsd, dragonflybsd)
