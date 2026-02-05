vm_name      = "debian-11"
cpus         = 1
memory       = 1024
disk_size    = 65536
iso_checksum = "sha256:cd5b2a6fc22050affa1d141adb3857af07e94ff886dca1ce17214e2761a3b316"
iso_name     = "debian-11.11.0-amd64-netinst.iso"
iso_url      = "https://cdimage.debian.org/cdimage/archive/11.11.0/amd64/iso-cd/debian-11.11.0-amd64-netinst.iso"

http_directory = "http/debian"
preseed        = "preseed.cfg"

vmware_guest_os_type     = "debian11-64"
virtualbox_guest_os_type = "Debian_64"
parallels_guest_os_type  = "debian"
