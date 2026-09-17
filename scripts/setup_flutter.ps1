<#
PowerShell helper to check Flutter and initialize/build the project.
Usage:
  .\setup_flutter.ps1            # runs checks, runs 'flutter create .' if android missing, runs pub get
  .\setup_flutter.ps1 -Build     # also builds a debug APK (flutter build apk --debug)
#>

[CmdletBinding()]
param(
    [switch]$Build
)

function Fail([string]$msg){ Write-Host $msg -ForegroundColor Red; exit 1 }

# Check flutter
$flutterCmd = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutterCmd) {
    Fail 'flutter not found in PATH. Please install Flutter and add flutter\bin to PATH. See https://docs.flutter.dev/get-started/install'
}

Write-Host "Flutter found: $($flutterCmd.Path)" -ForegroundColor Green
& flutter --version

Set-Location -Path (Join-Path $PSScriptRoot '..')

# If android folder missing, run flutter create . to generate platform folders
if (-not (Test-Path -Path './android')) {
    Write-Host 'Android folder not found — running flutter create .' -ForegroundColor Yellow
    & flutter create .
    if ($LASTEXITCODE -ne 0) { Fail 'flutter create failed' }
}

Write-Host 'Running flutter pub get' -ForegroundColor Cyan
& flutter pub get
if ($LASTEXITCODE -ne 0) { Fail 'flutter pub get failed' }

if ($Build) {
    Write-Host 'Building debug APK (this may take a while)...' -ForegroundColor Cyan
    & flutter build apk --debug
    if ($LASTEXITCODE -ne 0) { Fail 'flutter build apk failed' }
    Write-Host 'Debug APK built: build\app\outputs\flutter-apk\app-debug.apk' -ForegroundColor Green
}

Write-Host 'Setup complete.' -ForegroundColor Green
