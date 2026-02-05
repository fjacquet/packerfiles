// Proxmox Configuration
variable "proxmox_url" {
  type    = string
  default = ""
}

variable "proxmox_username" {
  type    = string
  default = "root@pam"
}

variable "proxmox_token" {
  type      = string
  default   = ""
  sensitive = true
}

variable "proxmox_node" {
  type    = string
  default = "pve"
}

variable "proxmox_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "proxmox_iso_storage" {
  type    = string
  default = "local"
}

variable "proxmox_network_bridge" {
  type    = string
  default = "vmbr0"
}

source "proxmox-iso" "openbsd" {
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_username
  token                    = var.proxmox_token
  node                     = var.proxmox_node
  insecure_skip_tls_verify = true

  boot_iso {
    iso_file = "${var.proxmox_iso_storage}:iso/${var.iso_name}"
    unmount  = true
  }

  boot_command = [
    "boot -s<enter>",
    "<wait10><wait10>",
    "S<enter><wait>",
    "dhclient -l /tmp/dhclient.lease.em0 em0<enter><wait><wait><wait>",
    "ftp -o install.conf http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.install_path} && install -af install.conf && ",
    "echo \"permit nopass keepenv :wheel\" > /mnt/etc/doas.conf && reboot<enter>",
  ]
  boot_wait        = "5s"
  http_directory   = var.http_directory
  os               = "other"
  cores            = var.cpus
  sockets          = 1
  memory           = var.memory
  scsi_controller  = "virtio-scsi-single"

  disks {
    type         = "scsi"
    disk_size    = "${var.disk_size}M"
    storage_pool = var.proxmox_storage_pool
  }

  network_adapters {
    model  = "virtio"
    bridge = var.proxmox_network_bridge
  }

  ssh_username         = var.ssh_username
  ssh_password         = var.ssh_password
  ssh_timeout          = "10000s"
  shutdown_command     = "doas shutdown -p now"
  template_name        = var.vm_name
}
