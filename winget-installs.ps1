winget install nvidia.geforceexperience
winget install kindle
winget install f.lux
winget install boinc -i

Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

winget install microsoft.teams
winget install ShiningLight.OpenSSLLight
winget install yarn
winget install 7zip
winget install microsoft.dotnet
winget install microsoft.dotnetframework
winget install microsoft.dotnetpreview
winget install BellSoft.LibericaJDK14Full
dotnet tool install --global dotnet-sonarscanner
dotnet tool install --global dotnet-cleanup
dotnet tool install --global dotnet-ef --version 5.0.0-preview.8.20407.4
winget install aws-cli
winget install git
winget install MicrosoftGitCredentialManagerforWindows
winget install github.cli
winget install GitExtensionsTeam.GitExtensions
winget install zoom
winget install slack
winget install miniconda3
winget install docker.dockerdesktopedge -i
winget install postman

# consolez `
cinst kdiff3  firacode processhacker.install  paint.net  PSWindowsUpdate  SourceCodePro  sysinternals  stylecop -y