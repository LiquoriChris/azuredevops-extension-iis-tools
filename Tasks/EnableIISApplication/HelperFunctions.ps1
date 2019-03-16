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