export RES_GRP="kml_rg_main-d77e6a74799c48ae"


## Create VMSS on WebSubnet
az vmss create \
  --resource-group $RES_GRP \
  --name chan-webapp-vmss \
  --image Ubuntu2204 \
  --instance-count 2 \
  --vm-sku Standard_B2s \
  --vnet-name chan-VNet \
  --subnet chan-WebSubnet \
  --upgrade-policy-mode automatic \
  --admin-username azureuser \
  --generate-ssh-keys
  
## Create AutoScaling settings
az monitor autoscale create \
  --resource-group $RES_GRP \
  --resource chan-webapp-vmss \
  --resource-type Microsoft.Compute/virtualMachineScaleSets \
  --name chan-webapp-as \
  --min-count 2 \
  --max-count 3 \
  --count 2
  
## Add Scale-Out Rule (CPU > 70% for 5 min)
az monitor autoscale rule create \
  --resource-group $RES_GRP \
  --autoscale-name chan-webapp-as \
  --condition "Percentage CPU > 70 avg 5m" \
  --scale out 1
  
## Add Scale-In Rule (CPU < 30%)
az monitor autoscale rule create \
  --resource-group $RES_GRP \
  --autoscale-name chan-webapp-as \
  --condition "Percentage CPU < 30 avg 5m" \
  --scale in 1
