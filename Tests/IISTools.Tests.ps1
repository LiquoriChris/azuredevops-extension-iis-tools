Describe 'Disable-IISApplication' {
    It 'Should not throw' {
        New-Item -Path TestDrive:\app_offline.htm
        { Copy-Item -Path TestDrive:\app_offline.htm -Destination TestDrive:\webapp } |Should Not throw  
    }
    It 'Should return $false if cannot find file' {
        Test-Path -Path TestDrive:\app_offlne.htm -PathType Leaf |Should Be $false
    }
}

Describe 'Enable-IISApplication' {
    It 'Remove and Should not throw' {
        New-Item -Path TestDrive:\app_offline.htm
        { Remove-Item -Path TestDrive:\app_offline.htm } |Should Not throw
    }
    It 'Test file should return false after removal' {
        $Test = Test-Path -Path TestDrive:\app_offline.htm
        $Test |Should Be $false
    }
}

Describe 'Stop-IISApplicationPool' {
    It 'Should create a session' {
        New-PSSession -ComputerName localhost |Should Not BeNullOrEmpty
    }
    It 'Should stop the app pool' {
        Mock -CommandName 'Get-WebAppPoolState' -MockWith {
            return
        }
        Mock -CommandName 'Stop-WebAppPool' -MockWith {
            return $null
        }
    }
}