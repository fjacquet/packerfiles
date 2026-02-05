build {
  sources = [
    "source.vmware-iso.netbsd",
    "source.virtualbox-iso.netbsd",
    "source.parallels-iso.netbsd",
    // "source.proxmox-iso.netbsd",
  ]

  provisioner "shell" {
    environment_vars = [
      "NETBSD_MIRROR=${var.netbsd_mirror}",
      "INSTALL_VAGRANT_KEY=${var.install_vagrant_key}",
      "SSH_USERNAME=${var.ssh_username}",
      "SSH_PASSWORD=${var.ssh_password}",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "ftp_proxy=${var.ftp_proxy}",
      "rsync_proxy=${var.rsync_proxy}",
      "no_proxy=${var.no_proxy}",
    ]
    execute_command = "{{.Vars}} sudo -E sh -eux '{{.Path}}'"
    scripts = [
      "scripts/bash/bsd/netbsd/setup_pkg.sh",
      "scripts/bash/bsd/netbsd/postinstall.sh",
      "scripts/bash/bsd/vagrant.sh",
      "scripts/bash/bsd/vmware.sh",
      "scripts/bash/bsd/virtualbox.sh",
      "scripts/bash/bsd/parallels.sh",
      "scripts/bash/bsd/motd.sh",
      "scripts/bash/bsd/cleanup.sh",
    ]
  }
}
