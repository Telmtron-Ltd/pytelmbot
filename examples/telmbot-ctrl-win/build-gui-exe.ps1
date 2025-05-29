param (
    [string]$targetDirectory = "."
)
# This script builds the telmbot-ctrl application into a standalone executable using PyInstaller.

# Remember the current directory
$originalDirectory = Get-Location

# Change targetDirectory to an absolute path if it is not already
if (-not [System.IO.Path]::IsPathRooted($targetDirectory)) {
    $targetDirectory = [System.IO.Path]::GetFullPath($targetDirectory)
}



# Change to the directory containing the script
Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)

# Install dependencies from requirements.txt
pip install -r .\requirements.txt

# Build any .py files in the current directory
Get-ChildItem -Path . -Filter *.py | ForEach-Object {
    $scriptPath = $_.FullName
    Write-Host "Building $scriptPath..."
    pyinstaller --onefile --windowed $scriptPath
    # Copy the generated executable to targetDirectory
    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($scriptPath)    
    $exeName = $scriptName + ".exe"
    $targetPath = Join-Path -Path $targetDirectory -ChildPath $scriptName
    $exePath = Join-Path -Path $targetPath -ChildPath $exeName
    
    if (Test-Path -Path $exePath) {
        Write-Warning "Removing existing executable: $exePath"
        Remove-Item -Path $exePath -Force
    }
    elseif (-not (Test-Path -Path $targetPath)) {
        Write-Warning "Target directory does not exist: $targetPath"
        Write-Host "Creating target directory: $targetPath"
        New-Item -ItemType Directory -Path $targetPath | Out-Null
    }

    Copy-Item -Path (Join-Path -Path "dist" -ChildPath $exeName) -Destination $exePath
    Write-Host "Copied $exeName to $exePath"
}

# Restore the original directory
Set-Location -Path $originalDirectory
