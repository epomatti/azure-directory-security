#ps1
Set-TimeZone -Id "E. South America Standard Time"

$uri="https://github.com/PowerShell/PowerShell/releases/download/v7.4.0/PowerShell-7.4.0-win-x64.msi"
$path="ps7install.msi"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -URI $uri -OutFile $path
msiexec.exe /i $path /quiet /qn /norestart

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
