# PowerShell script to build and upload the package to PyPI

param(
    [string]$Version
)

# Check if .pypirc exists
$pypircPath = "$HOME\.pypirc"
if (-Not (Test-Path $pypircPath)) {
    Write-Host "Error: .pypirc file not found. Please create it with your PyPI credentials."
    exit 1
}

# Exit on error
$ErrorActionPreference = "Stop"

if ($Version) {
    # Update version in pyproject.toml
    (Get-Content pyproject.toml) -replace 'version\s*=\s*".*"', "version = `"$Version`"" | Set-Content pyproject.toml
    Write-Host "Set version to $Version in pyproject.toml"
}

# Clean previous builds
Remove-Item -Recurse -Force dist, build, *.egg-info -ErrorAction SilentlyContinue

# Build the package (source and wheel)
python -m build

# Upload to PyPI using twine
twine upload dist/*

Write-Host "Build and upload complete."
