# Windows and Linux Templates for Packer

### Introduction

This repository contains templates that can be used to VM using Packer ([Website](http://www.packer.io)) ([Github](https://github.com/mitchellh/packer/)).

This repo began by borrowing bits from 
the VeeWee Windows templates (https://github.com/jedi4ever/veewee/tree/master/templates). 
Modifications were made to work with Packer and 

* Amazon Web Services : this need a different logic but you can still add you customized image to prepare to use with terraform
* VirtualBox : to generate ovf file easily but slowly
* VMware Fusion : much faster but costly (use VMUG advantage) and need to add ovftool in your PATH

providers for Packer .

### Packer Version

[Packer](https://github.com/mitchellh/packer/blob/master/CHANGELOG.md) `0.5.1` or greater is required.

### Operating Systems versions

The following Windows versions are known to work (built with VMware Fusion and VirtualBox):

 * Fedora 26 Server
 * Fedora 26 Desktop 
 * Fedora 27 Server
 * Fedora 27 Desktop 
 * Windows 2012 R2
 * Windows 2016
 * Windows 2008 R2
 * Windows 10
 

### Windows Editions

All Windows Server versions are defaulted to the Server Standard edition. You can modify this by editing the Autounattend.xml file, changing the `ImageInstall`>`OSImage`>`InstallFrom`>`MetaData`>`Value` element (e.g. to Windows Server 2012 R2 SERVERDATACENTER).

### Product Keys

The `Autounattend.xml` files are configured to work correctly with trial ISOs (which will be downloaded and cached for you the first time you perform a `packer build`). If you would like to use retail or volume license ISOs, you need to update the `UserData`>`ProductKey` element as follows:

* Uncomment the `<Key>...</Key>` element
* Insert your product key into the `Key` element

If you are going to configure your VM as a KMS client, you can use the product keys at http://technet.microsoft.com/en-us/library/jj612867.aspx. These are the default values used in the `Key` element.

### Windows Updates

The scripts in this repo will install all Windows updates – by default – during Windows Setup. This is a _very_ time consuming process, depending on the age of the OS and the quantity of updates released since the last service pack. You might want to do yourself a favor during development and disable this functionality, by commenting out the `WITH WINDOWS UPDATES` section and uncommenting the `WITHOUT WINDOWS UPDATES` section in `Autounattend.xml`:

```xml
<!-- WITHOUT WINDOWS UPDATES -->
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\openssh.ps1 -AutoStart</CommandLine>
    <Description>Install OpenSSH</Description>
    <Order>99</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
<!-- END WITHOUT WINDOWS UPDATES -->
<!-- WITH WINDOWS UPDATES -->
<!--
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c a:\microsoft-updates.bat</CommandLine>
    <Order>98</Order>
    <Description>Enable Microsoft Updates</Description>
</SynchronousCommand>
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\openssh.ps1</CommandLine>
    <Description>Install OpenSSH</Description>
    <Order>99</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\win-updates.ps1</CommandLine>
    <Description>Install Windows Updates</Description>
    <Order>100</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
-->
<!-- END WITH WINDOWS UPDATES -->
```

Doing so will give you hours back in your day, which is a good thing.

### OpenSSH / WinRM

Currently, [Packer](http://packer.io) has a single communicator that uses SSH. This means we need an SSH server installed on Windows - which is not optimal as we could use WinRM to communicate with the Windows VM. In the short term, everything works well with SSH; in the medium term, work is underway on a WinRM communicator for Packer.

If you have serious objections to OpenSSH being installed, you can always add another stage to your build pipeline:

* Build a base box using Packer
* Create a Vagrantfile, use the base box from Packer, connect to the VM via WinRM (using the [vagrant-windows](https://github.com/WinRb/vagrant-windows) plugin) and disable the 'sshd' service or uninstall OpenSSH completely
* Perform a Vagrant run and output a .box file

It's worth mentioning that many Chef cookbooks will not work properly through Cygwin's SSH environment on Windows. Specifically, packages that need access to environment-specific configurations such as the `PATH` variable, will fail. This includes packages that use the Windows installer, `msiexec.exe`.

It's currently recommended that you add a second step to your pipeline and use Vagrant to install your packages through Chef.

### Getting Started

Trial versions of Windows 2012 R2 / 2016 are used by default. These images can be used for 180 days without activation.

Alternatively – if you have access to [MSDN](http://msdn.microsoft.com) or [TechNet](http://technet.microsoft.com/) – you can download retail or volume license ISO images and place them in the `iso` directory. If you do, you should supply appropriate values for `iso_url` (e.g. `./iso/<path to your iso>.iso`) and `iso_checksum` (e.g. `<the md5 of your iso>`) to the Packer command. For example, to use the Windows 2008 R2 (With SP1) retail ISO:

1. Download the Windows Server 2008 R2 with Service Pack 1 (x64) - DVD (English) ISO (`en_windows_server_2008_r2_with_sp1_x64_dvd_617601.iso`)
2. Verify that `en_windows_server_2008_r2_with_sp1_x64_dvd_617601.iso` has an MD5 hash of `8dcde01d0da526100869e2457aafb7ca` (Microsoft lists a SHA1 hash of `d3fd7bf85ee1d5bdd72de5b2c69a7b470733cd0a`, which is equivalent)
3. Clone this repo to a local directory
4. Move `en_windows_server_2008_r2_with_sp1_x64_dvd_617601.iso` to the `iso` directory
5. Run:
    
    ```
    packer build \
        -var iso_url=./iso/en_windows_server_2008_r2_with_sp1_x64_dvd_617601.iso \
        -var iso_checksum=8dcde01d0da526100869e2457aafb7ca windows_2008_r2.json
    ```

### Variables

The Packer templates support the following variables:

| Name                | Description                                                      |
| --------------------|------------------------------------------------------------------|
| `iso_url`           | Path or URL to ISO file                                          |
| `iso_checksum`      | Checksum (see also `iso_checksum_type`) of the ISO file          |
| `iso_checksum_type` | The checksum algorithm to use (out of those supported by Packer) |
| `autounattend`      | Path to the Autounattend.xml file                                |

### Contributing

Pull requests welcomed.

### Acknowledgements

[CloudBees](http://www.cloudbees.com) is providing a hosted [Jenkins](http://jenkins-ci.org/) master through their CloudBees FOSS program. We also use their [On-Premise Executor](https://developer.cloudbees.com/bin/view/DEV/On-Premise+Executors) feature to connect a physical [Mac Mini Server](http://www.apple.com/mac-mini/server/) running VMware Fusion.

![Powered By CloudBees](http://www.cloudbees.com/sites/default/files/Button-Powered-by-CB.png "Powered By CloudBees")![Built On DEV@Cloud](http://www.cloudbees.com/sites/default/files/Button-Built-on-CB-1.png "Built On DEV@Cloud")
