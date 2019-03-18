[CmdletBinding()]
param ()

$ComputerName = Get-VstsInput -Name 'computerName'
$AppPools = Get-VstsInput -Name 'appPools'

. $PSScriptRoot\HelperFunctions.ps1

$AppPoolName = Split-ApplicationPoolName -Name $AppPools
$Session = New-PSSession -ComputerName $ComputerName
$Result = foreach ($AppPool in $AppPoolName) {
    Invoke-Command -Session $Session -ScriptBlock {
        Try {
            Import-Module WebAdministration -Force
            Get-ChildItem -Path IIS:\AppPools\$using:AppPool -ErrorAction Stop |Out-Null
            Try {
                Start-WebAppPool -Name $using:AppPool -ErrorAction Stop
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