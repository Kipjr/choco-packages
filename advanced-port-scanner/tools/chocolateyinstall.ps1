$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.advanced-port-scanner.com/download/files/Advanced_Port_Scanner_2.5.3869.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  softwareName  = 'advanced-port-scanner*'
  checksum      = 'D0C1662CE239E4D288048C0E3324EC52962F6DDDA77DA0CB7AF9C1D9C2F1E2EB'
  checksumType  = 'sha256'
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /INSTALLDESKTOPSHORTCUT=NO'
  validExitCodes= @(0)
}
Install-ChocolateyPackage @packageArgs

# Silent installer autostart app. Killing this behaviour using the code below
$t = 0
DO
{
	start-Sleep -Milliseconds 100 #wait 100ms / loop
	$t++ #increase iteration 
} Until (($p=Get-Process -Name advanced_port_scanner -ErrorAction SilentlyContinue)-ne $null -or ($t -gt 100)) #wait until process is found or timeout reached
if($p) { #if process is found
	$p |Stop-Process  -Force #kill process 
	"Killing APS process"|write-output
}else {
	"Exceeded timeout to kill APS process"|write-output	 #no process found but timeout reached
}
