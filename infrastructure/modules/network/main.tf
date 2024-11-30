resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

#Vnet creation
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

#Subnet for ip public adress and nat-gateway creation
resource "azurerm_subnet" "subnet_ip_gateway" {
  name                 = var.subnet_name_1
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

#Public ip creation
resource "azurerm_public_ip" "public_ip" {
  name                = var.ip_public_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

#Nat gateway creation
resource "azurerm_nat_gateway" "nat_gateway" {
  name                = var.nat_gateway_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
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