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