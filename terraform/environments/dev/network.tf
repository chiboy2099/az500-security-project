# Virtual Network
# This is the "house structure" - the container for all subnets
resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-${var.environment}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vnet_address_space

  tags = var.tags
}

# Application Subnet
# This is the "application tier room" - where App Service and Functions live
resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.app_subnet_address_prefix
}

# Data Subnet  
# This is the "data tier room" - where SQL, Storage, Key Vault will connect via private endpoints
resource "azurerm_subnet" "data_subnet" {
  name                 = "data-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.data_subnet_address_prefix
}