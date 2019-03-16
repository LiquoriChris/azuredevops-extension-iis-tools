Describe 'Disable-IISApplication' {
    It 'Should not throw' {
        New-Item -Path TestDrive:\app_offline.htm
        { Copy-Item -Path TestDrive:\app_offline.htm -Destination TestDrive:\webapp } |Should Not throw  
    }
    It 'Should return $false if cannot find file' {
        Test-Path -Path TestDrive:\app_offlne.htm -PathType Leaf |Should Be $false
    }
}