Import-Module posh-git

function PRB-SetPanicReadOnly
{
	$f = get-item e:\docker\images\panic.log
	$f.Attributes = $f.Attributes -band (-bnot [System.IO.FileAttributes]::ReadOnly)
}

function PRB-WindowsDocker
{
	$cwd = ${pwd}
	Set-Location -Path "C:\Program Files\Docker\Docker\"
	.\DockerCli.exe -SwitchDaemon -SwitchWindowsEngine
	Start-Sleep -s 5
	PRB-SetPanicReadOnly
	Set-Location -Path ${cwd}
}

function PRB-LinuxDocker
{
	$cwd = ${pwd}
	Set-Location -Path "C:\Program Files\Docker\Docker\"
	.\DockerCli.exe -SwitchDaemon -SwitchLinuxEngine
	Start-Sleep -s 5
	PRB-SetPanicReadOnly
	Set-Location -Path ${cwd}
}

function PRB-LoadAzurite
{
	PRB-LinuxDocker
	docker run -d --rm -p 10000:10000 -p 10001:10001 -p 10002:10002 -v /e/data-azurite:/data -v ${pwd}:/workspace mcr.microsoft.com/azure-storage/azurite:latest
}

function PRB-LoadAzCli
{
	PRB-LinuxDocker
	docker run -it --rm -v ${HOME}/.ssh:/root/.ssh -v ${pwd}:/workspace -w /workspace mcr.microsoft.com/azure-cli bash 
}

function PRB-LoadCosmosDB
{
	PRB-WindowsDocker
	$hostDirectory="$Env:RepoDir/CosmosDBEmulator/bind-mount"
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
