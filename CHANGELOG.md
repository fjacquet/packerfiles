## v2.1.0 (2025)

### Added

* **3 new OS families**: AlmaLinux (9.7, 10.1), Rocky Linux (9.7, 10.1), openSUSE Leap (16.0)
* **Cloud builders** for all templates: Proxmox, Amazon EBS, Azure (commented out by default)
* New `cloud.pkr.hcl` file per template with cloud builder variables and source blocks
* Fedora 42 and 43 variants
* FreeBSD 15.0 variant
* OpenBSD 7.8 variant
* Oracle Linux 10.1 variant
* ESXi 8.0 variant (placeholder checksum - requires Broadcom account)
* Kickstart configs for Fedora 42/43, Oracle Linux 10, AlmaLinux 9/10, Rocky Linux 9/10
* Agama installer profile for openSUSE Leap 16.0
* Provisioning scripts for openSUSE (zypper-based update, cleanup, etc.)

### Archived

* Ubuntu 18.04 (EOL April 2023) moved to `archive/eol/`
* CentOS 7 (EOL June 2024) moved to `archive/eol/`
* Fedora 40 (EOL May 2025) moved to `archive/eol/`
* ESXi 6.5 (EOL October 2022) moved to `archive/eol/`

---

## v2.0.0 (2025)

### Breaking Changes

* **Full HCL2 migration** - All templates converted from JSON to HCL2 format
* Legacy JSON templates archived in `archive/json-legacy/`
* EOL OS templates (Windows 2008 R2, 7, CentOS 6, etc.) archived in `archive/eol/`
* Directory structure reorganized: `templates/<os>/` and `vars/<os>/`

### Added

* HCL2 templates for 11 OS families: Ubuntu, Debian, CentOS, Fedora, Oracle Linux, FreeBSD, OpenBSD, NetBSD, DragonFlyBSD, Windows, ESXi
* Windows Server 2025 Standard evaluation support
* Windows 11 Enterprise evaluation support (with TPM/SecureBoot bypass)
* Ubuntu 24.04 LTS and 22.04 LTS variants
* Fedora 40 and 41 variants
* Debian 12 (Bookworm) variant
* Oracle Linux 8.10 and 9.7 variants
* FreeBSD 14.2, OpenBSD 7.6, NetBSD 10.1, DragonFlyBSD 6.4.2 variants
* Makefile with `validate`, `build`, `build-only`, `init-all`, `validate-all` targets
* Kickstart configs for Fedora 40/41 and Oracle Linux 8/9
* Preseed config for Debian 12 (Bookworm)

### Fixed

* Removed deprecated `--force-yes` from apt-get (ubuntu, debian)
* Updated Cygwin OpenSSH from 7.1/7.2 to 10.0p1
* Updated Chocolatey install URL to `community.chocolatey.org`
* Added missing shebangs to ESXi and Oracle Linux scripts
* Replaced deprecated `service`/`chkconfig` with `systemctl` (centos, oracle)
* Fixed VMware hardware version minimum (13) for ESXi template
* Fixed `tools_upload_flavor` for BSD (must be `linux`, not `freebsd`)

### Archived

* 14 orphaned floppy scripts moved to `archive/orphaned-floppy/`
* Win2008 R2 Standard Core Autounattend.xml moved to archive

---

## Unreleased (legacy)

* Fixed issue with Console Output in win-updates.ps1 (#245)
* Added Windows 2016 build (#243)
* Use VBox certs from guest addition (#247, #250)
* Improve Windows 10 (#236)
* Add more build variables (#228)
* Increase 2008R2 timeouts (#206)

## v1.25 (August 13th, 2015)

* Updated 7-Zip, UltraDefrag URLs (#154)
* Added Windows 10 build (#149, #163)
* Updated VMware Tools to 9.9.3 (#162)
* Improved update script (#164)
* Increased memory for WinRM shell (#165)

## v1.24 (June 8th, 2015)

* Clarified use of the `<Key>` element in Windows 8.1 autounattend file (#114)
* Fixed issue with OpenSSH / Packer race condition (#113)
* Fixed issue with Windows 8.1 product key and computer name (#121)
* Fixed issue where disk size would always be 60GB regardless of value in packer template (#117)
* Added Windows 10 Technical Preview (#132, #144)
* Fixed Windows Updates for Windows 2008 R2 builds (#135)
* Display Windows Updates that have been installed (#139)
* Added support for Hyper-V Server 2012 R2 (#120)
* Updated OpenSSH to 6.7 (#111)
* Updated Ultadefrag to 6.1.0 (#145)
* Fixed ComputerName for Windows 7 build (#125)

## v1.23 (Nov 5th, 2014)

* Resolved issue with Windows 7 not successfully completing an update run (#83)

## v1.22 (Sept 8th, 2014)

* Forward SSH port by default on Vagrant boxes (#76)
* Box no longer auto logs on upon boot (#66)
* Updated Virtualbox Guest OS Type for Win8.1 (#81)

## v1.21 (Aug 6th, 2014)

* Added rsync.bat as an optional script to include rsync capabilities to the vagrant box (#88)
* RDP now enabled for use with vagrant (#75)

## v1.20 (July 21st, 2014)

* Update Chocolatey script for Chocolatey 0.9.8.27
* Password for Vagrant user never expires
* Salt installation script
* Microsoft-updates.bat script for Win 7/8

## v1.19 (May 17th, 2014)

* Enable Microsoft Updates by default (#60)
* Remove disable Windows Updates script from Windows 7 and 8.1; you can run this as a provioner step, and use Autounattend sections to achieve the same outcome

## v1.18 (May 16th, 2014)

* Require Vagrant 1.6.2 (#57)
* Remove WinRM port forward, as it's done automatically in Vagrant 1.6.2+ (#57)
* Update chef-client source to getchef.com (#63)

## v1.16 (May 7th, 2014)

* Fix VirtualBox ISO URLs

## v1.15 (May 7th, 2014)

* Update Puppet to 3.5.1 (#54)
* Fix ISO Url for 2008 R2 (#56)

## v1.14 (May 6th, 2014)

* Compact generated VMs using ultradefrag and sdelete (#53)
* Fix Windows 2012 R2 issue where the `vagrant` user did not have its password set
* Fix Windows 2012 R2 issue where autologon only works once

## v1.13 (May 2nd, 2014)

* Fixed ISO Urls (#47)

## v1.12 (April 29th, 2014)

* Update OpenSSH

## v1.11 (April 5th, 2014)

* Change the default shell for OpenSSH from /bin/bash to /bin/sh (#45)

## v1.10 (March 18th, 2014)

* Ensure WinRM service starts immediately rather than after 120 seconds (#43)

## v1.9 (March 14th, 2014)

* Add support for Windows 8.1
* Add port forwarding for WinRM (5985) by default, with vagrant auto-correct enabled
* Require the use of the vagrant-windows plugin in the Vagrantfile templates

## v1.8 (March 7th, 2014)

* Updated oracle.cer to allow installation of VirtualBox tools

## v1.7 (February 26, 2014)

* Add support for Windows 7 Enterprise
* Add support for Windows 2008 R2 Core
* Add support for Windows 2012 R2 Core
* Remove port forwarding from Vagrantfile templates
* Update Puppet version in scripts/puppet.bat

## v1.6 (January 20, 2014)

* Remove `config.vm.base_mac = "{{ .BaseMacAddress }}"` from vagrantfile templates, ensure SCSI controller is set in VMX (fixes #26)

## v1.5 (January 9, 2014)

* Fix issue with installation of VM guest tools [GH-23]

## v1.4 (December 31, 2013)

* Update .json files to work with Packer 0.5.0 (the `vmware` builder is renamed to `vmware-iso`, the `virtualbox` builder is renamed to `virtualbox-iso`)
* Update README with better examples for using retail custom ISO files and disabling Windows Update installation

## v1.3 (December 18, 2013)

* Allow Packer to upload VMware Tools by default, but fall back to downloading the tools from VMware if required
* Update SCSI bus type for the hard disk in a VMware VM to permit Windows 2012 R2 to install correctly

## v1.2 (December 18, 2013)

* Add support for Windows 2012 and Windows 2012 R2
* Switch all configurations to use Microsoft trial images

## v1.1 (December 17, 2013)

* Initial release, including working Windows 2008 R2 configuration
