// VM Configuration
variable "vm_name" {
  type        = string
  default     = "ubuntu"
  description = "Name of the VM and output artifact"
}

variable "cpus" {
  type    = number
  default = 1
}

variable "memory" {
  type    = number
  default = 1024
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
  type        = string
  description = "URL to download the installation ISO"
}

variable "iso_checksum" {
  type        = string
  description = "ISO checksum with algorithm prefix (e.g. sha256:abc123)"
}

variable "iso_name" {
  type    = string
  default = ""
}

variable "iso_path" {
  type    = string
  default = "iso"
}

// Boot Configuration
variable "boot_command" {
  type        = list(string)
  description = "Boot command sequence for the installer"
}

// Installation Configuration
variable "http_directory" {
  type    = string
  default = "http"
}

variable "preseed" {
  type        = string
  default     = ""
  description = "Path to preseed file relative to http_directory (legacy installs)"
}

variable "locale" {
  type    = string
  default = "en_US"
}

variable "hostname" {
  type    = string
  default = "vagrant"
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

variable "ssh_fullname" {
  type    = string
  default = "vagrant"
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

variable "install_vagrant_key" {
  type    = string
  default = "true"
}

variable "cleanup_pause" {
  type    = string
  default = ""
}

// Guest OS Types
variable "vmware_guest_os_type" {
  type    = string
  default = "ubuntu-64"
}

variable "virtualbox_guest_os_type" {
  type    = string
  default = "Ubuntu_64"
}

variable "parallels_guest_os_type" {
  type    = string
  default = "ubuntu"
}

// Proxy Configuration (from environment)
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
