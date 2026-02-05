// Note: DragonFlyBSD uses different disk device names per hypervisor:
// VirtualBox = da0, VMware = da0, Parallels = ad0

source "vmware-iso" "dragonflybsd" {
  boot_command = [
    "1",
    "<wait10><wait10><wait10>",
    "root<enter>dhclient em0<enter><wait>",
    "fetch -o /tmp/install.sh http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.install_path}",
    " && sh /tmp/install.sh da0 ${var.hostname} vagrant",
    " ${var.ssh_password} \"${var.ssh_fullname}\"<enter>",
  ]
  boot_wait        = "6s"
  disk_size        = var.disk_size
  guest_os_type    = var.vmware_guest_os_type
  headless         = var.headless
  http_directory   = var.http_directory
  iso_checksum     = var.iso_checksum
  iso_urls         = compact(["${var.iso_path}/${var.iso_name}", var.iso_url])
  output_directory = "output-${var.vm_name}-vmware-iso"
  shutdown_command  = "sudo shutdown -p now"
  ssh_password     = var.ssh_password
  ssh_username     = var.ssh_username
  ssh_timeout      = "10000s"
  vm_name          = var.vm_name
  vmx_data = {
    "memsize"  = var.memory
    "numvcpus" = var.cpus
  }
  vmx_remove_ethernet_interfaces = true
}

source "virtualbox-iso" "dragonflybsd" {
  boot_command = [
    "1",
    "<wait10><wait10><wait10>",
    "root<enter>dhclient em0<enter><wait>",
    "fetch -o /tmp/install.sh http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.install_path}",
    " && sh /tmp/install.sh da0 ${var.hostname} vagrant",
    " ${var.ssh_password} \"${var.ssh_fullname}\"<enter>",
  ]
  boot_wait            = "6s"
  disk_size            = var.disk_size
  guest_additions_path = "VBoxGuestAdditions_{{.Version}}.iso"
  guest_os_type        = var.virtualbox_guest_os_type
  hard_drive_interface = "sata"
  headless             = var.headless
  http_directory       = var.http_directory
  iso_checksum         = var.iso_checksum
  iso_urls             = compact(["${var.iso_path}/${var.iso_name}", var.iso_url])
  output_directory     = "output-${var.vm_name}-virtualbox-iso"
  shutdown_command      = "sudo shutdown -p now"
  ssh_password         = var.ssh_password
  ssh_username         = var.ssh_username
  ssh_timeout          = "10000s"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", var.memory],
    ["modifyvm", "{{.Name}}", "--cpus", var.cpus],
  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = var.vm_name
}

source "parallels-iso" "dragonflybsd" {
  boot_command = [
    "1",
    "<wait10><wait10><wait10><wait10>",
    "root<enter>dhclient em0<enter><wait>",
    "fetch -o /tmp/install.sh http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.install_path}",
    " && sh /tmp/install.sh ad0 ${var.hostname} vagrant",
    " ${var.ssh_password} \"${var.ssh_fullname}\"<enter>",
  ]
  boot_wait              = "6s"
  disk_size              = var.disk_size
  guest_os_type          = var.parallels_guest_os_type
  hard_drive_interface   = "ide"
  http_directory         = var.http_directory
  iso_checksum           = var.iso_checksum
  iso_urls               = compact(["${var.iso_path}/${var.iso_name}", var.iso_url])
  output_directory       = "output-${var.vm_name}-parallels-iso"
  parallels_tools_mode   = "disable"
  prlctl = [
    ["set", "{{.Name}}", "--memsize", var.memory],
    ["set", "{{.Name}}", "--cpus", var.cpus],
    ["set", "{{.Name}}", "--device-del", "fdd0"],
  ]
  prlctl_version_file = ".prlctl_version"
  shutdown_command     = "sudo shutdown -p now"
  ssh_password        = var.ssh_password
  ssh_username        = var.ssh_username
  ssh_timeout         = "10000s"
  vm_name             = var.vm_name
}
