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


Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

winget install nvidia.geforceexperience
winget install kindle
winget install f.lux
winget install boinc -i
winget install microsoft.teams
winget install ShiningLight.OpenSSLLight
winget install yarn
winget install 7zip

winget install BellSoft.LibericaJDK14Full -i

winget install microsoft.dotnet
winget install microsoft.dotnetframework
winget install microsoft.dotnetpreview

dotnet tool install --global dotnet-sonarscanner
dotnet tool install --global dotnet-cleanup
dotnet tool install --global dotnet-ef --version 5.0.0-preview.8.20407.4

winget install Amazon.AWSCLI
winget install Amazon.SAM-CLI
winget install git
winget install MicrosoftGitCredentialManagerforWindows
winget install github.cli
winget install GitExtensionsTeam.GitExtensions
winget install zoom
winget install slack
winget install miniconda3 -i
winget install docker.dockerdesktopedge -i
winget install postman

# consolez `
cinst kdiff3  firacode processhacker.install  paint.net  PSWindowsUpdate  SourceCodePro  sysinternals  stylecop -y