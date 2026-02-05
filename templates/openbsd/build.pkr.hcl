build {
  sources = [
    "source.vmware-iso.openbsd",
    "source.virtualbox-iso.openbsd",
    "source.parallels-iso.openbsd",
  ]

  provisioner "shell" {
    environment_vars = [
      "UPDATE=${var.update}",
      "OPENBSD_MIRROR=${var.openbsd_mirror}",
      "INSTALL_VAGRANT_KEY=${var.install_vagrant_key}",
      "SSH_USERNAME=${var.ssh_username}",
      "SSH_PASSWORD=${var.ssh_password}",
      "HOSTNAME=${var.vm_name}",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "ftp_proxy=${var.ftp_proxy}",
      "rsync_proxy=${var.rsync_proxy}",
      "no_proxy=${var.no_proxy}",
    ]
    execute_command = "{{.Vars}} doas -u root sh -eux {{.Path}}"
    scripts = [
      "scripts/bash/bsd/openbsd/setup_pkg.sh",
      "scripts/bash/bsd/update.sh",
      "scripts/bash/bsd/openbsd/postinstall.sh",
      "scripts/bash/bsd/vagrant.sh",
      "scripts/bash/bsd/vmware.sh",
      "scripts/bash/bsd/virtualbox.sh",
      "scripts/bash/bsd/parallels.sh",
      "scripts/bash/bsd/cleanup.sh",
    ]
  }
}
