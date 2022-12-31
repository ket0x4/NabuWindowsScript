# WARNING
Write-Host  -ForegroundColor red  "------------------------------------------------------------------------------------------------------------------------"
Write-Host                        "Github: https://github.com/Caticer, https://github.com/erdilS" "Telegram: https://ket0x4.t.me, https://ErdilS.t.me"
Write-Host                        "This script will assist you to install windows on Xiaomi Pad 5 (Nabu)"
Write-Host                        "This script is not affiliated with Xiaomi or Microsoft and not responsible for any damage to your device and/or data"
Write-Host  -BackgroundColor red  "Note. This script may not work with Powershell core (Bundled with windows 10/11."
Write-Host  -BackgroundColor red  "You have to install latest powershell here:" "https://github.com/PowerShell/PowerShell"
Write-Host  -ForegroundColor red  "------------------------------------------------------------------------------------------------------------------------"
Write-Host  -BackgroundColor red  "Dont re-run this script if you encounter any error. Contact me on github or telegram"
Write-Host  -ForegroundColor red  "------------------------------------------------------------------------------------------------------------------------"

Write-Host ""
Write-Host ""
pause

# Global variables (To-do: replace hardcoded urls with github api, or ask user to enter path)
$toolurl = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
$recoveryurl = "https://github.com/erdilS/Port-Windows-11-Xiaomi-Pad-5/releases/download/1.0/recovery.img"
$mscurl = "https://github.com/erdilS/Port-Windows-11-Xiaomi-Pad-5/releases/download/1.0/msc.sh"
$bootnabuurl = "https://github.com/erdilS/Port-Windows-11-Xiaomi-Pad-5/releases/download/1.0/boot-nabu.img"
#$stockbooturl = "" # To-do: add stock boot.img url
$driverupdaterurl = "https://github.com/WOA-Project/DriverUpdater/releases/download/v1.0.0.7/win-x64.zip"
$driversurl = "" # To-do: add drivers url
$driversfolder = ".\files\Drivers"
$definition = ".\files\NabuDrivers\definitions\Desktop\ARM64\Internal\nabu.txt"

# start adb server
adb start-server
# make files dir if not exists
if (Test-Path .\files) {
} else {
    New-Item -ItemType Directory -Path .\files
}
Clear-Host

# check required files and tools. download if not exists or not installed
# Platform-tools
if (Get-Command fastboot -ErrorAction SilentlyContinue) {
} else {
    Write-Host "platform-tools is not installed. Installing..."
    Invoke-WebRequest -Uri $toolurl -OutFile .\files\platform-tools.zip
    Expand-Archive -Path .\files\platform-tools.zip -DestinationPath .\files
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

# Stock (Android) boot.img
# To-do: add stock boot.img url
#if (Test-Path .\files\boot-nabu.img) {
#} else {
#    Write-Host "boot-nabu.img is not found. Downloading..."
#    Invoke-WebRequest -Uri $stockboot -OutFile .\files\boot.img
#    $stockboot.img = .\files\boot.img
#}
#Clear-Host

# Assigning letters to drives
Write-Host -ForegroundColor red "Working on partitions is dangerous, double check if you selected correct partitions."
# List avaible disks and ask user for input
Get-disk
Write-Host "First you need to select disk number, It's usually 1 if you have only one disk, but it can be different."
$disknumb = Read-Host "Enter disk number"
Clear-Host

# List avaible partitions on selected disk and ask user for input
get-partition -DiskNumber $disknumb | Format-Table
Write-Host "Than you need to select partition called" -BackgroundColor red "WINNABU"
$partnumb = Read-Host "Enter partition number"
Clear-Host

# assing letter X: to selected partition
Write-Host "Assinging letter X: to selected partition"
Get-Partition -DiskNumber $disknumb -PartitionNumber $partnumb | Set-Partition -NewDriveLetter X
Start-Sleep -s 2
Clear-Host

# List avaible partitions on selected disk and ask user for input
get-partition -DiskNumber $disknumb | Format-Table
Write-Host "Now you need to select EFI partition. It's usually the last one"
$partnumb = Read-Host "Enter partition number"
Clear-Host

# assing letter X: to selected partition
Write-Host "Assinging letter X: to selected partition"
Get-Partition -DiskNumber $disknumb -PartitionNumber $partnumb | Set-Partition -NewDriveLetter Y
Start-Sleep -s 2
Clear-Host

# list fastboot devices and ask user to select device
Write-Host "[Fastboot] List of connected devices:"
fastboot devices
$fbdevice = Read-Host "[Fastboot] Enter device serial number"
fastboot boot -S $fbdevice $recoveryimg
write-host "Booting recovery image..."
Clear-Host

# Installing recovery image and executing msc.sh
# list adb devices and ask user to select device
Write-Host "[ADB] List of connected devices:"
adb devices
$adbdevice = Read-Host "Enter device serial number"
Clear-Host
Write-Host "[ADB] Pushing msc.sh to device..."
adb -S $adbdevice push $mscsh /sbin/ # adb push can be used instead of adb -S if only one device is connected
Write-Host "executing msc.sh..."
adb -S shell sh /sbin/msc.sh # adb push can be used instead of adb -S if only one device is connected
Clear-Host
pause

# Apply wim file
# apply install.wim to WINNABU partition (X:)
write-host "Applying install.wim to WINNABU partition..."
$wimfile = Read-Host "Drag and drop install.wim file and press enter"
dism /apply-image /ImageFile:$wimfile /index:1 /ApplyDir:X:\ #to-do: make X: variable

Clear-Host

# Instal drivers
# Download DriverUpdater extract and add to path
Invoke-WebRequest -Uri $driverupdaterurl -OutFile .\files\win-x64.zip
Expand-Archive -Path .\files\win-x64.zip -DestinationPath .\files\DriverUpdater
Remove-Item .\files\win-x64.zip
$env:Path += ";$pwd\files\DriverUpdater"
Clear-Host

# Download drivers and extract to files\Drivers
Invoke-WebRequest -Uri $driversurl -OutFile .\files\Drivers.zip # To-do: add drivers url
Expand-Archive -Path .\files\Drivers.zip -DestinationPath .\files\Drivers
Remove-Item .\files\Drivers.zip
Clear-Host

# updated drivers with DriverUpdater
driverupdaterexe -d $definition -r $driversfolder -p X: # to-do: make driver letter variable
Clear-Host

# Creating UEFI boot files (to-do: make drive letter vraible)
write-host "Creating UEFI boot files..."
bcdboot X:\Windows /s Y: /f UEFI
Clear-Host

# Enable test signing
write-host "Enabling test signing... (Required for drivers)"
bcdedit /store Y:\EFI\Microsoft\BOOT\BCD /set {default} testsigning on
Clear-Host

# Boot windows or android
write-host "Do you want to boot windows or android?"
write-host "1. Windows"
write-host "2. Android"
$boot = Read-Host "Enter number"
if ($boot -eq 1) {
    fastboot flash boot -S $fbdevice $bootnabu.img
} elseif ($boot -eq 2) {
    $stockboot = Read-Host "Drag and drop stock boot.img and press enter"
    fastboot flash boot -S $fbdevice $stockboot.
} else {
    write-host "Invalid input"
}

# Backing up boot.img 
adb shell "dd if=/dev/block/bootdevice/by-name/boot of=/tmp/boot.img"
adb pull /tmp/boot.img
create-item -path .\backups -type directory
Move-Item boot.img .\backups\boot.img
adb shell "rm /tmp/boot.img"
Clear-Host

# Rebooting to fastboot
Write-host "Rebooting to fastboot..."
adb reboot bootloader
Start-Sleep -s 4 # wait for device to reboot
Write-Host 
fastboot flash boot $bootnabu.img
Clear-Host