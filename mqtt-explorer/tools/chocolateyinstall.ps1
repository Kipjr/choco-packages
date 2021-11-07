$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/thomasnordquist/MQTT-Explorer/releases/download/v0.3.5/MQTT-Explorer-Setup-0.3.5.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  softwareName  = 'MQTT Explorer 0.3.5'
  checksum      = 'B7DB576BE4433761309074625DA0E297D25A48CB06B964C3BCD3C4DF65857F56'
  checksumType  = 'sha256'
  validExitCodes= @(0)
  silentArgs   = '/S'
}

Install-ChocolateyPackage @packageArgs