resource "azurerm_virtual_network" "chan-vnet" {
  name                = "chan-vnet"
  location            = var.chan_rg_location
  resource_group_name = var.chan_rg_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name             = "web-subnet"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "app-subnet"
    address_prefixes = ["10.0.2.0/24"]
    security_group   = azurerm_network_security_group.chan-appSubnet-nsg.id
  }

  tags = {
    environment = "Production"
  }
}
