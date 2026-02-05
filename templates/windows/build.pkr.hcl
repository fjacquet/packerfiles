build {
  // To include Amazon EBS, uncomment the line below and provide
  // aws_access_key, aws_secret_key, aws_source_ami in your .pkrvars.hcl
  sources = [
    "source.vmware-iso.windows",
    "source.virtualbox-iso.windows",
    "source.parallels-iso.windows",
    // "source.amazon-ebs.windows",
    // "source.proxmox-iso.windows",
    // "source.azure-arm.windows",
  ]

  provisioner "shell" {
    environment_vars = [
      "UPDATE=${var.update}",
    ]
    execute_command = "{{.Vars}} cmd /c $(/bin/cygpath -m '{{.Path}}')"
    remote_path     = "C:/Windows/Temp/script.bat"
    scripts         = var.scripts
  }

  provisioner "shell" {
    inline = ["rm -f /cygdrive/c/Windows/Temp/script.bat"]
  }
}
