oh-my-posh.exe init pwsh | Invoke-Expression

function vci
{
    $param1 = $args[0]
    code-insiders $param1
}

function restartDocker
{
    $processes = Get-Process '*docker desktop*'
    if ($processes.Count -gt 0)
    {
        $processes[0].Kill()
        $processes[0].WaitForExit()
    }
    Start-Process 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
}

function checkDocker
{
    Set-Location $env:LOCALAPPDATA/Docker/wsl/
    Get-ChildItem -Recurse
}

function Move-Docker-Data
{
    wsl --export docker-desktop-data 'd:/wsl/docker-desktop-data/data.tar'
    wsl --unregister docker-desktop-data
    wsl --import docker-desktop-data 'D:/wsl/docker-desktop-data' 'd:/wsl/docker-desktop-data/data.tar'
}

function PRB-LinuxDocker
{
    PRB-SetPanicReadOnly
    $cwd = ${pwd}
    Set-Location -Path 'C:\Program Files\Docker\Docker\'
    .\DockerCli.exe -SwitchLinuxEngine
    Start-Sleep -s 5
    Set-Location -Path ${cwd}
}

function PRB-LoginGovAzure
{
    az cloud set --name AzureUSGovernment
    az login
}

function PRB-LoginCommercialAzure
{
    az cloud set --name AzureCloud
    az login
}

function PRB-LoadAzurite
{
    PRB-LinuxDocker
    docker run -d --rm -p 10000:10000 -p 10001:10001 -p 10002:10002 -v /e/data-azurite:/data -v ${pwd}:/workspace mcr.microsoft.com/azure-storage/azurite:latest
}

function PRB-LoadCosmosDB
{
    PRB-WindowsDocker
    $hostDirectory = "$Env:RepoDir/CosmosDBEmulator/bind-mount"
    Set-Location -Path "$Env:RepoDir"
    md "${hostDirectory}" 2>null
    Set-Location -Path "$Env:RepoDir/docker-sandbox/"
    # docker compose -f ./docker-compose.cosmosdb.yml up -d
    docker run -d --rm `
        --name cosmosdb `
        --memory 3GB `
        --mount "type=bind,source=${hostDirectory},destination=C:\CosmosDB.Emulator\bind-mount"  `
        --tty `
        -p 8081:8081 `
        -p 8900:8900 `
        -p 8901:8901 `
        -p 8902:8902 `
        -p 10250:10250 `
        -p 10251:10251 `
        -p 10252:10252 `
        -p 10253:10253 `
        -p 10254:10254 `
        -p 10255:10255 `
        -p 10256:10256 `
        -p 10350:10350 mcr.microsoft.com/cosmosdb/windows/azure-cosmos-emulator
    Set-Location -Path ${hostDirectory}
    ./importcert.ps1
}