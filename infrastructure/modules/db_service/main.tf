resource "azurerm_cosmosdb_account" "cosmos_account" {
  name                = var.account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}


resource "azurerm_cosmosdb_sql_database" "sql_database" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos_account.name
}

resource "azurerm_private_endpoint" "cosmosdb_private_endpoint" {
  name                = "cosmosdb-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "cosmosdb-connection"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmos_account.id
    is_manual_connection           = false
    subresource_names              = ["Sql"]
  }
}