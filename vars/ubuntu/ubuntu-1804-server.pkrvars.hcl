vm_name      = "ubuntu-1804"
cpus         = 1
memory       = 512
disk_size    = 65536
iso_checksum = "sha256:a7f5c7b0cdd0e9560d78f1e47660e066353bb8a79eb78d1fc3f4ea62a07e6cbc"
iso_name     = "ubuntu-18.04-server-amd64.iso"
iso_url      = "https://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04-server-amd64.iso"
preseed      = "ubuntu/preseed.cfg"

boot_command = [
  "<esc><esc><enter><wait>",
  "/install/vmlinuz noapic ",
  "file=/floppy/ubuntu/preseed.cfg ",
  "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
  "hostname=vagrant ",
  "grub-installer/bootdev=/dev/sda<wait> ",
  "fb=false debconf/frontend=noninteractive ",
  "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ",
  "keyboard-configuration/variant=USA console-setup/ask_detect=false ",
  "passwd/user-fullname=vagrant ",
  "passwd/user-password=vagrant ",
  "passwd/user-password-again=vagrant ",
  "passwd/username=vagrant ",
  "initrd=/install/initrd.gz -- <enter>",
]

vmware_guest_os_type     = "ubuntu-64"
virtualbox_guest_os_type = "Ubuntu_64"
parallels_guest_os_type  = "ubuntu"
