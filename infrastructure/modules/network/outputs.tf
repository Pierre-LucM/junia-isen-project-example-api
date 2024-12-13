output "vnet_id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  description = "The ID of the Subnet."
  value       = azurerm_subnet.subnet_ip_gateway.id
}

output "subnet_app_id" {
  description = "The ID of the Subnet."
  value       = azurerm_subnet.subnet_app.id
}

output "public_ip_id" {
  description = "The ID of the Public IP."
  value       = azurerm_public_ip.public_ip.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  value       = azurerm_nat_gateway.nat_gateway.id
}

output "subnet1_id" {
  description = "ID of Subnet 1"
  value       = azurerm_subnet.subnet1.id
}

output "sql_private_endpoint_id" {
  description = "ID of the SQL Private Endpoint"
  value       = azurerm_private_endpoint.sql_private_endpoint.id
}