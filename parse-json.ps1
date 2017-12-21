
$Current = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ScriptPath = "$($Current)/"
Write-Host $ScriptPath
$referencefile = "$($ScriptPath)windows.json"
Write-Host $referencefile
function arrayToString {
  param([string[]]$array)

  $value = ""
  foreach ($item in $array) {
    $value = "$value,$item"
  }
  $value = $value.substring(1)
  return $value
}


function migrateToVariables {
  param($reference,$from,$to)

  $json = Get-Content -Raw -Path $reference | ConvertFrom-Json
  $variables = $json.variables
  $config = New-Object -TypeName PSObject -Property @{
    aws_access_key = ""
    aws_instance_type = ""
    aws_region = ""
    aws_secret_key = ""
    aws_source_ami = ""
    aws_ssh_username = ""
    aws_subnet_id = ""
    aws_vpc_id = ""
    cm = ""
    cm_version = ""
    cpus = ""
    disk_size = ""
    floppy_files_vmware = ""
    floppy_files_virtualbox = ""
    floppy_files_parallels = ""
    guest_os_type_parallel = ""
    guest_os_type_virtualbox = ""
    guest_os_type_vmware = ""
    headless = ""
    is_ssd = ""
    iso_checksum = ""
    iso_url = ""
    iso_checksum_type = ""
    memory_size = ""
    scripts_files = ""
    shutdown_command = ""
    update = ""
    version = ""
    vm_name = ""
  }
  $config.aws_access_key = $variables.aws_access_key
  $config.aws_instance_type = $variables.aws_instance_type
  $config.aws_region = $variables.aws_region
  $config.aws_secret_key = $variables.aws_secret_key
  $config.aws_source_ami = $variables.aws_source_ami
  $config.aws_ssh_username = $variables.aws_ssh_username
  $config.aws_subnet_id = $variables.aws_subnet_id
  $config.aws_vpc_id = $variables.aws_vpc_id
  $config.cm = $variables.cm
  $config.cm_version = $variables.cm_version
  $config.cpus = $variables.cpus
  $config.disk_size = $variables.disk_size
  $config.floppy_files_parallels = $variables.floppy_files_other
  $config.floppy_files_vmware = $variables.floppy_files_other
  $config.floppy_files_virtualbox = $variables.floppy_files_virtualbox
  $config.guest_os_type_parallel = $variables.guest_os_type_parallel
  $config.guest_os_type_virtualbox = $variables.guest_os_type_virtualbox
  $config.guest_os_type_vmware = $variables.guest_os_type_vmware
  $config.headless = $variables.headless
  $config.is_ssd = $variables.is_ssd
  $config.iso_checksum = $variables.iso_checksum
  $config.iso_url = $variables.iso_url
  $config.iso_checksum_type = $variables.iso_checksum_type
  $config.memory_size = $variables.memory_size
  $config.scripts_files = $variables.scripts_files
  $config.shutdown_command = $variables.shutdown_command
  $config.update = $variables.update
  $config.version = $variables.version
  $config.vm_name = $variables.vm_name
  $json = Get-Content -Raw -Path $from | ConvertFrom-Json
  $builders = $json.builders
  foreach ($builder in $builders) {
    if ($builder.type -eq "vmware-iso") {
      $config.guest_os_type_vmware = $builder.guest_os_type
      $config.floppy_files_vmware = arrayToString -array $builder.floppy_files
    }
    elseif ($builder.type -eq "virtualbox-iso") {
      $config.guest_os_type_virtualbox = $builder.guest_os_type
      $config.floppy_files_virtualbox = arrayToString -array $builder.floppy_files
    }
    elseif ($builder.type -eq "parallels-iso") {
      $config.guest_os_type_virtualbox = $builder.guest_os_type
      $config.floppy_files_parallels = arrayToString -array $builder.floppy_files
    }
    else {}
  }
  $provisioners = $json.provisioners
  foreach ($provisioner in $provisioners) {
    # write-host $provisioner."scripts"
    if ($provisioner."scripts" -ne $null) {
      $config.scripts_files = arrayToString -array $provisioner.scripts
    }
  }
  $variables = $json.variables
  foreach ($variable in $variables) {
    $config.cm = $variable.cm
    $config.cm_version = $variable.cm_version
    $config.disk_size = $variable.disk_size
    $config.headless = $variable.headless
    $config.iso_checksum = $variable.iso_checksum
    $config.iso_url = $variable.iso_url
    $config.shutdown_command = $variable.shutdown_command
    $config.update = $variable.update
    $config.version = $variable.version
    $config.vm_name = $variable.vm_name
  }
  $variables = $config
  $solution = New-Object -TypeName PSObject -Property @{
    variables = $config
  }
  ConvertTo-Json -InputObject $solution | Add-Content -Path $to
}

$froms = Get-ChildItem -File -Path $ScriptPath -Filter "*win*.json"
foreach ($from in $froms) {
  $fromfile = "$($ScriptPath)$($from)"
  $tofile = "$($fromfile)-new"
  if ($fromfile -like "windows.json") {}
  else {
    Write-Host "|$referencefile|$fromfile|$tofile|"
    migrateToVariables -reference $referencefile -From $fromfile -To $tofile
  }
}
