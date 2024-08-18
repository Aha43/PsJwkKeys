$ModuleName = 'PsJwkKeys'
$ModulePath = "./${ModuleName}/${ModuleName}.psm1"
Import-Module -Name $ModulePath
Write-Output "Module ${ModuleName} imported successfully."