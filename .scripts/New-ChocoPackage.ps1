#Requires -Version 7
CmdletBinding()]
[OutputType([string])]
param(
    [Parameter(Mandatory)]
    [string]$Name,

    [Parameter(Mandatory)]
    [string]$Url,

    [string]$Url64,

    [Parameter(Mandatory)]
    [string]$Version,

    [Parameter(Mandatory)]
    [string]$Checksum,

    [string]$Checksum64,

    [ValidateSet('sha256', 'sha512', 'md5', 'sha1')]
    [string]$ChecksumType = 'sha256',

    [Parameter(Mandatory)]
    [string]$InstallerType,

    [string]$SilentArgs = '/S',

    [string]$MaintainerName = 'Kipjr',

    [string]$MaintainerRepo = '',

    [string]$Root = "."
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# choco new <name> [<options/switches>] [<property=value> <propertyN=valueN>]
# Template placeholders filled below:
#   PackageName, PackageNameLower, PackageVersion, MaintainerName,
#   MaintainerRepo, InstallerType, Url, Url64, Checksum, Checksum64,
#   ChecksumType, SilentArgs

$id = $Name.ToLowerInvariant()

$templatePath    = Join-Path $Root "templates"
$nuspecTemplate  = Join-Path $templatePath "package.nuspec.template"
$installTemplate = Join-Path $templatePath "chocolateyInstall.ps1.template"

if (!(Test-Path $nuspecTemplate)) {
    throw "Missing template: $nuspecTemplate"
}

if (!(Test-Path $installTemplate)) {
    throw "Missing template: $installTemplate"
}

$packagePath = Join-Path $Root $id

if (!(Test-Path $packagePath)) {
    New-Item -Path $packagePath -ItemType Directory | Out-Null
}

$toolsPath = Join-Path $packagePath "tools"

if (!(Test-Path $toolsPath)) {
    New-Item -Path $toolsPath -ItemType Directory | Out-Null
}

$variables = @{
    PackageName      = $Name
    PackageNameLower = $id
    PackageVersion   = $Version
    MaintainerName   = $MaintainerName
    MaintainerRepo   = $MaintainerRepo
    InstallerType    = $InstallerType
    Url              = $Url
    Url64            = $Url64
    Checksum         = $Checksum
    Checksum64       = $Checksum64
    ChecksumType     = $ChecksumType
    SilentArgs       = $SilentArgs
}

function Fill-Template {
    param(
        [Parameter(Mandatory)]
        [string]$Template,

        [Parameter(Mandatory)]
        [string]$Output,

        [Parameter(Mandatory)]
        [hashtable]$Variables
    )

    $content = Get-Content -Path $Template -Raw

    foreach ($key in $Variables.Keys) {
        $content = $content.Replace("{{${key}}}", [string]$Variables[$key])
    }

    Set-Content -Path $Output -Value $content -Encoding UTF8
}

try {
    Fill-Template -Template $nuspecTemplate -Output (Join-Path $packagePath "$id.nuspec") -Variables $variables
    Fill-Template -Template $installTemplate -Output (Join-Path $toolsPath "chocolateyInstall.ps1") -Variables $variables
}
catch {
    throw "Failed to generate package for '$Name': $_"
}

Write-Host ""
Write-Host "Generated package:"
Write-Host $packagePath

return $packagePath
