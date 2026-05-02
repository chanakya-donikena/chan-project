resource "azurerm_virtual_network" "engineering-dev-vnet" {
  name                = "Engineering-Dev-VNet"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "Development"
    department  = "Engineering"
  }
}

resource "azurerm_subnet" "webSubnet" {
  name                 = "Engineering-Dev-Web-Subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.engineering-dev-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "appSubnet" {
  name                 = "Engineering-Dev-App-Subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.engineering-dev-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "dbSubnet" {
  name                 = "Engineering-Dev-DB-Subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.engineering-dev-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_network_security_group" "dbSubnet-nsg" {
  name                = "DB-Subnet-NSG"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-app-to-db"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.2.0/24" # App Subnet
    destination_address_prefix = "10.0.3.0/24" # DB Subnet
  }

  tags = {
    environment = "Development"
    department  = "Engineering"
  }
}

resource "azurerm_network_security_group" "appSubnet-nsg" {
  name                = "App-Subnet-NSG"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-web-to-app"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24" # Web Subnet
    destination_address_prefix = "10.0.2.0/24" # App Subnet
  }

  tags = {
    environment = "Development"
    department  = "Engineering"
  }
}

resource "azurerm_network_security_group" "webSubnet-nsg" {
  name                = "Web-Subnet-NSG"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"           # Public
    destination_address_prefix = "10.0.1.0/24" # Web Subnet
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"           # Public
    destination_address_prefix = "10.0.1.0/24" # Web Subnet
  }

  tags = {
    environment = "Development"
    department  = "Engineering"
  }
}
