# PowerShell Temporary Files Deletion.  Note -Force parameter
$Dir = Get-Childitem $Env:temp -Recurse
$Dir | Remove-Item -Force
foreach ($_ in $Dir ){$count = $count +1}
"Number of files = " +$count
