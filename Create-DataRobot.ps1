<#
.SYNOPSIS
    Creates the DataRobot cluster in the Azure environment.
.DESCRIPTION
    Generates the complete environment required to run a DataRobot cluster, 
    including the Resource Group, VNet, Application, Data, Modeling Nodes and
    Prediction Servers
.PARAMETER Path
    The path to the .
.PARAMETER LiteralPath
    Specifies a path to one or more locations. Unlike Path, the value of 
    LiteralPath is used exactly as it is typed. No characters are interpreted 
    as wildcards. If the path includes escape characters, enclose it in single
    quotation marks. Single quotation marks tell Windows PowerShell not to 
    interpret any characters as escape sequences.
.EXAMPLE
    C:\PS> 
    <Description of example>
.NOTES
    Author: Dennis Whitney <dennis.whitney@datarobot.com>
    Date:   January 1, 2018
#>
param(
    [Switch] $help = $false,
    [Switch] $debug = $false,
    [String] $resourcename = "DataRobot",
#    [string] $rg  = "DataRobotResourceGroup",   # Resource group for this cluster
    [String] $location = "eastus", # Resource deployment location
    [ValidateSet("centos","rhel")] [String] $image = "centos", # Operating system. Options are Redhat or CentOS
    [String] $appnodename = "AppDataNode", # name of the Application Node
    [String] $modelnodename = "ModelingNode", # name of the Modeling Node
    [ValidateSet("Standard_E8_v3","Standard_E16_v3","Standard_E32_v3")][String] $modelnodetype = "Standard_E8_v3", # default modeling node type. good for 2 workers.
    [ValidateRange(1,50)] [Int] $modelnodecount = 4,       # number of Modeling Nodes to create
    [String] $predictionnodename = "PredictionNode",      # name of the Modeling Node
    [ValidateRange(1,50)][Int] $predictionnodecount = 1       # name of the Modeling Node
)

$rg = $resourcename + "ResourceGroup"
$vnet = $resourcename + "VNet"

if ($debug -eq $true -OR $help -eq $true) {
    Write-Host "Resource Group: $rg"
    Write-Host "Virtual Network: $vnet"
    Write-Host "Location: $location"
    Write-Host "Image: $image"
    Write-Host "App Node Name: $appnodename"
    Write-Host "Model Node Name: $modelnodename"
    Write-Host "Model Node Count: $modelnodecount"
    Write-Host "Prediction Node Name: $predictionnodename"
    Write-Host "Prediction Node Count: $predictionnodecount"
}
if ($help -eq $true) {
    Write-Host "For CLI setup help, please visit: 'https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest'"
    Write-Host "To view recomended instance types, please refer to 'https://azure.microsoft.com/en-us/blog/introducing-the-new-dv3-and-ev3-vm-sizes/'"
    exit
}

$status = $( az login )
if ($debug -eq $true) { Write-Host "Login Status=>$status" }
else { Write-Host "Logged in to Azure" }

$status = $( az group create --name $rg --location $location --tags name="DataRobot Resource Group" )
if ($debug -eq $true) { Write-Host "$rg Resource Group status=>$status" }
else { Write-Host "Created Resource Group: $rg" }

# Create App node
# TODO: Upgrade to handle ha
#--size Standard_E8_v3
$status = $( az vm create --resource-group $rg --name $appnodename --image $image --generate-ssh-keys --os-disk-size-gb 100 )
if ($debug -eq $true) { Write-Host "$appnodename VM creation status=>$status" }
else { Write-Host "Created App Node VM: $appnodename" }

# Create Modeling nodes
for ($i=1; $i -le $modelnodecount; $i++) {
    $node = $modelnodename + $i
    #--size $modelnodetype
    $status = $( az vm create --resource-group $rg --name $node --image $image --os-disk-size-gb 100 )
    if ($debug -eq $true) { Write-Host "$node VM creation status=>$status" }
    else { Write-Host "Created Modeling Node: $node" }
}

# Create Prediction Server nodes
for ($i=1; $i -le $predictionnodecount; $i++) {
    $node = $predictionnodename + $i
    #--size Standard_E4_v3 
    $status = $( az vm create --resource-group $rg --name $node --image $image --os-disk-size-gb 100 )
    if ($debug -eq $true) { Write-Host "$node VM creation status=>$status" }
    else { Write-Host "Created Prediction Node: $node" }
}

# Log out of Azure
az logout
