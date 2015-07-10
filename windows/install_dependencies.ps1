
function isDirInPath
{
  param([string]$adir,[string]$kind)

  $path = [environment]::GetEnvironmentVariable("PATH", $kind)
  $adirsPath = if($path) {$path.split(";")} else { @() }
  
  $len = $adirsPath.length
  
  $have = $False
  foreach($adirPath in $adirsPath) {
    if($adirPath -eq $adir) {
      $have = $True
    }
  }
  $have
}

function putDirInPath
{
  param([string]$adir, [string]$kind)

  $path = [environment]::GetEnvironmentVariable("PATH", "Machine")
  [System.Environment]::SetEnvironmentVariable("PATH", $path+";"+$adir, $kind)
}

$adir = 'C:\Program Files\Oracle\VirtualBox'
$kind="Machine"
choco install --yes packages.config
putDirInPath -adir $adir -kind "Process"

write '**** Note: the broken virtualbox extension installer will report:'
write ''
write 'Successfully installed Oracle VM VirtualBox Extension Pack.'
write '0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%'
write 'WARNING: Write-ChocolateySuccess is deprecated. If you are the maintainer, please remove it from your package file.'
write 'The install of virtualbox.extensionpack was NOT successful.'
write 'Error while running C:\ProgramData\chocolatey\lib\VirtualBox.ExtensionPack\tools\chocolateyInstall.ps1.'
write 'See log for details.'
write ''
write 'Chocolatey installed 0/1 package(s). 1 package(s) failed.'
write ''

choco install --yes --force packages2.config

if(-not (isDirInPath -adir $adir -kind $kind)) {
  write "Adding $adir to system path"
  putDirInPath -adir $adir -kind $kind
}
else {
  write "Detected $adir already in system path"
}

