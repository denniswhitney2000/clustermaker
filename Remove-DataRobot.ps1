# Define header
param(
    [switch] $help = $false,
    [switch] $debug = $false,
    [string] $rg  = "DataRobotResourceGroup"   # Resource group for this cluster
)

if ($help -eq $true) {
    Write-Host "For CLI setup help, please visit: 'https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest'"
}

if ($debug -eq $true) {
    Write-Host "Resource Group: $rg"
}

$status = $( az login )
if ($debug -eq $true) { Write-Host "Login Status=>$status" }
else { Write-Host "Logged in Azure" }

#az group delete --name $rg
$status = $( az group delete --name $rg )
if ($debug -eq $true) { Write-Host "$rg Resource Group status=>$status" }
else { Write-Host "Deleted Resource Group: $rg" }
