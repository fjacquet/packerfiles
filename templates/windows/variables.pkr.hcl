// VM Configuration
variable "vm_name" {
  type    = string
  default = "windows"
}

variable "cpus" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 4096
}

variable "disk_size" {
  type    = number
  default = 81920
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

// Floppy Configuration
variable "autounattend_dir" {
  type        = string
  description = "Directory containing Autounattend.xml (e.g., floppy/eval-win2016-standard)"
  default     = "floppy/eval-win2016-standard"
}

variable "floppy_files" {
  type = list(string)
  default = [
    "floppy/00-run-all-scripts.cmd",
    "floppy/install-winrm.cmd",
    "floppy/powerconfig.bat",
    "floppy/01-install-wget.cmd",
    "floppy/_download.cmd",
    "floppy/_packer_config.cmd",
    "floppy/passwordchange.bat",
    "floppy/cygwin.bat",
    "floppy/cygwin.sh",
    "floppy/disablewinupdate.bat",
    "floppy/unzip.vbs",
    "floppy/zz-start-transports.cmd",
  ]
}

// Shutdown
variable "shutdown_command" {
  type    = string
  default = "shutdown /s /t 10 /f /d p:4:1 /c 'Packer Shutdown'"
}

// Provisioning Scripts
variable "scripts" {
  type = list(string)
  default = [
    "scripts/batch/vagrant.bat",
    "scripts/batch/cmtool.bat",
    "scripts/batch/vmtool.bat",
    "scripts/batch/clean.bat",
    "scripts/batch/ultradefrag.bat",
    "scripts/batch/uninstall-7zip.bat",
    "scripts/batch/sdelete.bat",
  ]
}

variable "update" {
  type    = string
  default = "true"
}

// Guest OS Types
variable "vmware_guest_os_type" {
  type    = string
  default = "windows8srv-64"
}

variable "virtualbox_guest_os_type" {
  type    = string
  default = "Windows2016_64"
}

variable "parallels_guest_os_type" {
  type    = string
  default = "win-2016"
}

// Amazon EBS (optional)
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
  default = "t2.micro"
}

variable "aws_source_ami" {
  type    = string
  default = ""
}

variable "aws_ssh_username" {
  type    = string
  default = "ec2-user"
}

variable "aws_vpc_id" {
  type    = string
  default = ""
}

variable "aws_subnet_id" {
  type    = string
  default = ""
}

variable "ssh_keypair_name" {
  type    = string
  default = ""
}
