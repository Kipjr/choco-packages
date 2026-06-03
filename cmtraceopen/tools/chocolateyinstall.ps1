$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/adamgell/cmtraceopen/releases/download/v1.3.2/CMTrace-Open_1.3.2_x64.msi'


$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  softwareName  = 'CMTrace Open'
  checksum      = ''
  checksumType  = 'sha256'
  validExitCodes= @(0)
  silentArgs   = '/S'
}

Install-ChocolateyPackage @packageArgs
