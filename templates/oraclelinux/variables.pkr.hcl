// VM Configuration
variable "vm_name" {
  type    = string
  default = "oraclelinux"
}

variable "cpus" {
  type    = number
  default = 1
}

variable "memory" {
  type    = number
  default = 512
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

// Kickstart Configuration
variable "http_directory" {
  type    = string
  default = "http/oracle/9-server"
}

variable "kickstart" {
  type    = string
  default = "ks.cfg"
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

variable "desktop" {
  type    = string
  default = "false"
}

variable "docker" {
  type    = string
  default = "false"
}

variable "install_vagrant_key" {
  type    = string
  default = "true"
}

// Guest OS Types
variable "vmware_guest_os_type" {
  type    = string
  default = "oraclelinux-64"
}

variable "virtualbox_guest_os_type" {
  type    = string
  default = "Oracle_64"
}

variable "parallels_guest_os_type" {
  type    = string
  default = "rhel"
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
