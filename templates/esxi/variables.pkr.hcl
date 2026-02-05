// VM Configuration
variable "vm_name" {
  type    = string
  default = "esxi"
}

variable "disk_size" {
  type    = number
  default = 40960
}

variable "headless" {
  type    = bool
  default = false
}

// ISO Configuration
variable "iso_url" {
  type = string
}

variable "iso_checksum" {
  type = string
}

// ESXi Configuration
variable "guest_os_type" {
  type    = string
  default = "vmkernel65"
}

variable "shutdown_command" {
  type    = string
  default = "esxcli system maintenanceMode set -e true -t 0 ; esxcli system shutdown poweroff -d 10 -r 'Packer Shutdown' ; esxcli system maintenanceMode set -e false -t 0"
}

// SSH Configuration
variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ssh_password" {
  type      = string
  default   = "vagrant"
  sensitive = true
}
