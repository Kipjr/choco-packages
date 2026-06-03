$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/adamgell/cmtraceopen/releases/download/v1.3.2/CMTrace-Open_1.3.2_x64.msi'


$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  softwareName  = 'CMTrace Open'
  checksum      = '42E993B33E54B34DAF2FAB0C839902278B4C32B29C44FD92204BD85F6FD53754'
  checksumType  = 'sha256'
  validExitCodes= @(0)
  silentArgs   = '/qn'
}

Install-ChocolateyPackage @packageArgs
