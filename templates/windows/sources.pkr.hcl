source "vmware-iso" "windows" {
  disk_size            = var.disk_size
  floppy_files         = local.floppy_base
  guest_os_type        = var.vmware_guest_os_type
  headless             = var.headless
  iso_checksum         = var.iso_checksum
  iso_url              = var.iso_url
  output_directory     = "output-${var.vm_name}-vmware"
  shutdown_command      = var.shutdown_command
  ssh_password         = "vagrant"
  ssh_username         = "vagrant"
  ssh_timeout          = "10000s"
  tools_upload_flavor  = "windows"
  vm_name              = var.vm_name
  vmx_data = {
    "cpuid.coresPerSocket" = "1"
    "memsize"              = var.memory
    "numvcpus"             = var.cpus
    "scsi0.virtualDev"     = "lsisas1068"
  }
}

source "virtualbox-iso" "windows" {
  disk_size               = var.disk_size
  floppy_files            = local.floppy_vbox
  guest_additions_mode    = "attach"
  guest_os_type           = var.virtualbox_guest_os_type
  hard_drive_interface    = "sata"
  hard_drive_nonrotational = true
  headless                = var.headless
  iso_checksum            = var.iso_checksum
  iso_url                 = var.iso_url
  output_directory        = "output-${var.vm_name}-virtualbox"
  post_shutdown_delay     = "30s"
  shutdown_command         = var.shutdown_command
  ssh_password            = "vagrant"
  ssh_username            = "vagrant"
  ssh_timeout             = "10000s"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nictype1", "82540EM"],
    ["modifyvm", "{{.Name}}", "--vram", "48"],
    ["modifyvm", "{{.Name}}", "--cpuhotplug", "on"],
    ["modifyvm", "{{.Name}}", "--pae", "off"],
    ["modifyvm", "{{.Name}}", "--usbxhci", "on"],
    ["modifyvm", "{{.Name}}", "--memory", var.memory],
    ["modifyvm", "{{.Name}}", "--cpus", var.cpus],
    ["setextradata", "{{.Name}}", "VBoxInternal/CPUM/CMPXCHG16B", "1"],
  ]
  vm_name = var.vm_name
}

source "parallels-iso" "windows" {
  disk_size              = var.disk_size
  floppy_files           = local.floppy_base
  guest_os_type          = var.parallels_guest_os_type
  iso_checksum           = var.iso_checksum
  iso_url                = var.iso_url
  output_directory       = "output-${var.vm_name}-parallels"
  parallels_tools_flavor = "win"
  prlctl = [
    ["set", "{{.Name}}", "--memsize", var.memory],
    ["set", "{{.Name}}", "--cpus", var.cpus],
    ["set", "{{.Name}}", "--efi-boot", "off"],
  ]
  shutdown_command = var.shutdown_command
  ssh_password     = "vagrant"
  ssh_username     = "vagrant"
  ssh_timeout      = "10000s"
  vm_name          = var.vm_name
}

source "amazon-ebs" "windows" {
  access_key        = var.aws_access_key
  ami_name          = var.vm_name
  instance_type     = var.aws_instance_type
  region            = var.aws_region
  secret_key        = var.aws_secret_key
  source_ami        = var.aws_source_ami
  ssh_agent_auth    = true
  ssh_keypair_name  = var.ssh_keypair_name
  ssh_username      = var.aws_ssh_username
  subnet_id         = var.aws_subnet_id
  vpc_id            = var.aws_vpc_id
}
