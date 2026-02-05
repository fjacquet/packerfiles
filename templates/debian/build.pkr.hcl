build {
  // To use cloud builders, uncomment the desired source and provide
  // the required credentials in your .pkrvars.hcl file.
  sources = [
    "source.vmware-iso.debian",
    "source.virtualbox-iso.debian",
    "source.parallels-iso.debian",
    // "source.proxmox-iso.debian",
    // "source.amazon-ebs.debian",
    // "source.azure-arm.debian",
  ]

  provisioner "shell" {
    environment_vars = [
      "DESKTOP=${var.desktop}",
      "REMOVE_DOCS=${var.remove_docs}",
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
    pause_before      = "10s"
    scripts = [
      "scripts/bash/debian/remove-cdrom-sources.sh",
      "scripts/bash/debian/systemd.sh",
      "scripts/bash/debian/update.sh",
      "scripts/bash/debian/desktop.sh",
      "scripts/bash/debian/vagrant.sh",
      "scripts/bash/debian/vmware.sh",
      "scripts/bash/debian/virtualbox.sh",
      "scripts/bash/debian/parallels.sh",
      "scripts/bash/debian/motd.sh",
      "scripts/bash/debian/minimize.sh",
      "scripts/bash/debian/cleanup.sh",
    ]
  }
}
