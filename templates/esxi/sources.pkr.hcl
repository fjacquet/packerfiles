source "vmware-iso" "esxi" {
  boot_command = [
    "<enter><wait>O<wait> ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>",
  ]
  boot_wait        = "5s"
  disk_size        = var.disk_size
  disk_type_id     = 0
  guest_os_type    = var.guest_os_type
  headless         = var.headless
  http_directory   = "http/esxi"
  iso_checksum     = var.iso_checksum
  iso_url          = var.iso_url
  output_directory = "output-${var.vm_name}-vmware-iso"
  shutdown_command = var.shutdown_command
  ssh_password     = var.ssh_password
  ssh_username     = var.ssh_username
  ssh_timeout      = "60m"
  version          = 13
  vm_name          = var.vm_name
  vmdk_name        = "vmware-esxi-disk0"
  vmx_data = {
    "ethernet0.virtualDev" = "vmxnet3"
    "memsize"              = "4096"
    "numvcpus"             = "2"
    "vhv.enable"           = "TRUE"
  }
}
