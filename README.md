# Create-DataRobot-Azure-Cluster.ps1

NAME
    Create-DataRobot-Azure-Cluster.ps1

SYNOPSIS
    Creates the DataRobot cluster in the Azure environment.

SYNTAX
    Create-DataRobot-Azure-Cluster.ps1 -help -debug -resourcename &lt;String&gt; -location &lt;String&gt; -image &lt;String&gt; -appnodename &lt;String&gt; -modelnodename &lt;String&gt; -modelnodetype &lt;String&gt; -modelnodecount &lt;Int32&gt; -predictionnodename &lt;String&gt; -predictionnodecount &lt;Int32&gt;

DESCRIPTION
    Generates the complete environment required to run a DataRobot cluster, including the Resource Group, VNet, Application, Data, Modeling Nodes and Prediction Servers, following the Azure best practice guidance.

    For Azure CLI 2.0 help, please visit:
    - https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

    To view recomended instance types, please refer to:
    - https://azure.microsoft.com/en-us/blog/introducing-the-new-dv3-and-ev3-vm-sizes/

    If guidance is required when selecting which region to host the DataRobot cluster,
    please see the Azure region list:
    - https://azure.microsoft.com/en-us/regions/

PARAMETERS

    -help
        Display script options, defaults, where to get help to run the script and exit

    -debug
        Print debug output during script execution.

    -resourcename &lt;String&gt;
        Used as the prefix for the DataRobot cluster component parts.
        Currently defaults to: DataRobot

    -location &lt;String&gt;
        Location where this cluster will be served from.
        Please refer to https://azure.microsoft.com/en-us/regions/ for the complete list and to confirm the service is available.
        Currently defaults to: eastus

    -image &lt;String&gt;
        Use this switch to use the required Operating System.
        The current options are: rhel or centos
        Currently defaults to: centos

    -appnodename &lt;String&gt;
        Sets the name of the DataRobot Application and Data node
        Currently defaults to: AppDataNode

    -modelnodename &lt;String&gt;
        Sets the name prefix of the DataRobot Modeling node
        Currently defaults to: ModelingNode

    -modelnodetype &lt;String&gt;
        Allows the user to change the machine size of the Modeling Node.
        The current options are: Standard_E8_v3, Standard_E16_v3, Standard_E32_v3
        Currently defaults to: Standard_E8_v3, allowing for 2 workers on the node

    -modelnodecount &lt;Int32&gt;
        Sets the number of modeling nodes to provision.
        Currently defaults to: 4

    -predictionnodename &lt;String&gt;
        Sets the name prefix of the DataRobot dedicated prediction server
        Currently defaults to: PredictionNode

    -predictionnodecount &lt;Int32&gt;
        Sets the number of dedicated prediction servers to provision.
        Currently defaults to: 1

    -------------------------- EXAMPLE 1 --------------------------

    C:\PS&gt;./Create-DataRobot-Azure-Cluster.ps1 -debug

    This command creates the default DataRobot cluster, showing the debug information

    -------------------------- EXAMPLE 2 --------------------------

    C:\PS&gt;./Create-DataRobot-Azure-Cluster.ps1 -location westus -image rhel -modelnodetype Standard_E32_v3 -modelnodecount 6

    This command would create the DataRobot cluster in the West US region, using 6 Standard_E32_v3 modeling nodes.

REMARKS
    To see the examples, type: "Get-Help Create-DataRobot-Azure-Cluster.ps1 -examples".
    For more information, type: "Get-Help Create-DataRobot-Azure-Cluster.ps1 -detailed".
    For technical information, type: "Get-Help Create-DataRobot-Azure-Cluster.ps1 -full".
