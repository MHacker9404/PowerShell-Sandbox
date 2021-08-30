# turn this into a method
# $cred = Get-Credential
# New-PSDRive -Name "Z" -Root "\\DESKTOP-SJHEVOO\repos" -Persist -PSProvider "FileSystem" -Credential $cred -Scope Global

# Add Git and associated utilities to the PATH
#
# NOTE: aliases cannot contain special characters, so we cannot alias
#       ssh-agent to 'ssh-agent'. The posh-git modules tries to locate
#       ssh-agent relative to where git.exe is, and that means we have
#       to put git.exe in the path and can't just alias it.
#
#
# $Env:Path = "$Env:ProgramFiles\Git\bin" + ";" + $Env:Path

# Load post-git
#
# Push-Location (Resolve-Path "$Env:USERPROFILE\Documents\GitHub\posh-git")

# Load posh-git module from current directory
#
# Import-Module .\posh-git
# if (Test-Path -LiteralPath ($modulePath = Join-Path (Get-Location) (Join-Path src 'posh-git.psd1'))) {
# Import-Module $modulePath
# }
# else {
# throw "Failed to import posh-git."
# }

# If module is installed in a default location ($Env:PSModulePath),
# use this instead (see about_Modules for more information):
Import-Module posh-git

# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt
{
	$realLASTEXITCODE = $LASTEXITCODE

	# # Reset color, which can be messed up by Enable-GitColors
	# $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

	Write-Host($pwd.ProviderPath) -nonewline
	# Write-Host($pwd.ProviderPath)

	Write-VcsStatus

	$global:LASTEXITCODE = $realLASTEXITCODE
	return "> "
}

# Override some Git colors

$s = $global:GitPromptSettings
$s.LocalDefaultStatusForegroundColor    = $s.LocalDefaultStatusForegroundBrightColor
$s.LocalWorkingStatusForegroundColor    = $s.LocalWorkingStatusForegroundBrightColor

$s.BeforeIndexForegroundColor           = $s.BeforeIndexForegroundBrightColor
$s.IndexForegroundColor                 = $s.IndexForegroundBrightColor

$s.WorkingForegroundColor               = $s.WorkingForegroundBrightColor

Pop-Location

# Start the SSH Agent, to avoid repeated password prompts from SSH
#
# Start-SshAgent -Quiet

# Start a transcript
#
# if (!(Test-Path "$Env:USERPROFILE\Documents\PowerShell\Transcripts"))
# {
#     if (!(Test-Path "$Env:USERPROFILE\Documents\PowerShell"))
#     {
#         $rc = New-Item -Path "$Env:USERPROFILE\Documents\PowerShell" -ItemType directory
#     }
#     $rc = New-Item -Path "$Env:USERPROFILE\Documents\PowerShell\Transcripts" -ItemType directory
# }
# $curdate = $(get-date -Format "yyyyMMddhhmmss")
# Start-Transcript -Path "$Env:USERPROFILE\Documents\PowerShell\Transcripts\PowerShell_transcript.$curdate.txt"


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile))
{
	Import-Module "$ChocolateyProfile"
}

function Windows-Docker
{
	Set-Location -Path "C:\Program Files\Docker\Docker"
	.\DockerCli.exe -SwitchDaemon -SwitchWindowsEngine
}

function Linux-Docker
{
	Set-Location -Path "C:\Program Files\Docker\Docker"
	.\DockerCli.exe -SwitchDaemon -SwitchLinuxEngine
}

function Load-Azurite
{
	Linux-Docker
	docker run -d --rm -p 10000:10000 -p 10001:10001 -p 10002:10002 -v /e/data-azurite:/data -v ${pwd}:/workspace mcr.microsoft.com/azure-storage/azurite:latest
}

function Load-CosmoDB
{
	Windows-Docker
	$bind_mount='e:\CosmosDBEmulator\bind-mount'
	md "${bind_mount}" 2>null
	docker run --name azure-cosmosdb-emulator --memory 2GB --mount "type=bind,source=${bind_mount},destination=C:\CosmosDB.Emulator\bind-mount" --interactive --tty -p 8081:8081 -p 8900:8900 -p 8901:8901 -p 8902:8902 -p 10250:10250 -p 10251:10251 -p 10252:10252 -p 10253:10253 -p 10254:10254 -p 10255:10255 -p 10256:10256 -p 10350:10350 mcr.microsoft.com/cosmosdb/windows/azure-cosmos-emulator
}
