# Automated by: https://ket0x04.t.me
# Version: 1.0
# Date: 2022-12-31
# Description: This script will help you to Installing platform-tools, booting recovery image and exectuing msc.sh

# Global variables (To-do: replace hardcoded urls with github api, or ask user to enter path)
$toolurl = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
$recoveryurl = "https://github.com/erdilS/Port-Windows-11-Xiaomi-Pad-5/releases/download/1.0/recovery.img"
$mscurl = "https://github.com/erdilS/Port-Windows-11-Xiaomi-Pad-5/releases/download/1.0/msc.sh"
$bootnabuurl = "https://github.com/erdilS/Port-Windows-11-Xiaomi-Pad-5/releases/download/1.0/boot-nabu.img"

# start adb server
adb start-server
Clear-Host

# check required files and tools. download if not exists 

# Platform-tools
if (Get-Command fastboot -ErrorAction SilentlyContinue) {
} else {
    Write-Host "platform-tools is not installed. Installing..."
    Invoke-WebRequest -Uri $toolurl -OutFile platform-tools.zip
    Expand-Archive -Path platform-tools.zip -DestinationPath .\files
    Remove-Item Platform-tools.zip
    $env:Path += ";$pwd\files\platform-tools"
}

# recovery.img
if (Test-Path .\files\recovery.img) {
} else {
    Write-Host "recovery.img is not found. Downloading..."
    Invoke-WebRequest -Uri $recoveryurl -OutFile .\files\recovery.img
    $recoveryimg = .\files\recovery.img
}

# msc.sh
if (Test-Path .\files\msc.sh) {
} else {
    Write-Host "msc.sh is not found. Downloading..."
    Invoke-WebRequest -Uri $mscurl -OutFile .\files\msc.sh
    $mscsh = .\files\msc.sh
}

# boot-nabu.img
if (Test-Path .\files\boot-nabu.img) {
} else {
    Write-Host "boot-nabu.img is not found. Downloading..."
    Invoke-WebRequest -Uri $bootnabuurl -OutFile .\files\boot-nabu.img
    $bootnabu.img = .\files\boot-nabu.img
}

Clear-Host

# list fastboot devices and ask user to select device
Write-Host "[Fastboot] List of connected devices:"
fastboot devices
$fbdevice = Read-Host "[Fastboot] Enter device serial number"
fastboot boot -S $fbdevice $recoveryimg
write-host "Booting recovery image..."
Clear-Host

# list adb devices and ask user to select device
Write-Host "[ADB] List of connected devices:"
adb devices
$adbdevice = Read-Host "Enter device serial number"
Clear-Host
Write-Host "[ADB] Pushing msc.sh to device..."
adb -S $adbdevice push $mscsh /sbin/
Write-Host "executing msc.sh..."
adb -S shell sh /sbin/msc.sh
Clear-Host
pause