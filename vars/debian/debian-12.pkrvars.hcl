vm_name      = "debian-12"
cpus         = 2
memory       = 2048
disk_size    = 65536
iso_checksum = "sha256:1257373c706d8c07e6917942736a865dfff557d21d76ea3040bb1039eb72a054"
iso_name     = "debian-12.9.0-amd64-netinst.iso"
iso_url      = "https://cdimage.debian.org/cdimage/archive/12.9.0/amd64/iso-cd/debian-12.9.0-amd64-netinst.iso"

http_directory = "http/debian"
preseed        = "preseed-bookworm.cfg"

vmware_guest_os_type     = "debian12-64"
virtualbox_guest_os_type = "Debian_64"
parallels_guest_os_type  = "debian"
