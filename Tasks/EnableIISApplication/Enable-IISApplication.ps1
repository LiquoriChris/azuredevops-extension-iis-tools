[CmdletBinding()]
param ()

$TargetType = Get-VstsInput -Name 'targetType'

. $PSScriptRoot\HelperFunctions.ps1

if ($TargetType -eq 'unc') {
    $Path = Get-VstsInput -Name 'uncPath'
    _Remove -Path $Path
}

if ($TargetType -eq 'remoteComputer') {
    $ComputerName = Get-VstsInput -Name 'computerName'
    $Path = Get-VstsInput -Name 'localPath'
    $TargetComputerName = Split-TargetComputer -ComputerName $ComputerName 
    foreach ($Computer in $TargetComputerName) {
        $Session = New-PSSession -ComputerName $Computer
        Write-Output "Running on $($Computer):"
        Invoke-Command -Session $Session -ScriptBlock $Function:_Remove -ArgumentList $Path
    }
}