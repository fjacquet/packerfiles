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

// Additional variables needed for Proxmox (not in base ESXi template)
variable "iso_name" {
  type    = string
  default = ""
}

variable "cpus" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 4096
}

source "proxmox-iso" "esxi" {
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
    "<enter><wait>O<wait> ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>",
  ]
  boot_wait        = "5s"
  http_directory   = "http/esxi"
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
  ssh_timeout          = "60m"
  shutdown_command     = var.shutdown_command
  template_name        = var.vm_name
}
