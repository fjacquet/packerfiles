build {
  sources = [
    "source.vmware-iso.esxi",
    // "source.proxmox-iso.esxi",
  ]

  provisioner "file" {
    source      = "scripts/bash/common/vagrant.pub"
    destination = "/etc/ssh/keys-root/authorized_keys"
  }

  provisioner "shell" {
    scripts = [
      "scripts/bash/esxi/network.sh",
      "scripts/bash/esxi/dvfilter.sh",
    ]
  }

  provisioner "file" {
    source      = "scripts/bash/esxi/vnic-fix.sh"
    destination = "/etc/rc.local.d/local.sh"
  }

  provisioner "shell" {
    script = "scripts/bash/esxi/cleanup.sh"
  }
}
