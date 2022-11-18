# import module
Import-Module Az.Accounts,Az.Resources,Az.Storage


# connect to Azure
Connect-AzAccount


# select subscription
$AZSubscription = Get-AzSubscription | Out-GridView -Title "Choose Subscription" -PassThru
Set-AzContext -Subscription $AZSubscription


# name Resource Group and parameters
$rgName = "rg-sprawdzone-it"
$location = "EastUS"
New-AzResourceGroup -Name $rgName -Location $location


# new VM parameters
$vmName = "vmsprawdzoneit"
$vnetName = "vnsprawdzoneit"
$subnetName = "subnetsprawdzoneit"
$NetworkSecurtityGroupName = "nsgsprawdzoneit"
$publicIPName = "pipsprawdzoneit"

# creating a new VM:
# *you will be prompted for a local administrator name and password for the VM
# *we indicate the machine type, for the purposes of the test it is the default type
# *the default is also OS VM, which in the case of Azure means that it is Windows Server
New-AzVm `
    -ResourceGroupName $rgName `
    -Name $vmName `
    -Location $location `
    -VirtualNetworkName $vnetName `
    -SubnetName $subnetName `
    -SecurityGroupName $NetworkSecurtityGroupName `
    -PublicIpAddressName $publicIPName `
    -OpenPorts 3389 


# getting the public IP address of the new VM
$rdpIP = (Get-AzPublicIpAddress -ResourceGroupName $rgName  | Select-Object IpAddress).IpAddress


# establishing a RDP connection with the VM
mstsc /v:$rdpIP