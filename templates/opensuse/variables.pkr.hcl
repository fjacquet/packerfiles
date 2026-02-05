// VM Configuration
variable "vm_name" {
  type    = string
  default = "opensuse-leap16"
}

variable "cpus" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 2048
}

variable "disk_size" {
  type    = number
  default = 65536
}

variable "headless" {
  type    = bool
  default = true
}

// ISO Configuration
variable "iso_url" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "iso_name" {
  type    = string
  default = ""
}

variable "iso_path" {
  type    = string
  default = "iso"
}

// Install Configuration
variable "http_directory" {
  type    = string
  default = "http/opensuse"
}

variable "agama_profile" {
  type    = string
  default = "autoinst.json"
}

variable "shutdown_command" {
  type    = string
  default = "echo 'vagrant' | sudo -S shutdown -P now"
}

// SSH Configuration
variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "ssh_password" {
  type      = string
  default   = "vagrant"
  sensitive = true
}

// Provisioning Options
variable "update" {
  type    = string
  default = "false"
}

variable "install_vagrant_key" {
  type    = string
  default = "true"
}

variable "cleanup_build_tools" {
  type    = string
  default = "false"
}

// Guest OS Types
variable "vmware_guest_os_type" {
  type    = string
  default = "opensuse-64"
}

variable "virtualbox_guest_os_type" {
  type    = string
  default = "OpenSUSE_64"
}

variable "parallels_guest_os_type" {
  type    = string
  default = "suse"
}

variable "virtualbox_paravirtprovider" {
  type    = string
  default = "default"
}

variable "virtualbox_nictype" {
  type    = string
  default = "virtio"
}

// Proxy Configuration
variable "http_proxy" {
  type    = string
  default = env("http_proxy")
}

variable "https_proxy" {
  type    = string
  default = env("https_proxy")
}

variable "ftp_proxy" {
  type    = string
  default = env("ftp_proxy")
}

variable "rsync_proxy" {
  type    = string
  default = env("rsync_proxy")
}

variable "no_proxy" {
  type    = string
  default = env("no_proxy")
}
