function Split-ApplicationPoolName {
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [char]$Separator = ','
    )

    $AppPoolName = $Name.ToLower().Split($Separator)
    return ,$AppPoolName;
}

function New-Session {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ComputerName,
        [pscredential]$Credential,
        [string]$Authentication,
        [string]$ConfigurationName
    )

    $Params = @{
        ComputerName = $ComputerName
        ErrorAction = 'Stop'
    }
    if ($Credential) {
        $Params.Credential = $Credential
    }
    if ($Authentication) {
        $Params.Authentication
    }
    if ($ConfigurationName) {
        $Params.ConfigurationName = $ConfigurationName
    }
    Try {
        New-PSSession @Params 
    }
    Catch {
        throw $_
    }
}

function Remove-Session {
    param (
        [string]$ComputerName
    )

    Try {
        Remove-PSSession -ComputerName $ComputerName
    }
    Catch {
        Write-VstsTaskWarning $_
    }
}

function _Credential {
    param (
        [string]$Username,
        [string]$Password
    )

    $SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
    return New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)
}