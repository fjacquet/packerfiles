// =============================================================================
// Cloud Builder Variables
// =============================================================================

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

// Amazon EBS Configuration
variable "aws_access_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_instance_type" {
  type    = string
  default = "t3.small"
}

variable "aws_source_ami" {
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

// =============================================================================
// Cloud Builder Sources
// =============================================================================

source "proxmox-iso" "ubuntu" {
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_username
  token                    = var.proxmox_token
  node                     = var.proxmox_node
  insecure_skip_tls_verify = true

  boot_iso {
    iso_file = "${var.proxmox_iso_storage}:iso/${var.iso_name}"
    unmount  = true
  }

  boot_command     = var.boot_command
  boot_wait        = "5s"
  os               = "l26"
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

  http_directory = var.http_directory
  ssh_username   = var.ssh_username
  ssh_password   = var.ssh_password
  ssh_timeout    = "10000s"
  template_name  = var.vm_name
}

source "amazon-ebs" "ubuntu" {
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  region        = var.aws_region
  source_ami    = var.aws_source_ami
  instance_type = var.aws_instance_type
  ssh_username  = "ubuntu"
  ami_name      = "${var.vm_name}-{{timestamp}}"
}

source "azure-arm" "ubuntu" {
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
  location        = var.azure_location

  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts"
  os_type         = "Linux"
  vm_size         = "Standard_B2s"

  managed_image_name                = var.azure_managed_image_name
  managed_image_resource_group_name = var.azure_managed_image_resource_group_name

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
}
