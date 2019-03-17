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