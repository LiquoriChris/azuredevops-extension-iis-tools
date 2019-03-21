function _Copy {
    param (
        [string]$FilePath,
        [string]$Destination,
        [Parameter(ValueFromPipeline)]
        $ToSession
    )

    if (-Not (Test-Path -Path $FilePath -PathType Leaf)) {
        throw "Cannot find app_offline.htm in $FilePath. Verify app_offline.htm is in $FilePath."
    }
    if (-Not (Test-Path -Path $Destination -PathType Container)) {
        throw "$Destination does not exist"
    }
    Try {
        $Params = @{
            Path = $FilePath
            Destination = $Destination
        }
        if ($ToSession) {
            $Params.ToSession = $ToSession
        }
        Copy-Item @Params
        Write-Output "Copied $FilePath to $Destination"
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