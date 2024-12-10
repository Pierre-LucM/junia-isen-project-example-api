#Vnet creation
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

#Subnet for ip public adress and nat-gateway creation
resource "azurerm_subnet" "subnet_ip_gateway" {
  name                 = var.subnet_name_1
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

#Subnet for ip public adress and nat-gateway creation
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

#Public ip creation
resource "azurerm_public_ip" "public_ip" {
  name                = var.ip_public_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

#Nat gateway creation
resource "azurerm_nat_gateway" "nat_gateway" {
  name                = var.nat_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

#Nat gateway public ip association
resource "azurerm_nat_gateway_public_ip_association" "nat_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.public_ip.id
}

# Associate NAT Gateway with Subnet
resource "azurerm_subnet_nat_gateway_association" "subnet1_nat_gateway_association" {
  subnet_id      = azurerm_subnet.subnet_ip_gateway.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

# Associate NAT Gateway with Subnet 2
resource "azurerm_subnet_nat_gateway_association" "subnet2_nat_gateway_association" {
  subnet_id      = azurerm_subnet.subnet_app.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet1_address_prefix]
}

resource "azurerm_private_endpoint" "sql_private_endpoint" {
  name                = "sql-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.subnet1.id

  private_service_connection {
    name                           = "sql-connection"
    private_connection_resource_id = var.sql_server_id
    is_manual_connection           = false
  }
}