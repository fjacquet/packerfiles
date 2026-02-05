// VM Configuration
variable "vm_name" {
  type    = string
  default = "freebsd"
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

// Install Configuration
variable "http_directory" {
  type    = string
  default = "http/bsd"
}

variable "install_path" {
  type    = string
  default = "installerconfig.freebsd"
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

// Guest OS Types
variable "vmware_guest_os_type" {
  type    = string
  default = "freebsd-64"
}

variable "virtualbox_guest_os_type" {
  type    = string
  default = "FreeBSD_64"
}

variable "parallels_guest_os_type" {
  type    = string
  default = "freebsd"
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
