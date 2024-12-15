
#Vnet creation
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Subnet for IP public address and NAT gateway creation
resource "azurerm_subnet" "subnet_ip_gateway" {
  name                 = var.subnet_name_1
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Subnet for application services
resource "azurerm_subnet" "subnet_app" {
  name                 = var.subnet_name_2
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "appservice"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Subnet for database services
resource "azurerm_subnet" "subnet_db" {
  name                 = var.subnet3_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Public IP creation
resource "azurerm_public_ip" "public_ip" {
  name                = var.ip_public_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

# NAT gateway creation
resource "azurerm_nat_gateway" "nat_gateway" {
  name                = var.nat_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

# NAT gateway public IP association
resource "azurerm_nat_gateway_public_ip_association" "nat_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.public_ip.id
}

# Associate NAT Gateway with Subnet 1
resource "azurerm_subnet_nat_gateway_association" "subnet1_nat_gateway_association" {
  subnet_id      = azurerm_subnet.subnet_ip_gateway.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

# Associate NAT Gateway with Subnet 2
resource "azurerm_subnet_nat_gateway_association" "subnet2_nat_gateway_association" {
  subnet_id      = azurerm_subnet.subnet_app.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

# Associate NAT Gateway with Subnet 3
resource "azurerm_subnet_nat_gateway_association" "subnet3_nat_gateway_association" {
  subnet_id      = azurerm_subnet.subnet_db.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}
