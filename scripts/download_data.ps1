# Download and Extract Game Data for TurtleWoW 1.17.2
param (
    [string]$Url = "https://github.com/d3athbl0w/twow-1172/releases/download/data/data.zip",
    [string]$Destination = "$PSScriptRoot\..\data",
    [string]$ZipFile = "$PSScriptRoot\..\data.zip"
)

$ErrorActionPreference = "Stop"

Write-Host "=== TurtleWoW 1.17.2 Game Data Downloader ===" -ForegroundColor Cyan
Write-Host "Target URL: $Url" -ForegroundColor Gray
Write-Host "Target Data Folder: $Destination" -ForegroundColor Gray

if (-not (Test-Path -Path $Destination)) {
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
}

# Check if data already exists
if ((Test-Path -Path "$Destination\dbc") -and (Test-Path -Path "$Destination\maps")) {
    Write-Host "Game data already found in $Destination." -ForegroundColor Yellow
    $choice = Read-Host "Do you want to re-download and overwrite? (y/N)"
    if ($choice -ne "y" -and $choice -ne "Y") {
        Write-Host "Skipping download." -ForegroundColor Green
        exit 0
    }
}

Write-Host "Downloading data.zip (~2.5GB)... Please wait..." -ForegroundColor Green
try {
    # Use BITS or curl or Invoke-WebRequest with progress
    if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
        curl.exe -L -o $ZipFile $Url --progress-bar
    } else {
        Invoke-WebRequest -Uri $Url -OutFile $ZipFile
    }
    Write-Host "Download finished successfully." -ForegroundColor Green
} catch {
    Write-Error "Failed to download game data from $Url: $_"
    exit 1
}

Write-Host "Extracting data.zip into $Destination..." -ForegroundColor Green
try {
    Expand-Archive -Path $ZipFile -DestinationPath $Destination -Force
    Write-Host "Extraction completed." -ForegroundColor Green
} catch {
    Write-Error "Failed to extract $ZipFile: $_"
    exit 1
}

# Clean up zip file
if (Test-Path -Path $ZipFile) {
    Remove-Item -Path $ZipFile -Force
    Write-Host "Cleaned up temporary archive $ZipFile." -ForegroundColor Gray
}

Write-Host "=== All Game Data is ready in $Destination ===" -ForegroundColor Cyan
