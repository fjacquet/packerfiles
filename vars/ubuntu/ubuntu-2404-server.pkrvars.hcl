vm_name      = "ubuntu-2404"
cpus         = 2
memory       = 2048
disk_size    = 65536
iso_checksum = "sha256:d6dab0c3a657988501b4bd76f1297c053df710e06e0c3aece60dead24f270b4d"
iso_name     = "ubuntu-24.04.2-live-server-amd64.iso"
iso_url      = "https://releases.ubuntu.com/noble/ubuntu-24.04.2-live-server-amd64.iso"

# Ubuntu 24.04 uses autoinstall (cloud-init) via HTTP server
http_directory = "http/ubuntu"

boot_command = [
  "c<wait5>",
  "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"",
  "<enter><wait5>",
  "initrd /casper/initrd",
  "<enter><wait5>",
  "boot",
  "<enter>",
]

vmware_guest_os_type     = "ubuntu-64"
virtualbox_guest_os_type = "Ubuntu_64"
parallels_guest_os_type  = "ubuntu"
