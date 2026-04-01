# Random password for SQL Server admin (emergency access only)
# In production, this would be in Key Vault with break-glass access
resource "random_password" "sql_admin_password" {
  length  = 32
  special = true
}

# Azure SQL Server (Logical Server)
resource "azurerm_mssql_server" "main" {
  name                         = "${var.project_name}-${var.environment}-sql"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = random_password.sql_admin_password.result
  minimum_tls_version          = "1.2"
  
  # Disable public network access - private endpoint only
  public_network_access_enabled = false

  tags = var.tags
}

# Azure SQL Database
resource "azurerm_mssql_database" "main" {
  name      = "${var.project_name}-${var.environment}-db"
  server_id = azurerm_mssql_server.main.id
  
  sku_name                    = "Basic"  # Cheapest tier for learning
  max_size_gb                 = 2
  zone_redundant              = false
  storage_account_type        = "Local"
  
  tags = var.tags
}

# Private Endpoint for SQL Server
resource "azurerm_private_endpoint" "sql" {
  name                = "${var.project_name}-${var.environment}-sql-pe"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = azurerm_subnet.data_subnet.id

  private_service_connection {
    name                           = "${var.project_name}-${var.environment}-sql-psc"
    private_connection_resource_id = azurerm_mssql_server.main.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  tags = var.tags
}

# Private DNS Zone for SQL Server
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

# Link DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "${var.project_name}-${var.environment}-sql-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = azurerm_virtual_network.main.id
  tags                  = var.tags
}

# DNS A Record for SQL Server Private Endpoint
resource "azurerm_private_dns_a_record" "sql" {
  name                = azurerm_mssql_server.main.name
  zone_name           = azurerm_private_dns_zone.sql.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql.private_service_connection[0].private_ip_address]
  tags                = var.tags
}