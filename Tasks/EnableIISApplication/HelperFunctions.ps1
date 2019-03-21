function _Remove {
    param (
        [string]$Path
    )

    $File = 'app_offline.htm'
    $SplitPath = Split-Path -Path $Path -Leaf
    if ($SplitPath -ne $File) {
        $Path = "$Path\$File"
    }
    Try {
        $Params = @{
            Path = $Path
            Force = $true
            Confirm = $false
            ErrorAction = 'Stop'
        }
        Remove-Item @Params
        $Path = Split-Path -Path $Path -Parent
        Write-Output "Removed $File from $Path"
    }
    Catch {
        throw $_
    }
}

function Split-TargetComputer {
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,
        [char]$Separator = ','
    )

    $TargetComputerName = $ComputerName.ToLower().Split($Separator)
    return ,$TargetComputerName;
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