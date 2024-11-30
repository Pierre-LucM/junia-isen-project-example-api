output "resource_group_name" {
  description = "The name of the created resource group."
  value       = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  description = "The name of the created virtual network."
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_name_1" {
  description = "The name of the created subnet 1."
  value       = azurerm_subnet.subnet_ip_gateway.name
}

output "nat_gateway_name" {
  description = "The name of the created NAT gateway."
  value       = azurerm_nat_gateway.nat_gateway.name
}