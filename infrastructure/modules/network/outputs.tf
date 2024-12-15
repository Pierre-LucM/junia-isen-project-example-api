
output "vnet_id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  description = "The ID of the first subnet (IP Gateway)."
  value       = azurerm_subnet.subnet_ip_gateway.id
}

output "subnet_app_id" {
  description = "The ID of the second subnet (Application)."
  value       = azurerm_subnet.subnet_app.id
}

output "subnet_db_id" {
  description = "The ID of the third subnet (Database)."
  value       = azurerm_subnet.subnet_db.id
}

output "public_ip_id" {
  description = "The ID of the Public IP."
  value       = azurerm_public_ip.public_ip.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  value       = azurerm_nat_gateway.nat_gateway.id
}