$driverupdaterurl = "https://github.com/WOA-Project/DriverUpdater/releases/download/v1.0.0.7/win-x64.zip"
$driverupdaterzip = ".\files\driverupdater.zip"
$driverupdaterfolder = ".\files\DriverUpdater"
$driverupdaterexe = ".\files\DriverUpdater\DriverUpdater.exe"

# Driver Updater
if (Get-Command driverupdater -ErrorAction SilentlyContinue) {
} else {
    Write-Host "Driver updater is not found. Downloading..."
    Invoke-WebRequest -Uri $driverupdaterurl -OutFile .\files.\driverupdater.zip
    Expand-Archive -Path .\files.\driverupdater.zip -DestinationPath .\files
    Remove-Item .\files.\driverupdater.zip
    $env:Path += ";$pwd\files\driverupdater"
}
pause