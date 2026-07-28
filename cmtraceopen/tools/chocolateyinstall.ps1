$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/adamgell/cmtraceopen/releases/download/v1.5.0/CMTrace-Open_1.5.0_x64.msi'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  softwareName  = 'CMTrace Open'
  checksum      = '2539c0e0f6838541f8c7cd35e63dcec0efba210a6732fe2d9595a759ce02a437'
  checksumType  = 'sha256'
  validExitCodes= @(0)
  silentArgs   = '/qn'
}

Install-ChocolateyPackage @packageArgs
