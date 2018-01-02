<#
.SYNOPSIS
    Creates the DataRobot cluster in the Azure environment.
.DESCRIPTION
    Generates the complete environment required to run a DataRobot cluster, 
    including the Resource Group, VNet, Application, Data, Modeling Nodes and
    Prediction Servers, following the Azure best practice guidance.
    
    For Azure CLI 2.0 help, please visit: 
    - https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
    
    To view recomended instance types, please refer to:
    - https://azure.microsoft.com/en-us/blog/introducing-the-new-dv3-and-ev3-vm-sizes/
    
    If guidance is required when selecting which region to host the DataRobot cluster,
    please see the Azure region list:
    - https://azure.microsoft.com/en-us/regions/
.PARAMETER help
    Display script options, defaults, where to get help to run the script and exit
.PARAMETER debug
    Print debug output during script execution.
.PARAMETER resourcename
    Used as the prefix for the DataRobot cluster component parts.
    Currently defaults to: DataRobot
.PARAMETER location
    Site for where this cluster will be served from.
    Please refer to https://azure.microsoft.com/en-us/regions/ for the complete
    list and to confirm the service is available.
    Currently defaults to: eastus 
.PARAMETER image
    Use this switch to use the required Operating System.
    The current options are: rhel or centos
    Currently defaults to: centos
.PARAMETER modelnodetype
    Allows the user to change the machine size of the Modeling Node.
    The current options are: Standard_E8_v3, Standard_E16_v3, Standard_E32_v3
    Currently defaults to: Standard_E8_v3, allowing for 2 workers on the node
.PARAMETER modelnodecount
    Sets the number of modeling nodes to provision.
    Currently defaults to: 4
.PARAMETER predictionnodecount
    Sets the number of dedicated prediction servers to provision.
    Currently defaults to: 1
.PARAMETER appnodename
    Sets the name of the DataRobot Application and Data node
    Currently defaults to: AppDataNode
.PARAMETER modelnodename
    Sets the name prefix of the DataRobot Modeling node
    Currently defaults to: ModelingNode
.PARAMETER predictionnodename
    Sets the name prefix of the DataRobot dedicated prediction server
    Currently defaults to: PredictionNode    
.EXAMPLE
    C:\PS> ./Create-DataRobot-Azure-Cluster.ps1 -debug
    This command creates the default DataRobot cluster, showing the debug information
.EXAMPLE
    C:\PS> ./Create-DataRobot-Azure-Cluster.ps1 -location westus -image rhel -modelnodetype Standard_E32_v3 -modelnodecount 6 
    This command would create the DataRobot cluster in the West US region, using 6 Standard_E32_v3 modeling nodes.
.NOTES
    Author: Dennis Whitney <dennis.whitney@datarobot.com>
    Date:   January 1, 2018
#>
param(
    [Switch] $help = $false,
    [Switch] $debug = $false,
    [String] $resourcename = "DataRobot",
    [String] $location = "eastus", # Resource deployment location
    [ValidateSet("centos","rhel")] [String] $image = "centos", # Operating system. Options are Redhat or CentOS
    [String] $appnodename = "AppDataNode", # name of the Application Node
    [String] $modelnodename = "ModelingNode", # name of the Modeling Node
    [ValidateSet("Standard_E8_v3","Standard_E16_v3","Standard_E32_v3")][String] $modelnodetype = "Standard_E8_v3", # default modeling node type. good for 2 workers.
    [ValidateRange(1,50)] [Int] $modelnodecount = 4,       # number of Modeling Nodes to create
    [String] $predictionnodename = "PredictionNode",      # name of the Prediction Node
    [ValidateRange(1,50)][Int] $predictionnodecount = 1       # number of the Prediction Nodes
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
    Write-Host "If guidance is required when selecting which region to host the DataRobot cluster, please see the Azure region list: https://azure.microsoft.com/en-us/regions/"
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
$status = $( az vm create --resource-group $rg --name $appnodename --image $image --generate-ssh-keys --os-disk-size-gb 2047 )
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
