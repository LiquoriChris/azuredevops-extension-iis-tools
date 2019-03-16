[CmdletBinding()]
param ()

$FilePath = Get-VstsInput -Name 'filePath'
$TargetType = Get-VstsInput -Name 'targetType'

. $PSScriptRoot\HelperFunctions.ps1

if ($TargetType -eq 'unc') {
    $Destination = Get-VstsInput -Name 'uncPath'
    _Copy -FilePath $FilePath -Destination $Destination
}

if ($TargetType -eq 'remoteComputer') {
    $ComputerName = Get-VstsInput -Name 'computerName'
    $Destination = Get-VstsInput -Name 'localPath'
    $TargetComputerName = Split-TargetComputer -ComputerName $ComputerName 
    foreach ($Computer in $TargetComputerName) {
        Write-Output "Running on $($Computer):"
        _Copy -FilePath $FilePath -Destination $Destination -ToSession (New-PSSession -ComputerName $Computer)
    }
}