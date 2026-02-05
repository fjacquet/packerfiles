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

// Additional variable needed for Proxmox ISO reference
variable "iso_name" {
  type    = string
  default = ""
}

// Azure Configuration
variable "azure_subscription_id" {
  type    = string
  default = ""
}

variable "azure_client_id" {
  type    = string
  default = ""
}

variable "azure_client_secret" {
  type      = string
  default   = ""
  sensitive = true
}

variable "azure_tenant_id" {
  type    = string
  default = ""
}

variable "azure_location" {
  type    = string
  default = "westeurope"
}

variable "azure_managed_image_name" {
  type    = string
  default = ""
}

variable "azure_managed_image_resource_group_name" {
  type    = string
  default = ""
}

source "proxmox-iso" "windows" {
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_username
  token                    = var.proxmox_token
  node                     = var.proxmox_node
  insecure_skip_tls_verify = true

  boot_iso {
    iso_file = "${var.proxmox_iso_storage}:iso/${var.iso_name}"
    unmount  = true
  }

  os               = "win11"
  bios             = "ovmf"
  machine          = "q35"
  cores            = var.cpus
  sockets          = 1
  memory           = var.memory
  scsi_controller  = "virtio-scsi-single"
  floppy_files     = local.floppy_base

  disks {
    type         = "scsi"
    disk_size    = "${var.disk_size}M"
    storage_pool = var.proxmox_storage_pool
  }

  network_adapters {
    model  = "virtio"
    bridge = var.proxmox_network_bridge
  }

  ssh_username         = "vagrant"
  ssh_password         = "vagrant"
  ssh_timeout          = "10000s"
  shutdown_command     = var.shutdown_command
  template_name        = var.vm_name
}

source "azure-arm" "windows" {
  subscription_id                   = var.azure_subscription_id
  client_id                         = var.azure_client_id
  client_secret                     = var.azure_client_secret
  tenant_id                         = var.azure_tenant_id
  location                          = var.azure_location
  managed_image_name                = var.azure_managed_image_name
  managed_image_resource_group_name = var.azure_managed_image_resource_group_name

  os_type         = "Windows"
  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2022-datacenter"
  vm_size         = "Standard_DS2_v2"

  communicator   = "winrm"
  winrm_username = "packer"
  winrm_insecure = true
  winrm_use_ssl  = true
}
