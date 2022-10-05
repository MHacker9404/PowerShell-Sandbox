(@(&'C:/Users/philb/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe' init pwsh --config="C:\Users\philb\AppData\Local\oh-my-posh\config.omp.json" --print) -join "`n") | Invoke-Expression

function vci
{
    $param1 = $args[0]
    code-insiders $param1
}

function conda {
    docker run -i -t -p 8888:8888 --mount source=jupyter, target=/opt/notebooks continuumio/anaconda3 /bin/bash -c 'conda install jupyter -y --quiet mkdir -p /opt/notebooks jupyter notebook' `
        " --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root"
}

function stopDocker
{
    $processes = Get-Process '*docker desktop*'
    if ($processes.Count -gt 0)
    {
        $processes[0].Kill()
        $processes[0].WaitForExit()
    }
}

function restartDocker
{
    stopDocker
    Start-Process 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
}

function checkDocker
{
    Set-Location $env:LOCALAPPDATA/Docker/wsl/
    Get-ChildItem -Recurse
}

function Move-Docker-Data
{
    wsl --shutdown
    wsl --export docker-desktop-data 'd:/wsl/docker-desktop-data/data.tar'
    wsl --unregister docker-desktop-data
    wsl --import docker-desktop-data 'D:/wsl/docker-desktop-data' 'd:/wsl/docker-desktop-data/data.tar'
}

function Move-Debian
{
    wsl --shutdown
    wsl --export Debian 'd:/wsl/debian/data.tar'
    wsl --unregister Debian
    wsl --import Debian 'D:/wsl/debian' 'd:/wsl/debian/data.tar'
}

function Move-Ubuntu
{
    wsl --shutdown
    wsl --export Ubuntu 'd:/wsl/ubuntu/data.tar'
    wsl --unregister Ubuntu
    wsl --import Ubuntu 'D:/wsl/ubuntu' 'd:/wsl/ubuntu/data.tar'
}

function Move-Ubuntu-Preview
{
    wsl --shutdown
    wsl --export Ubuntu-Preview 'd:/wsl/ubuntu-preview/data.tar'
    wsl --unregister Ubuntu-Preview
    wsl --import Ubuntu-Preview 'D:/wsl/ubuntu-preview' 'd:/wsl/ubuntu-preview/data.tar'
}

function PRB-LoginCommercialAzure
{
    az cloud set --name AzureCloud
    az login
}

function PRB-LoadAzurite
{
    docker run -d --rm -p 10000:10000 -p 10001:10001 -p 10002:10002 -v /e/data-azurite:/data -v ${pwd}:/workspace mcr.microsoft.com/azure-storage/azurite:latest
}

function DefaultSetup
{
    wsl --set-default-version 2

    winget install --id Bitdefender.Bitdefender

    winget install --id Git.Git
    winget install --id github.cli
    winget install --id docker.dockerdesktopedge
    winget install --id JoachimEibl.KDiff3
    winget install --id Microsoft.PowerShell.Preview
    winget install --id Microsoft.WindowsTerminalPreview
    winget install --id JanDeDobbeleer.OhMyPosh
    winget install --id CoreyButler.NVMforWindows
    winget install --id 7zip.7zip
    winget install --id Postman.Postman
    winget install --id Mirantis.Lens
    winget install --id Google.Chrome.Beta
    winget install --id GitExtensionsTeam.GitExtensions
    winget install --id TortoiseGit.TortoiseGit
    winget install --id Microsoft.GitCredentialManagerCore

    winget install --id Microsoft.SQLServer.2019.Express -i
    winget install --id Microsoft.VisualStudio.2022.Professional -i

    winget install --id microsoft.dotnet.sdk.preview
    winget install --id microsoft.dotnet.sdk.6
    winget install --id microsoft.dotnet.runtime.5
    winget install --id microsoft.dotnetframework

    dotnet tool install --global dotnet-sonarscanner
    dotnet tool install --global dotnet-cleanup
    dotnet tool install --global dotnet-ef

    winget install --id LINQPad.LINQPad.7
    winget install --id Telerik.Fiddler

    winget install --id nvidia.geforceexperience
    winget install --id Oracle.VirtualBox -i

    winget install --id amazon.kindle
    winget install --id f.lux
    winget install --id UCBerkeley.BOINC -i

    winget install --id CrystalDewWorld.CrystalDiskInfo

    winget install --id IObit.AdvancedSystemCare
    winget install --id IObit.Uninstaller

    winget install --id Zoom.Zoom
    winget install --id Zoom.Zoom.OutlookPlugin
    winget install --id SlackTechnologies.Slack
    winget install --id Adobe.AdobeAcrobatReaderDC
    winget install --id Garmin.GarminExpress
    winget install --id Samsung.SmartSwitch

    
    [System.Environment]::SetEnvironmentVariable('ChocolateyInstall', 'd:\\programdata\\chocolatey', [System.EnvironmentVariableTarget]::Machine)
    Set-ExecutionPolicy Bypass -Scope Process -Force; `
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

    cinst firacode paint.net SourceCodePro -y

    Install-Module PSWindowsUpdate
    Get-WindowsUpdate
    Install-WindowsUpdate
}