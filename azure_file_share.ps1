#sprawdzone.it
#Azure File Share creator
#https://github.com/sprawdzoneit/azure
#version 1.0


#import modules
Import-Module Az.Accounts,Az.Resources,Az.Storage

#load powerhhell gui
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') 


#logon to Azure
Connect-AzAccount

#select subscription
$AZSubscription = Get-AzSubscription | Out-GridView -Title "Choose Subscription" -PassThru
Set-AzContext -Subscription $AZSubscription



#location
$Location = [Microsoft.VisualBasic.Interaction]::InputBox("Enter location: ", "Location name", "eastus")

#name Resource Group
$ResourceGroup = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Resource Group: ", "Resource Group name", "rg-sprawdzoneit-testy")

#name Storage Account
$StorageAccount = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Storage Account: ", "Storage account name", "sasprawdzoneittesty")

#name File Share
$FileShare = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Storage Account: ", "Storage account name", "fssprawdzoneittesty")




#a condition to check if there is already a Resource Group with the given name    
if(Get-AzResourceGroup -Name $ResourceGroup -ErrorAction SilentlyContinue)  
    {  
         #message on the screen
         Write-Host -BackgroundColor Yellow -ForegroundColor Black $ResourceGroup " Warning: Resource Group with this name already exists!"  
    }  
    else  
    {  
         #message on the screen
         Write-Host -ForegroundColor Green $ResourceGroup "  Resource Group with this name don't exist. Creating. "  
 
         #create a Resource Group with a specific name and in a specific location
         New-AzResourceGroup -Name $ResourceGroup -Location $Location  
    }  



#a condition to check if there is already a Storage Account with the given name  
if(Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageAccount -ErrorAction SilentlyContinue)  
    {  
         #message on the screen
         Write-Host -BackgroundColor Yellow -ForegroundColor Black $StorageAccount " Warning: Storage Account with this name already exists!"     
    }  
    else  
    {  
         #message on the screen
         Write-Host -ForegroundColor Green $StorageAccount " Storage Account with this name don't exist. Creating. "  
 
         #create a Storage Account in a specific group of resources, with a specific name and location, select the SKU and type
         New-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageAccount -Location $location -SkuName Standard_LRS -Kind StorageV2
    }  



#a condition to check if there is already a File Share with the given name 
if(Get-AzRmStorageShare -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccount -Name $FileShare -ErrorAction SilentlyContinue)  
    {  
         #message on the screen
         Write-Host -BackgroundColor Yellow -ForegroundColor Black $FileShare " Warning: File Share with this name already exists!"     
    }  
    else  
    { 
         #message on the screen 
         Write-Host -ForegroundColor Green $StorageAccount " File Share with this name don't exist. Creating. "  
 
         #we create File Share in a specific group of resources, in a given Storage Account, with a specific name, at a given level of access and at a given Quota
         New-AzRmStorageShare -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccount -Name $FileShare -AccessTier Hot -QuotaGiB 1024
    }  


#logout from Azure
Disconnect-AzAccount