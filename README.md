# Packerfiles - HCL2 VM Image Builder

Packer HCL2 templates for building Vagrant-compatible VM images across multiple operating systems and hypervisors.

## Requirements

- [Packer](https://www.packer.io/) 1.7+ (HCL2 support required)
- At least one hypervisor: [VMware Fusion/Workstation](https://www.vmware.com/), [VirtualBox](https://www.virtualbox.org/), or [Parallels Desktop](https://www.parallels.com/)

## Supported Operating Systems

| OS Family | Variants | Builders |
|-----------|----------|----------|
| Ubuntu | 18.04, 22.04 LTS, 24.04 LTS | VMware, VirtualBox, Parallels |
| Debian | 11 (Bullseye), 12 (Bookworm) | VMware, VirtualBox, Parallels |
| CentOS | 7 | VMware, VirtualBox, Parallels |
| Fedora | 40, 41 | VMware, VirtualBox, Parallels |
| Oracle Linux | 8.10, 9.7 | VMware, VirtualBox, Parallels |
| FreeBSD | 14.2 | VMware, VirtualBox, Parallels |
| OpenBSD | 7.6 | VMware, VirtualBox, Parallels |
| NetBSD | 10.1 | VMware, VirtualBox, Parallels |
| DragonFlyBSD | 6.4.2 | VMware, VirtualBox, Parallels |
| Windows Server | 2016, 2022, 2025 | VMware, VirtualBox, Parallels |
| Windows Desktop | 11 Enterprise | VMware, VirtualBox, Parallels |
| VMware ESXi | 6.5 | VMware only |

## Quick Start

All commands must be run from the repository root.

```bash
# Initialize plugins (one-time)
packer init templates/ubuntu/

# Validate a template
packer validate -var-file=vars/ubuntu/ubuntu-2204-server.pkrvars.hcl templates/ubuntu/

# Build an image (all builders)
packer build -var-file=vars/ubuntu/ubuntu-2204-server.pkrvars.hcl templates/ubuntu/

# Build for a specific builder only
packer build -only='vmware-iso.ubuntu' -var-file=vars/ubuntu/ubuntu-2204-server.pkrvars.hcl templates/ubuntu/
```

### Using the Makefile

```bash
make init OS=ubuntu
make validate OS=ubuntu VARIANT=ubuntu-2204-server
make build OS=ubuntu VARIANT=ubuntu-2204-server
make build-only OS=ubuntu VARIANT=ubuntu-2204-server BUILDER=vmware-iso.ubuntu
make validate-all    # Validate all templates
make init-all        # Initialize all plugins
```

## Directory Structure

```
packerfiles/
├── templates/          # HCL2 Packer templates (one directory per OS family)
│   ├── ubuntu/         #   plugins.pkr.hcl, variables.pkr.hcl, sources.pkr.hcl, build.pkr.hcl
│   ├── debian/
│   ├── centos/
│   ├── fedora/
│   ├── oraclelinux/
│   ├── freebsd/
│   ├── openbsd/
│   ├── netbsd/
│   ├── dragonflybsd/
│   ├── windows/        #   Also includes locals.pkr.hcl
│   └── esxi/
├── vars/               # Variable value files (.pkrvars.hcl)
│   ├── ubuntu/         #   ubuntu-2204-server.pkrvars.hcl, etc.
│   ├── windows/        #   eval-win2025-standard-cygwin.pkrvars.hcl, etc.
│   └── .../
├── http/               # Preseed, Kickstart, and autoinstall configs
├── scripts/            # Provisioning scripts (bash, batch, powershell)
├── floppy/             # Windows install-time scripts and Autounattend.xml
├── vagrant/            # Vagrantfile templates
├── archive/            # Legacy JSON templates and EOL OS files
└── Makefile            # Build automation
```

### Template Pattern

Each OS family has 4 HCL2 files in `templates/<os>/`:

- **plugins.pkr.hcl** - Required Packer plugins (vmware, virtualbox, parallels)
- **variables.pkr.hcl** - Variable declarations with types and defaults
- **sources.pkr.hcl** - Source blocks for each hypervisor builder
- **build.pkr.hcl** - Build block with provisioners

Variant files in `vars/<os>/` override variables (ISO URL, checksum, VM name, etc.) and are passed via `-var-file=`.

## Windows

Windows templates use evaluation ISOs from the [Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/). These images can be used for 180 days without activation.

The `autounattend_dir` variable in each Windows variant points to the correct `floppy/` subdirectory containing the `Autounattend.xml` for that Windows edition.

Windows 11 includes TPM/SecureBoot/RAM bypass registry keys for VM compatibility.

## BSD Notes

BSD templates handle per-hypervisor differences in disk device naming through separate source blocks with appropriate boot commands:
- FreeBSD: `da0` (VMware/VBox), `ada0` (Parallels)
- NetBSD: `sd0` (VMware), `wd0` (VBox/Parallels)
- DragonFlyBSD: `da0` (VMware/VBox), `ad0` (Parallels)

Parallels Tools are disabled for all BSD guests (`parallels_tools_mode = "disable"`).

## Credentials

Default credentials for all images: `vagrant` / `vagrant` (standard for Vagrant boxes).

## Proxy Support

Linux templates read proxy settings from environment variables: `http_proxy`, `https_proxy`, `ftp_proxy`, `rsync_proxy`, `no_proxy`.

## Custom ISOs

To use a custom ISO instead of the default download:

```bash
packer build \
  -var iso_url=./iso/my-custom.iso \
  -var 'iso_checksum=sha256:abc123...' \
  -var-file=vars/ubuntu/ubuntu-2204-server.pkrvars.hcl \
  templates/ubuntu/
```

## Contributing

Pull requests welcome. Please validate your templates before submitting:

```bash
make validate-all
```
