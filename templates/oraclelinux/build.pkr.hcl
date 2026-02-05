build {
  // To use cloud builders, uncomment the desired source and provide
  // the required credentials in your .pkrvars.hcl file.
  sources = [
    "source.vmware-iso.oraclelinux",
    "source.virtualbox-iso.oraclelinux",
    "source.parallels-iso.oraclelinux",
    // "source.proxmox-iso.oraclelinux",
    // "source.amazon-ebs.oraclelinux",
    // "source.azure-arm.oraclelinux",
  ]

  provisioner "shell" {
    environment_vars = [
      "DESKTOP=${var.desktop}",
      "DOCKER=${var.docker}",
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
      "scripts/bash/oracle/fix-slow-dns.sh",
      "scripts/bash/oracle/kernel.sh",
      "scripts/bash/oracle/sshd.sh",
      "scripts/bash/oracle/update.sh",
      "scripts/bash/oracle/vagrant.sh",
      "scripts/bash/oracle/desktop.sh",
      "scripts/bash/oracle/vmware.sh",
      "scripts/bash/oracle/virtualbox.sh",
      "scripts/bash/oracle/parallels.sh",
      "scripts/bash/oracle/motd.sh",
      "scripts/bash/oracle/cleanup.sh",
    ]
  }
}
