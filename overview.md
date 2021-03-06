# IIS Tools (Azure DevOps Extension)

A collection of tools to manage and interact with Microsoft IIS.

## Details

Utilizes multiple PowerShell cmdlets to interact with Microsoft IIS in the release pipeline. All tasks should work with IIS 7.0 and higher.

## Available Tasks

- DisableIISApplication: Takes a website or web application offline using the ASP.NET app_offline.htm file.
- EnableIISApplication: Removes the ASP.NET app_offline.htm to initialize the website or web application.
- StopIISAppPool: Stops one or more IIS application pools on a web server. 
- StartIISAppPool: Starts one or more IIS application pools on a web server.

## Using JEA Endpoints

If using Just Enough Administration (JEA), you must include language mode in your PSSession Configuration file. In the PSSession Role Capabilities file, please include the following:

Modules:
- ModulesToImport = 'WebAdministration'

Cmdlets:
- 'Get-WebAppPoolState'
- 'Start-WebAppPool'
- 'Stop-WebAppPool'
- 'Get-ChildItem'
- 'Start-Sleep'
- 'Copy-Item'
- 'Remove-Item'
- 'Write-Error'
- 'Out-Null'

Providers:
- 'Variable'
- 'WebAdministration'

This will allow the JEA Endpoint to run successfully when using tasks. 

## Note

PSRemoting must be enabled to run most tasks. To find out how to enable PSRemoting in your organization, please read Microsoft's official documentation.

- [Installing and Configuring WinRM](https://docs.microsoft.com/en-us/windows/desktop/winrm/installation-and-configuration-for-windows-remote-management)
- [Enable-PSRemoting Cmdlet](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/enable-psremoting?view=powershell-6)

## Contribute 

Please feel free to make suggestions, improvments, and features you would like to see added to the extension.