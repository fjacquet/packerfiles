source "vmware-iso" "fedora" {
  boot_command = [
    "<tab> linux text biosdevname=0 ks=http://{{ .HTTPIP }}:{{ .HTTPPort}}/${var.kickstart}<enter><enter>",
  ]
  disk_size            = var.disk_size
  guest_os_type        = var.vmware_guest_os_type
  headless             = var.headless
  http_directory       = var.http_directory
  iso_checksum         = var.iso_checksum
  iso_urls             = compact(["${var.iso_path}/${var.iso_name}", var.iso_url])
  output_directory     = "output-${var.vm_name}-vmware-iso"
  shutdown_command      = var.shutdown_command
  ssh_password         = var.ssh_password
  ssh_username         = var.ssh_username
  ssh_timeout          = "10000s"
  tools_upload_flavor  = "linux"
  vm_name              = var.vm_name
  vmx_data = {
    "cpuid.coresPerSocket" = "1"
    "memsize"              = var.memory
    "numvcpus"             = var.cpus
  }
  vmx_remove_ethernet_interfaces = true
}

source "virtualbox-iso" "fedora" {
  boot_command = [
    "<tab> linux text biosdevname=0 ks=http://{{ .HTTPIP }}:{{ .HTTPPort}}/${var.kickstart}<enter><enter>",
  ]
  disk_size               = var.disk_size
  guest_additions_path    = "VBoxGuestAdditions_{{.Version}}.iso"
  guest_os_type           = var.virtualbox_guest_os_type
  hard_drive_interface    = "sata"
  hard_drive_nonrotational = true
  headless                = var.headless
  http_directory          = var.http_directory
  iso_checksum            = var.iso_checksum
  iso_urls                = compact(["${var.iso_path}/${var.iso_name}", var.iso_url])
  output_directory        = "output-${var.vm_name}-virtualbox-iso"
  shutdown_command         = var.shutdown_command
  ssh_password            = var.ssh_password
  ssh_username            = var.ssh_username
  ssh_timeout             = "10000s"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", var.memory],
    ["modifyvm", "{{.Name}}", "--cpus", var.cpus],
  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = var.vm_name
}

source "parallels-iso" "fedora" {
  boot_command = [
    "<tab> linux text biosdevname=0 ks=http://{{ .HTTPIP }}:{{ .HTTPPort}}/${var.kickstart}<enter><enter>",
  ]
  disk_size              = var.disk_size
  guest_os_type          = var.parallels_guest_os_type
  http_directory         = var.http_directory
  iso_checksum           = var.iso_checksum
  iso_urls               = compact(["${var.iso_path}/${var.iso_name}", var.iso_url])
  output_directory       = "output-${var.vm_name}-parallels-iso"
  parallels_tools_flavor = "lin"
  prlctl = [
    ["set", "{{.Name}}", "--memsize", var.memory],
    ["set", "{{.Name}}", "--cpus", var.cpus],
  ]
  prlctl_version_file = ".prlctl_version"
  shutdown_command     = var.shutdown_command
  ssh_password        = var.ssh_password
  ssh_username        = var.ssh_username
  ssh_timeout         = "10000s"
  vm_name             = var.vm_name
}
