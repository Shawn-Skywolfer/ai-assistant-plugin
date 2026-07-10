param(
  [string]$Version,
  [string]$OsName = "windows",
  [string]$ArchName = "x64",
  [string]$OutDir
)

$ErrorActionPreference = "Stop"
$RootDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
if (-not $OutDir) { $OutDir = Join-Path $RootDir "dist/release" }
if (-not $Version) {
  $manifest = Get-Content (Join-Path $RootDir "manifest.json") -Raw | ConvertFrom-Json
  $Version = "v$($manifest.version.TrimStart('v'))"
}
if (-not $Version.StartsWith("v")) { $Version = "v$Version" }

$repoName = if ($env:GITHUB_REPOSITORY) { Split-Path $env:GITHUB_REPOSITORY -Leaf } else { Split-Path $RootDir -Leaf }
$zipName = "$repoName-$Version-$OsName-$ArchName.zip"
$zipPath = Join-Path $OutDir $zipName
$files = @("manifest.json", "plugin.js", "index.html", "icon.svg")

Set-Location $RootDir
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

foreach ($file in $files) {
  if (-not (Test-Path (Join-Path $RootDir $file))) { throw "Missing required plugin file: $file" }
}

# Windows companion script. The release workflow uses Linux/Python because that
# matches the verified packaging environment, but this keeps local Windows
# packaging available.
Compress-Archive -Path $files -DestinationPath $zipPath -CompressionLevel Optimal

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
try {
  $names = $zip.Entries | ForEach-Object { $_.FullName }
  foreach ($file in $files) {
    if ($names -notcontains $file) { throw "ZIP missing required file: $file" }
  }
}
finally {
  $zip.Dispose()
}

Write-Host "Verified $zipPath"
