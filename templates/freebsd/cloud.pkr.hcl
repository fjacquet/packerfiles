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

source "proxmox-iso" "freebsd" {
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
    "<esc><wait>",
    "boot -s<wait>",
    "<enter><wait>",
    "<wait10><wait10>",
    "/bin/sh<enter><wait>",
    "mdmfs -s 100m md1 /tmp<enter><wait>",
    "mdmfs -s 100m md2 /mnt<enter><wait>",
    "dhclient -l /tmp/dhclient.lease.em0 em0<enter><wait>",
    "fetch -o /tmp/installerconfig http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.install_path} && bsdinstall script /tmp/installerconfig<enter><wait>",
  ]
  boot_wait       = "5s"
  http_directory  = var.http_directory
  os              = "other"
  cores           = var.cpus
  sockets         = 1
  memory          = var.memory
  scsi_controller = "virtio-scsi-single"

  disks {
    type         = "scsi"
    disk_size    = "${var.disk_size}M"
    storage_pool = var.proxmox_storage_pool
  }

  network_adapters {
    model  = "virtio"
    bridge = var.proxmox_network_bridge
  }

  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_timeout      = "10000s"
  shutdown_command = "echo '${var.ssh_password}' | su -m root -c 'shutdown -p now'"
  template_name    = var.vm_name
}
