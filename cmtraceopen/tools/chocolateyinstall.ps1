$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/adamgell/cmtraceopen/releases/download/v1.5.2/CMTrace-Open_1.5.2_x64.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  softwareName  = 'cmtraceopen*'
  checksum      = '0b08c9a94fb5e2afb6b20f5349562c5382fc4ef56e93163a278af38c99e723cd'
  checksumType  = 'sha256'
  silentArgs   = ''
  validExitCodes= @(0)
}
Install-ChocolateyPackage @packageArgs

