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
    $Username = Get-VstsInput -Name 'userName'
    $Password = Get-VstsInput -Name 'password'
    $Authentication = Get-VstsInput -Name 'authentication'
    $ConfigurationName = Get-VstsInput -Name 'configurationName'
    $TargetComputerName = Split-TargetComputer -ComputerName $ComputerName 
    foreach ($Computer in $TargetComputerName) {
        $Params = @{
            ComputerName = $Computer
        }
        if ($Authentication) {
            $Params.Authentication = $Authentication
        }
        if ($Username -and $Password) {
            $Credential = _Credential -Username $Username -Password $Password
            $Params.Credential = $Credential
        }
        if ($ConfigurationName) { 
            $Params.ConfigurationName = $ConfigurationName
        }
        $Session = New-Session @Params
        Write-Output "Running on $($Computer):"
        _Copy -FilePath $FilePath -Destination $Destination -ToSession $Session
        Remove-Session -ComputerName $Computer
    }
}