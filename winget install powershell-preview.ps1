winget install powershell-preview
winget install Microsoft.WindowsTerminalPreview


# Turn Windows features on or off
# dism.exe /online /Get-Features

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
Enable-WindowsOptionalFeature -OnLine -FeatureName Containers -NoRestart
Enable-WindowsOptionalFeature -OnLine -FeatureName Containers-DisposableClientVM -NoRestart

Enable-WindowsOptionalFeature -OnLine -FeatureName MSMQ-Container -NoRestart
Enable-WindowsOptionalFeature -OnLine -FeatureName MSMQ-DCOMProxy -NoRestart
Enable-WindowsOptionalFeature -OnLine -FeatureName MSMQ-Server -NoRestart
# requires IIS
# Enable-WindowsOptionalFeature -OnLine -FeatureName MSMQ-HTTP -NoRestart
Enable-WindowsOptionalFeature -OnLine -FeatureName MSMQ-Multicast -NoRestart
Enable-WindowsOptionalFeature -OnLine -FeatureName MSMQ-Triggers -NoRestart

Enable-WindowsOptionalFeature -OnLine -FeatureName HypervisorPlatform -NoRestart

Enable-WindowsOptionalFeature -OnLine -Featurename Microsoft-Windows-Subsystem-Linux -All -NoRestart
Enable-WindowsOptionalFeature -OnLine -Featurename VirtualMachinePlatform -All -NoRestart

wsl --set-default-version 2

Install-Module -Name posh-git 

Install-Module PSWindowsUpdate
Get-WindowsUpdate
Install-WindowsUpdate

Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu -OutFile ~/ubuntu.zip -UseBasicParsing
Expand-Archive ./ubuntu.zip ./wsl-ubuntu