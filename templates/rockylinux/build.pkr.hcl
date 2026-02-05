build {
  // To use cloud builders, uncomment the desired source and provide
  // the required credentials in your .pkrvars.hcl file.
  sources = [
    "source.vmware-iso.rockylinux",
    "source.virtualbox-iso.rockylinux",
    "source.parallels-iso.rockylinux",
    // "source.proxmox-iso.rockylinux",
    // "source.amazon-ebs.rockylinux",
    // "source.azure-arm.rockylinux",
  ]

  # Phase 1: Update (may trigger reboot)
  provisioner "shell" {
    environment_vars = [
      "CLEANUP_BUILD_TOOLS=${var.cleanup_build_tools}",
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
    execute_command   = "echo 'vagrant' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    expect_disconnect = true
    scripts           = ["scripts/bash/centos/update.sh"]
  }

  # Phase 2: Configuration (after reboot)
  provisioner "shell" {
    environment_vars = [
      "CLEANUP_BUILD_TOOLS=${var.cleanup_build_tools}",
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
    execute_command = "echo 'vagrant' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    pause_before    = "10s"
    scripts = [
      "scripts/bash/centos/fix-slow-dns.sh",
      "scripts/bash/centos/sshd.sh",
      "scripts/bash/centos/vagrant.sh",
      "scripts/bash/centos/desktop.sh",
      "scripts/bash/centos/vmware.sh",
      "scripts/bash/centos/virtualbox.sh",
      "scripts/bash/centos/parallels.sh",
      "scripts/bash/centos/motd.sh",
      "scripts/bash/centos/cleanup.sh",
    ]
  }
}
