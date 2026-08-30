# scripts/build.ps1
# Automated build & setup script for TurtleWoW 1.17.2 Docker environment

param (
    [string]$RepoUrl = "https://github.com/d3athbl0w/twow-1172.git",
    [string]$Branch = "master",
    [string]$TargetFolder = "../patch_1172"
)

$resolvedPath = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot $TargetFolder))

Write-Host "=== TurtleWoW 1.17.2 Docker Build Assistant ===" -ForegroundColor Cyan

# 1. Check & download game data if missing
$dataPath = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "../data"))
if (-not (Test-Path "$dataPath\dbc") -or -not (Test-Path "$dataPath\maps")) {
    Write-Host "[INFO] Game assets not detected in ./data/. Launching data downloader..." -ForegroundColor Yellow
    & "$PSScriptRoot\download_data.ps1"
}

# 2. Check local source code repository (optional for development)
if (-not (Test-Path $resolvedPath)) {
    Write-Host "[INFO] Local source folder not found at: $resolvedPath" -ForegroundColor Yellow
    $cloneLocal = Read-Host "Do you want to clone the C++ source code to the host for local editing? (y/N)"
    if ($cloneLocal -eq "y" -or $cloneLocal -eq "Y") {
        Write-Host "[INFO] Cloning $RepoUrl ($Branch)..." -ForegroundColor Cyan
        git clone --depth 1 -b $Branch $RepoUrl $resolvedPath
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Source cloned to $resolvedPath." -ForegroundColor Green
        }
    } else {
        Write-Host "[INFO] Continuing with automated in-container build." -ForegroundColor Gray
    }
}

# 3. Build Docker images
Write-Host "[INFO] Building Docker images with Docker Compose..." -ForegroundColor Cyan
docker compose build

if ($LASTEXITCODE -eq 0) {
    Write-Host "=== Build Completed Successfully! ===" -ForegroundColor Green
    Write-Host "Start the server with: docker compose up -d" -ForegroundColor Yellow
} else {
    Write-Error "[ERROR] Docker build failed. Review output above."
}
