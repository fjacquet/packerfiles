vm_name      = "ubuntu-2204"
cpus         = 2
memory       = 2048
disk_size    = 65536
iso_checksum = "sha256:9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
iso_name     = "ubuntu-22.04.5-live-server-amd64.iso"
iso_url      = "https://releases.ubuntu.com/jammy/ubuntu-22.04.5-live-server-amd64.iso"

# Ubuntu 22.04+ uses autoinstall (cloud-init) via HTTP server
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
