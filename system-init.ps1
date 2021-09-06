$activationKey = $args[0]
$targetName = $args[1]


Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Confirm
SLMGR /ipk $activationKey

# rename the system with no restart
# Write-Host 'Enter new system name:';
# $targetName = Read-Host;
Rename-Computer -NewName $targetName

# $DataStamp = get-date -Format yyyyMMddTHHmmss
# $logFile = '{0}-{1}.log' -f $file.fullname,$DataStamp
# $MSIArguments = @(
# 	"/i"
#     ('"{0}"' -f $file.fullname)
# 	"/qn"
# 	"/norestart"
# 	"/L*v"
# 	$logFile
# )

# install powershell
# iex "& { $(irm https://aka.ms/install-powershell.ps1) } -Preview -Destination 'C:\Program Files\PowerShell\' -AddToPath"
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -Preview -UseMSI"
Install-Module –Name PowerShellGet –Force
Install-Module –Name PowerShellGet –Force -AllowClobber
Update-Module -Name PowerShellGet

# # http://woshub.com/using-winget-package-manager-windows/
$file = 'wsl-update.msi'
$DownloadFile = Join-Path -Path (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path -ChildPath $file
Invoke-WebRequest -Uri 'https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi' -OutFile $DownloadFile
# https://powershellexplained.com/2016-10-21-powershell-installing-msi-files/
Start-Process 'msiexec.exe' -ArgumentList "/i $DownloadFile /qn /norestart" -Wait -NoNewWindow 

# install winget
# https://www.andreasnick.com/112-install-winget-and-appinstaller-on-windows-server-2022.html
# Install-VCLibs.140.00 Version 14.0.30035
# Andreas Nick 2021
$StoreLink = 'https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1'
$StorePackageName = 'Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x64__8wekyb3d8bbwe.appx'
$RepoName = 'AppPAckages'
$RepoLokation = $env:Temp
$Packagename = 'Microsoft.VCLibs.140.00'
$RepoPath = Join-Path $RepoLokation -ChildPath $RepoName 
$RepoPath = Join-Path $RepoPath -ChildPath $Packagename
#
# Function Source
# Idea from: https://serverfault.com/questions/1018220/how-do-i-install-an-app-from-windows-store-using-powershell
# modificated version. Now able to filter and return msix url's
#
function Download-AppPackage {
	[CmdletBinding()] 
	param ( 
		[string]$Uri, 
		[string]$Filter = '.*' #Regex
	)
	process {
		#$Uri=$StoreLink
		$WebResponse = Invoke-WebRequest -UseBasicParsing -Method 'POST' -Uri 'https://store.rg-adguard.net/api/GetFiles' -Body "type=url&url=$Uri&ring=Retail" -ContentType 'application/x-www-form-urlencoded'
		$result = $WebResponse.Links.outerHtml | Where-Object { ($_ -like '*.appx*') -or ($_ -like '*.msix*') } | Where-Object { $_ -like '*_neutral_*' -or $_ -like '*_' + $env:PROCESSOR_ARCHITECTURE.Replace('AMD', 'X').Replace('IA', 'X') + '_*' } | ForEach-Object {
			$result = '' | Select-Object -Property filename, downloadurl
			if ( $_ -match '(?<=rel="noreferrer">).+(?=</a>)' ) {
				$result.filename = $matches.Values[0]
			}
			if ( $_ -match '(?<=a href=").+(?=" r)' ) {
				$result.downloadurl = $matches.Values[0]
			}
			$result
		} 
    
		$result | Where-Object -Property filename -Match $filter 
	}
}

$package = Download-AppPackage -Uri $StoreLink -Filter $StorePackageName
if (-not (Test-Path $RepoPath )) {
	New-Item $RepoPath -ItemType Directory -Force
}
if (-not (Test-Path (Join-Path $RepoPath -ChildPath $package.filename ))) {
	Invoke-WebRequest -Uri $($package.downloadurl) -OutFile (Join-Path $RepoPath -ChildPath $package.filename )
}
else {
	Write-Information "The file $($package.filename) already exist in the repo. Skip download"
}

#Install the Runtime
add-AppPackage (Join-Path $RepoPath -ChildPath $package.filename )

# Install-Winget Version v1.0.11692
# Andreas Nick 2021
# From github
$WinGet_Link = 'https://github.com/microsoft/winget-cli/releases/download/v1.0.11692/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
$WinGet_Name = 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'

$RepoName = 'AppPAckages'
$RepoLokation = $env:Temp
$Packagename = 'Winget'

$RepoPath = Join-Path $RepoLokation -ChildPath $RepoName 
$RepoPath = Join-Path $RepoPath -ChildPath $Packagename

if (-not (Test-Path $RepoPath )) {
	New-Item $RepoPath -ItemType Directory -Force
}

if (-not (Test-Path (Join-Path $RepoPath -ChildPath $WinGet_Name ))) {
	Invoke-WebRequest -Uri $WinGet_Link -OutFile (Join-Path $RepoPath -ChildPath $WinGet_Name )
}
else {
	Write-Information "The file $WinGet_Name already exist in the repo. Skip download"
}

#Install the Package
Add-AppPackage (Join-Path $RepoPath -ChildPath $WinGet_Name)

winget install Microsoft.WindowsTerminalPreview

# Turn Windows features on or off
# dism.exe /online /Get-Features
# https://weblog.west-wind.com/posts/2017/may/25/automating-iis-feature-installation-with-powershell
# To list all Windows Features: dism /online /Get-Features
# Get-WindowsOptionalFeature -Online 
# LIST All IIS FEATURES: 
# Get-WindowsOptionalFeature -Online | where FeatureName -like 'IIS-*'

Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer
Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpErrors
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment

Enable-WindowsOptionalFeature -Online -FeatureName NetFx4Extended-ASPNET45
Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility45

Enable-WindowsOptionalFeature -Online -FeatureName IIS-HealthAndDiagnostics
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpLogging
Enable-WindowsOptionalFeature -Online -FeatureName IIS-LoggingLibraries
Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestMonitor
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpTracing
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Security
Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestFiltering
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Performance
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerManagementTools
Enable-WindowsOptionalFeature -Online -FeatureName IIS-IIS6ManagementCompatibility
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Metabase
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementConsole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-BasicAuthentication
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WindowsAuthentication
Enable-WindowsOptionalFeature -Online -FeatureName IIS-StaticContent
Enable-WindowsOptionalFeature -Online -FeatureName IIS-DefaultDocument
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebSockets
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationInit
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIExtensions
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIFilter
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionStatic

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45

Import-Module WebAdministration

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Containers -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM -NoRestart

Enable-WindowsOptionalFeature -Online -FeatureName MSMQ-Container -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName MSMQ-DCOMProxy -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName MSMQ-Server -NoRestart
# requires IIS
# Enable-WindowsOptionalFeature -OnLine -FeatureName MSMQ-HTTP -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName MSMQ-Multicast -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName MSMQ-Triggers -NoRestart

Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -NoRestart

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart
Restart-Computer

# https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package
wsl --set-default-version 2

Install-Module -Name posh-git 

Install-Module -Name PSWindowsUpdate -Force
Get-WindowsUpdate -Download
Install-WindowsUpdate

# install updates
winget install Microsoft.VC++2005Redist-x86
winget install Microsoft.VC++2005Redist-x64

winget install Microsoft.VC++2008Redist-x86
winget install Microsoft.VC++2008Redist-x64

winget install Microsoft.VC++2010Redist-x86
winget install Microsoft.VC++2010Redist-x64

winget install Microsoft.VC++2012Redist-x86
winget install Microsoft.VC++2012Redist-x64

winget install Microsoft.VC++2013Redist-x86
winget install Microsoft.VC++2013Redist-x64

winget install Microsoft.VC++2015-2019Redist-x86
winget install Microsoft.VC++2015-2019Redist-x64

winget install Microsoft.VC++2017Redist-x86
winget install Microsoft.VC++2017Redist-x64

winget install Microsoft.VisualStudioCode
winget install Microsoft.Microsoft.VisualStudio.2019.Enterprise-Preview -i
winget install Microsoft.Microsoft.VisualStudio.2022.Enterprise-Preview -i
winget install Microsoft.SQLServerManagementStudio -i

winget install microsoft.dotnet
winget install microsoft.dotnetframework
winget install microsoft.dotnetpreview

dotnet tool install --global dotnet-sonarscanner
dotnet tool install --global dotnet-cleanup
dotnet tool install --global dotnet-ef

winget install nvidia.geforceexperience

winget install Oracle.VirtualBox -i

winget install 7zip.7zip
winget install LINQPad.LINQPad.6
winget install amazon.kindle
winget install f.lux
winget install boinc -i
winget install Telerik.Fiddler
winget install Mozilla.FirefoxDeveloperEdition
winget install Google.Chrome.Beta
winget install Google.Chrome.Dev
winget install CrystalDewWorld.CrystalDiskInfo
winget install IObitUninstall

winget install docker.dockerdesktopedge -i
winget install Git.Git
winget install github.cli
winget install GitExtensionsTeam.GitExtensions
winget install TortoiseGit.TortoiseGit
winget install Microsoft.GitCredentialManagerCore`
winget install zoom
winget install slack
winget install postman
winget install JoachimEibl.KDiff3
winget install JetBrains.ReSharper.EarlyAccess -i
winget install Kubernetes.minikube

winget install Adobe.AdobeAcrobatReaderDC
winget install Garmin.GarminExpress
winget install Samsung.SmartSwitch

[System.Environment]::SetEnvironmentVariable('ChocolateyInstall', 'd:\\programdata\\chocolatey', [System.EnvironmentVariableTarget]::Machine)
Set-ExecutionPolicy Bypass -Scope Process -Force; `
	[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
	iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

cinst firacode paint.net SourceCodePro -y

# reboot
Get-WindowsUpdate -Download
Install-WindowsUpdate
Restart-Computer