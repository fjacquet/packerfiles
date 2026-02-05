source "vmware-iso" "openbsd" {
  boot_command = [
    "boot -s<enter>",
    "<wait10><wait10>",
    "S<enter><wait>",
    "dhclient -l /tmp/dhclient.lease.em0 em0<enter><wait><wait><wait>",
    "ftp -o install.conf http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.install_path} && install -af install.conf && ",
    "echo \"permit nopass keepenv :wheel\" > /mnt/etc/doas.conf && reboot<enter>",
  ]
  boot_wait        = "6s"
  disk_size        = var.disk_size
  guest_os_type    = var.vmware_guest_os_type
  headless         = var.headless
  http_directory   = var.http_directory
  iso_checksum     = var.iso_checksum
  iso_urls         = compact(["${var.iso_path}/${var.iso_name}", var.iso_url])
  output_directory = "output-${var.vm_name}-vmware-iso"
  shutdown_command  = "doas shutdown -p now"
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

source "virtualbox-iso" "openbsd" {
  boot_command = [
    "boot -s<enter>",
    "<wait10><wait10>",
    "S<enter><wait>",
    "dhclient -l /tmp/dhclient.lease.em0 em0<enter><wait><wait><wait>",
    "ftp -o install.conf http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.install_path} && install -af install.conf && ",
    "echo \"permit nopass keepenv :wheel\" > /mnt/etc/doas.conf && reboot<enter>",
  ]
  boot_wait            = "6s"
  disk_size            = var.disk_size
  guest_additions_mode = "disable"
  guest_os_type        = var.virtualbox_guest_os_type
  hard_drive_interface = "sata"
  headless             = var.headless
  http_directory       = var.http_directory
  iso_checksum         = var.iso_checksum
  iso_urls             = compact(["${var.iso_path}/${var.iso_name}", var.iso_url])
  output_directory     = "output-${var.vm_name}-virtualbox-iso"
  shutdown_command      = "doas shutdown -p now"
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

source "parallels-iso" "openbsd" {
  boot_command = [
    "boot -s<enter>",
    "<wait10><wait10>",
    "S<enter><wait>",
    "dhclient -l /tmp/dhclient.lease.em0 em0<enter><wait><wait><wait>",
    "ftp -o install.conf http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.install_path} && install -af install.conf && ",
    "echo \"permit nopass keepenv :wheel\" > /mnt/etc/doas.conf && reboot<enter>",
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
    ["set", "{{.Name}}", "--device-set", "cdrom0", "--iface", "ide"],
    ["set", "{{.Name}}", "--device-del", "fdd0"],
    ["set", "{{.Name}}", "--device-del", "parallel0"],
  ]
  prlctl_version_file = ".prlctl_version"
  shutdown_command     = "doas shutdown -p now"
  ssh_password        = var.ssh_password
  ssh_username        = var.ssh_username
  ssh_timeout         = "10000s"
  vm_name             = var.vm_name
}
