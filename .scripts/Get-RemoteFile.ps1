[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Name,

    [Parameter(Mandatory)]
    [string]$Url,

    [Parameter(Mandatory)]
    [string]$Version,

    [string]$Root = "."
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$id = $Name.ToLower().Replace(" ", "-")
$packagePath = Join-Path $Root $id

$tempFile = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())

try {
    Write-Host "Downloading $Url"

    Invoke-WebRequest `
        -Uri $Url `
        -OutFile $tempFile

    $hash = Get-FileHash `
        -Path $tempFile `
        -Algorithm SHA256

    $sha256 = $hash.Hash.ToLower()

    $filetype = [System.IO.Path]::GetExtension(([uri]$Url).AbsolutePath).TrimStart('.')
    $variables = @{
        ID      = $id
        NAME    = $Name
        URL     = $Url
        VERSION = $Version
        SHA256  = $sha256
        FILETYPE=$filetype
        TEMPFILE = $tempFile
    }
    return $variables


} catch {
    Write-Error $_
}
