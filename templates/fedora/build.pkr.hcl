build {
  sources = [
    "source.vmware-iso.fedora",
    "source.virtualbox-iso.fedora",
    "source.parallels-iso.fedora",
  ]

  provisioner "shell" {
    environment_vars = [
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
    execute_command   = "echo 'vagrant' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    expect_disconnect = true
    scripts = [
      "scripts/bash/fedora/sshd.sh",
      "scripts/bash/fedora/update.sh",
      "scripts/bash/fedora/vagrant.sh",
      "scripts/bash/fedora/virtualbox.sh",
      "scripts/bash/fedora/parallels.sh",
      "scripts/bash/fedora/cleanup.sh",
    ]
  }
}
