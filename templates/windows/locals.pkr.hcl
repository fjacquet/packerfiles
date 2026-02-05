// Build the floppy file lists dynamically.
// VirtualBox gets an extra oracle-cert.cer file.
locals {
  autounattend = "${var.autounattend_dir}/Autounattend.xml"
  floppy_base  = concat([local.autounattend], var.floppy_files)
  floppy_vbox  = concat(local.floppy_base, ["floppy/oracle-cert.cer"])
}
