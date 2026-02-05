build {
  sources = [
    "source.vmware-iso.dragonflybsd",
    "source.virtualbox-iso.dragonflybsd",
    "source.parallels-iso.dragonflybsd",
    // "source.proxmox-iso.dragonflybsd",
  ]

  provisioner "shell" {
    environment_vars = [
      "HOSTNAME=${var.vm_name}",
      "UPDATE=${var.update}",
      "INSTALL_VAGRANT_KEY=${var.install_vagrant_key}",
      "SSH_USERNAME=vagrant",
      "SSH_PASSWORD=${var.ssh_password}",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "no_proxy=${var.no_proxy}",
    ]
    execute_command = "{{.Vars}} sudo -E sh -eux '{{.Path}}'"
    scripts = [
      "scripts/bash/bsd/dragonflybsd/update.sh",
      "scripts/bash/bsd/dragonflybsd/ntp.sh",
      "scripts/bash/bsd/freebsd/postinstall.sh",
      "scripts/bash/bsd/freebsd/vagrant.sh",
      "scripts/bash/bsd/virtualbox.sh",
      "scripts/bash/bsd/vmware.sh",
      "scripts/bash/bsd/motd.sh",
      "scripts/bash/bsd/dragonflybsd/cleanup.sh",
      "scripts/bash/bsd/dragonflybsd/minimize.sh",
    ]
  }
}
