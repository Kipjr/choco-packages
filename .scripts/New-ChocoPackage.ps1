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

$templatePath = Join-Path $Root "templates"

$nuspecTemplate = Join-Path $templatePath "package.nuspec.template"
$installTemplate = Join-Path $templatePath "chocolateyInstall.ps1.template"

if (!(Test-Path $nuspecTemplate)) {
    throw "Missing template: $nuspecTemplate"
}

if (!(Test-Path $installTemplate)) {
    throw "Missing template: $installTemplate"
}

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

    if (!(Test-Path $packagePath)) {
        New-Item `
            -Path $packagePath `
            -ItemType Directory | Out-Null
    }

    $toolsPath = Join-Path $packagePath "tools"

    if (!(Test-Path $toolsPath)) {
        New-Item `
            -Path $toolsPath `
            -ItemType Directory | Out-Null
    }

    $variables = @{
        ID      = $id
        NAME    = $Name
        URL     = $Url
        VERSION = $Version
        SHA256  = $sha256
    }

    function Fill-Template {
        param(
            [string]$Template,
            [string]$Output
        )

        $content = Get-Content `
            -Path $Template `
            -Raw

        foreach ($key in $variables.Keys) {
            $content = $content.Replace(
                "{{${key}}}",
                $variables[$key]
            )
        }

        Set-Content `
            -Path $Output `
            -Value $content `
            -Encoding UTF8
    }

    Fill-Template `
        -Template $nuspecTemplate `
        -Output (Join-Path $packagePath "$id.nuspec")

    Fill-Template `
        -Template $installTemplate `
        -Output (Join-Path $toolsPath "chocolateyInstall.ps1")

    Write-Host ""
    Write-Host "Generated package:"
    Write-Host $packagePath
}
finally {
    if (Test-Path $tempFile) {
        Remove-Item $tempFile -Force
    }
}
