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