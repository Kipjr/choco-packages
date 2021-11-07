$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/thomasnordquist/MQTT-Explorer/releases/download/0.0.0-0.4.0-beta1/MQTT-Explorer-Setup-0.4.0-beta1.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  softwareName  = 'MQTT Explorer 0.4.0-beta1'
  checksum      = '6DADADA22FFA172DE337CA5F2C8FFDF2887B104A65DC1E06D557811D1D8448ED'
  checksumType  = 'sha256'
  validExitCodes= @(0)
  silentArgs   = '/S'
}

Install-ChocolateyPackage @packageArgs