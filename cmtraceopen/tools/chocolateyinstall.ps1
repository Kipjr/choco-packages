$url = "https://github.com/adamgell/cmtraceopen/releases/download/v1.5.1/CMTrace-Open_1.5.1_x64-setup.exe"
$checksum = "3360d300df3e4133c7ab8db182ebe43e4e16449f941d1af2d15b7e7f1080454e"

Install-ChocolateyPackage `
    -PackageName "cmtraceopen" `
    -InstallerType "exe" `
    -Url $url `
    -Checksum $checksum `
    -ChecksumType "sha256"

