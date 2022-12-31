# Automated by: https://ket0x04.t.me
# Version: 1.0
# Date: 2022-12-30
# Description: This script will help you to assign letter X: to WINABU partition and Y: to EFI partition

# WARNING
Write-Host  -ForegroundColor red  "------------------------------------------------------------------------------------------------------------"
Write-Host "This script will help you to assign letter X: to WINABU partition and Y: to EFI partition"
Write-Host "Working on partitions is dangerous, double check if you selected correct partitions."
Write-Host  -BackgroundColor red "Note. This script may not work with Powershell core (Bundled with windows 10/11."
Write-Host  -BackgroundColor red "You have to install latest powershell here: https://github.com/PowerShell/PowerShell"
Write-Host  -ForegroundColor red  "------------------------------------------------------------------------------------------------------------"
Write-Host ""
Write-Host ""

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