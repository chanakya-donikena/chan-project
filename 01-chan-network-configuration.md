export RES_GRP="kml_rg_main-d77e6a74799c48ae"


## Virtual Network
az network vnet create \
  --resource-group $RES_GRP \
  --name chan-VNet \
  --address-prefix 10.0.0.0/16


## Web Subnet group    
az network vnet subnet create \
  --resource-group $RES_GRP \
  --vnet-name chan-VNet \
  --name chan-WebSubnet \
  --address-prefix 10.0.1.0/24  

## App Subnet group    
az network vnet subnet create \
  --resource-group $RES_GRP \
  --vnet-name chan-VNet \
  --name chan-AppSubnet \
  --address-prefix 10.0.2.0/24

## DB Subnet group  
az network vnet subnet create \
  --resource-group $RES_GRP \
  --vnet-name chan-VNet \
  --name chan-DbSubnet \
  --address-prefix 10.0.3.0/24
  
## Bastion Subnet group  
az network vnet subnet create \
  --resource-group $RES_GRP \
  --vnet-name chan-VNet \
  --name AzureBastionSubnet \
  --address-prefix 10.0.4.0/27
  
## Verify Subnets and Virtual Network  
az network vnet subnet list \
  --resource-group $RES_GRP \
  --vnet-name chan-VNet \
  --output table
  
  
## Create NSG
az network nsg create \
  --resource-group $RES_GRP \
  --name chan-WebSubnet-NSG

az network nsg create \
  --resource-group $RES_GRP \
  --name chan-AppSubnet-NSG

az network nsg create \
  --resource-group $RES_GRP \
  --name chan-DbSubnet-NSG
  
  
## NSG Rules for WebSubnet
# Allow HTTP
az network nsg rule create \
  --resource-group $RES_GRP \
  --nsg-name chan-WebSubnet-NSG \
  --name Allow-HTTP \
  --priority 100 \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --source-address-prefix Internet \
  --source-port-range '*' \
  --destination-port-range 80

# Allow HTTPS
az network nsg rule create \
  --resource-group $RES_GRP \
  --nsg-name chan-WebSubnet-NSG \
  --name Allow-HTTPS \
  --priority 110 \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --source-address-prefix Internet \
  --source-port-range '*' \
  --destination-port-range 443
  
  
## Allow only traffic from WebSubnet to AppSubnet
az network nsg rule create \
  --resource-group $RES_GRP \
  --nsg-name chan-AppSubnet-NSG \
  --name Allow-chan-WebSubnet \
  --priority 100 \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --source-address-prefix 10.0.1.0/24 \
  --source-port-range '*' \
  --destination-port-range '*'
  
  
##  Allow only traffic from AppSubnet to DB subnet
az network nsg rule create \
  --resource-group $RES_GRP \
  --nsg-name chan-DbSubnet-NSG \
  --name Allow-chan-AppSubnet \
  --priority 100 \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --source-address-prefix 10.0.2.0/24 \
  --source-port-range '*' \
  --destination-port-range 1433
  
  
  
## Attach NSGs to subnets
# WebSubnet
az network vnet subnet update \
  --resource-group $RES_GRP \
  --vnet-name chan-VNet \
  --name chan-WebSubnet \
  --network-security-group chan-WebSubnet-NSG

# AppSubnet
az network vnet subnet update \
  --resource-group $RES_GRP \
  --vnet-name chan-VNet \
  --name chan-AppSubnet \
  --network-security-group chan-AppSubnet-NSG

# DbSubnet
az network vnet subnet update \
  --resource-group $RES_GRP \
  --vnet-name chan-VNet \
  --name chan-DbSubnet \
  --network-security-group chan-DbSubnet-NSG
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
