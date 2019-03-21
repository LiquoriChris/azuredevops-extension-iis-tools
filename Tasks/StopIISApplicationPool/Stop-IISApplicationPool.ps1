[CmdletBinding()]
param ()

$ComputerName = Get-VstsInput -Name 'computerName'
$AppPools = Get-VstsInput -Name 'appPools'
$Username = Get-VstsInput -Name 'userName'
$Password = Get-VstsInput -Name 'password'
$Authentication = Get-VstsInput -Name 'authentication'
$ConfigurationName = Get-VstsInput -Name 'configurationName'

. $PSScriptRoot\HelperFunctions.ps1

$AppPoolName = Split-ApplicationPoolName -Name $AppPools
$Params = @{
    ComputerName = $ComputerName
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
$Result = foreach ($AppPool in $AppPoolName) {
    Invoke-Command -Session $Session -ScriptBlock {
        Try {
            Import-Module WebAdministration -Force
            Get-ChildItem -Path IIS:\AppPools\$using:AppPool -ErrorAction Stop |Out-Null
            Try {
                Stop-WebAppPool -Name $using:AppPool -ErrorAction Stop
                Start-Sleep -Seconds 3
                $State = Get-WebAppPoolState -Name $using:AppPool -ErrorAction Stop
                [pscustomObject]@{
                    ComputerName = $using:ComputerName
                    WebAppPool = $using:AppPool
                    State = $State.Value
                }
            }
            Catch {
                Write-Error $_
            }
        }
        Catch {
            Write-Error "$using:AppPool does not exist on $using:ComputerName"
        }
    }
}

return $Result |Select-Object -Property * -ExcludeProperty PSComputerName,RunspaceId
Remove-Session -ComputerName $ComputerName