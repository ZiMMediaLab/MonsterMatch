<#
.SYNOPSIS
    Turns MonsterMatch's GameMaker HTML5 export into an installable PWA for GitHub Pages.

.DESCRIPTION
    1. Copies the HTML5 export (a folder or a .zip) into the repo's docs folder.
    2. Adds the web app manifest, icons, and service worker from the pwa folder.
    3. Adds the PWA tags to index.html.

    The service worker cache is stamped with the build time, so returning players
    always pick up the newest build. Safe to run again after every new export.

.PARAMETER ExportPath
    The .zip or folder GameMaker made with Build > Create Executable (HTML5 target).

.PARAMETER OutputPath
    Where the finished site goes. Defaults to the repo's docs folder (the GitHub Pages source).

.EXAMPLE
    .\tools\Build-PWA.ps1 -ExportPath "$env:USERPROFILE\Downloads\MonsterMatch.zip"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$ExportPath,

    [string]$OutputPath = (Join-Path $PSScriptRoot '..\docs')
)

$ErrorActionPreference = 'Stop'

$repoRoot   = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$pwaSource  = Join-Path $repoRoot 'pwa'
$markerFile = '.pwa-build'
$tagMarker  = '<!-- MonsterMatch PWA -->'

if (-not (Test-Path $ExportPath)) {
    throw "Export not found: $ExportPath"
}

# 1. Prepare a clean output folder
# Only delete a folder this script created (it leaves a marker file)
if (Test-Path $OutputPath) {
    $hasContent = @(Get-ChildItem -Path $OutputPath -Force).Count -gt 0
    $isOurBuild = Test-Path (Join-Path $OutputPath $markerFile)

    if ($hasContent -and -not $isOurBuild) {
        throw "$OutputPath already has files that this script didn't create. Empty it or choose another -OutputPath."
    }

    Remove-Item -Path $OutputPath -Recurse -Force
}

New-Item -ItemType Directory -Path $OutputPath | Out-Null
$OutputPath = (Resolve-Path $OutputPath).Path

# 2. Copy the GameMaker export
if ($ExportPath -like '*.zip') {
    Expand-Archive -Path $ExportPath -DestinationPath $OutputPath
}
else {
    Copy-Item -Path (Join-Path $ExportPath '*') -Destination $OutputPath -Recurse
}

$indexFile = Get-ChildItem -Path $OutputPath -Filter 'index.html' -Recurse | Select-Object -First 1
if (-not $indexFile) {
    throw "No index.html found in the export. Check that the build target was HTML5 (not GX.games)."
}

# If the export was nested in a subfolder, move it up so index.html sits at the site root
if ($indexFile.DirectoryName -ne $OutputPath) {
    $nestedFolder = $indexFile.DirectoryName
    Get-ChildItem -Path $nestedFolder -Force | Move-Item -Destination $OutputPath
    Remove-Item -Path $nestedFolder -Recurse -Force
    $indexFile = Get-Item (Join-Path $OutputPath 'index.html')
}

# 3. Add the PWA files
$pwaFiles = 'manifest.webmanifest', 'icon-192.png', 'icon-512.png', 'apple-touch-icon.png'
foreach ($file in $pwaFiles) {
    Copy-Item -Path (Join-Path $pwaSource $file) -Destination $OutputPath
}

$buildVersion   = Get-Date -Format 'yyyyMMdd-HHmmss'
$serviceWorker  = [IO.File]::ReadAllText((Join-Path $pwaSource 'sw.js'))
$serviceWorker  = $serviceWorker.Replace('__BUILD_VERSION__', $buildVersion)
$utf8NoBom      = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllText((Join-Path $OutputPath 'sw.js'), $serviceWorker, $utf8NoBom)

New-Item -ItemType File -Path (Join-Path $OutputPath '.nojekyll') -Force | Out-Null
New-Item -ItemType File -Path (Join-Path $OutputPath $markerFile) -Force | Out-Null

# 4. Add the PWA tags to index.html
$html = [IO.File]::ReadAllText($indexFile.FullName)

if (-not $html.Contains($tagMarker)) {
    $tags = @"
$tagMarker
<link rel="manifest" href="manifest.webmanifest">
<link rel="apple-touch-icon" href="apple-touch-icon.png">
<meta name="theme-color" content="#191919">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-title" content="MonsterMatch">
<script data-goatcounter="https://zimmedia-labs.goatcounter.com/count" async src="//gc.zgo.at/count.js"></script>
<script>
  if ("serviceWorker" in navigator) {
    window.addEventListener("load", function () { navigator.serviceWorker.register("sw.js"); });
  }
</script>
"@

    if ($html -notmatch '<meta[^>]+name\s*=\s*"viewport"') {
        $tags = '<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">' + "`n" + $tags
    }

    $headClose = $html.IndexOf('</head>', [StringComparison]::OrdinalIgnoreCase)
    if ($headClose -lt 0) {
        throw "Couldn't find </head> in index.html."
    }

    $html = $html.Insert($headClose, $tags + "`n")
    [IO.File]::WriteAllText($indexFile.FullName, $html, $utf8NoBom)
}

Write-Host ""
Write-Host "PWA build ready: $OutputPath" -ForegroundColor Green
Write-Host "Service worker version: $buildVersion"
Write-Host "Next: commit and push the docs folder." -ForegroundColor Cyan
