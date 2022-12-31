# Automated by: https://ket0x04.t.me
# Version: 1.0
# Date: 2022-12-31
# Description: This script will help you to Installing windows 11 on WINABU partition with dism

# Global variables (To-do: replace hardcoded urls with github api, or ask user to enter path)

# Ask user to drag and drop install.wim file and add it to $wimpath variable
$wimpath = Read-Host "Drag and drop install.wim file and press enter"

# apply install.wim to WINNABU partition (X:)
write-host "Applying install.wim to WINNABU partition..."
dism /apply-image /ImageFile:$wimpath /index:1 /ApplyDir:X:\

Clear-Host

# Creating UEFI boot files (to-do: make drive letter vraible)
write-host "Creating UEFI boot files..."
bcdboot X:\Windows /s Y: /f UEFI

Clear-Host

# Enable test signing
write-host "Enabling test signing... (Required for drivers)"
bcdedit /store Y:\EFI\Microsoft\BOOT\BCD /set {default} testsigning on

Clear-Host
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
