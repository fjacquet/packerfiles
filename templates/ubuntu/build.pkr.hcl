build {
  sources = [
    "source.vmware-iso.ubuntu",
    "source.virtualbox-iso.ubuntu",
    "source.parallels-iso.ubuntu",
  ]

  provisioner "shell" {
    environment_vars = [
      "CLEANUP_PAUSE=${var.cleanup_pause}",
      "DESKTOP=${var.desktop}",
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
    execute_command   = "echo '${var.ssh_password}' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    expect_disconnect = true
    scripts = [
      "scripts/bash/ubuntu/update.sh",
      "scripts/bash/ubuntu/desktop.sh",
      "scripts/bash/ubuntu/vagrant.sh",
      "scripts/bash/ubuntu/sshd.sh",
      "scripts/bash/ubuntu/vmware.sh",
      "scripts/bash/ubuntu/virtualbox.sh",
      "scripts/bash/ubuntu/parallels.sh",
      "scripts/bash/ubuntu/motd.sh",
      "scripts/bash/ubuntu/minimize.sh",
      "scripts/bash/ubuntu/cleanup.sh",
    ]
  }
}
