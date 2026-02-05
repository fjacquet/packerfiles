build {
  // To use cloud builders, uncomment the desired source and provide
  // the required credentials in your .pkrvars.hcl file.
  sources = [
    "source.vmware-iso.opensuse",
    "source.virtualbox-iso.opensuse",
    "source.parallels-iso.opensuse",
    // "source.proxmox-iso.opensuse",
    // "source.amazon-ebs.opensuse",
    // "source.azure-arm.opensuse",
  ]

  # Phase 1: Update (may trigger reboot)
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
    scripts           = ["scripts/bash/opensuse/update.sh"]
  }

  # Phase 2: Configuration (after reboot)
  provisioner "shell" {
    environment_vars = [
      "INSTALL_VAGRANT_KEY=${var.install_vagrant_key}",
      "SSH_USERNAME=${var.ssh_username}",
      "SSH_PASSWORD=${var.ssh_password}",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "ftp_proxy=${var.ftp_proxy}",
      "rsync_proxy=${var.rsync_proxy}",
      "no_proxy=${var.no_proxy}",
    ]
    execute_command = "echo 'vagrant' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    pause_before    = "10s"
    scripts = [
      "scripts/bash/opensuse/sshd.sh",
      "scripts/bash/opensuse/vagrant.sh",
      "scripts/bash/opensuse/vmware.sh",
      "scripts/bash/opensuse/virtualbox.sh",
      "scripts/bash/opensuse/parallels.sh",
      "scripts/bash/opensuse/cleanup.sh",
    ]
  }
}
