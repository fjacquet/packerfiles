build {
  sources = [
    "source.vmware-iso.freebsd",
    "source.virtualbox-iso.freebsd",
    "source.parallels-iso.freebsd",
    // "source.proxmox-iso.freebsd",
  ]

  provisioner "file" {
    source      = "scripts/bash/common/vagrant.pub"
    destination = "/tmp/vagrant.pub"
  }

  provisioner "shell" {
    environment_vars = [
      "HOSTNAME=${var.vm_name}",
      "UPDATE=${var.update}",
      "INSTALL_VAGRANT_KEY=${var.install_vagrant_key}",
      "SSH_USERNAME=${var.ssh_username}",
      "SSH_PASSWORD=${var.ssh_password}",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "ftp_proxy=${var.ftp_proxy}",
      "rsync_proxy=${var.rsync_proxy}",
      "no_proxy=${var.no_proxy}",
    ]
    execute_command = "echo '${var.ssh_password}' | {{.Vars}} su -m root -c 'sh -eux {{.Path}}'"
    scripts = [
      "scripts/bash/bsd/freebsd/update.sh",
      "scripts/bash/bsd/freebsd/postinstall.sh",
      "scripts/bash/bsd/freebsd/vagrant.sh",
      "scripts/bash/bsd/freebsd/vmware.sh",
      "scripts/bash/bsd/freebsd/virtualbox.sh",
      "scripts/bash/bsd/parallels.sh",
      "scripts/bash/bsd/motd.sh",
      "scripts/bash/bsd/freebsd/cleanup.sh",
      "scripts/bash/bsd/freebsd/minimize.sh",
    ]
  }
}
