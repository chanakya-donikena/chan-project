resource "azurerm_network_security_group" "chan-appSubnet-nsg" {
  name                = "chan-appSubnet-nsg"
  location            = var.chan_rg_location
  resource_group_name = var.chan_rg_name
}
