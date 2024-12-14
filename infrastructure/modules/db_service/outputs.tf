output "endpoint" {
  value = azurerm_cosmosdb_account.cosmos_account.endpoint
}

output "primary_key" {
  value = azurerm_cosmosdb_account.cosmos_account.primary_key
}

output "private_endpoint_ip" {
  value = azurerm_private_endpoint.cosmosdb_private_endpoint.private_service_connection[0].private_ip_address
}