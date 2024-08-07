<#
README
Script: Backup BitLocker Key Protector to Azure AD
Author: Mathieu LEROY
Date: 2024-08-07
Description:
    This script backs up the BitLocker Key Protector for the C: drive to Azure AD.
    It handles errors gracefully and provides meaningful output to the user.
#>

# Set the error action preference to silently continue to handle errors without stopping the script
$ErrorActionPreference = 'SilentlyContinue'

try {
    # Get the BitLocker volume information for the C: drive
    $BLV = Get-BitLockerVolume -MountPoint "C:" | Select-Object *

    if ($BLV -eq $null) {
        throw "No BitLocker volume found for the specified mount point."
    }

    # Extract the first Key Protector ID
    $KeyProtectorId = $BLV.KeyProtector[0].KeyProtectorId

    if ($KeyProtectorId -eq $null) {
        throw "No Key Protector ID found for the BitLocker volume."
    }

    # Backup the BitLocker Key Protector to Azure AD
    BackupToAAD-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $KeyProtectorId

    Write-Output "BitLocker key protector backed up successfully to Azure AD."
}
catch {
    Write-Output "An error occurred: $_"
}
finally {
    # Reset the error action preference to the default
    $ErrorActionPreference = 'Continue'
}
