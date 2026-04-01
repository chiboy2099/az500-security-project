# App Service Plan (Linux)
# This defines the compute capacity for App Service
resource "azurerm_service_plan" "main" {
  name                = "${var.project_name}-${var.environment}-asp"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1" # Basic tier - ~$13/month

  tags = var.tags
}

# App Service (Web Frontend)
# This hosts the web application
resource "azurerm_linux_web_app" "main" {
  name                = "${var.project_name}-${var.environment}-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true

  site_config {
    always_on = false # Set to false for Basic tier (not supported)

    application_stack {
      node_version = "18-lts"
    }
  }

  identity {
    type = "SystemAssigned" # This creates the managed identity!
  }

   lifecycle {
    ignore_changes = [
      virtual_network_subnet_id
    ]
  }

  tags = var.tags
}

# Function App (Backend API)
# This runs serverless functions
resource "azurerm_linux_function_app" "main" {
  name                       = "${var.project_name}-${var.environment}-func"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.main.name
  service_plan_id            = azurerm_service_plan.main.id
  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key
  https_only                 = true

  site_config {
    application_stack {
      node_version = "18"
    }
  }

  identity {
    type = "SystemAssigned" # Managed identity for Functions too!
  }

  tags = var.tags
}

# Storage Account for Functions (required)
# Azure Functions needs storage for internal operations
resource "azurerm_storage_account" "functions" {
  name                     = "az500func${random_string.storage_suffix.result}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.main.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = var.tags
}

# Random suffix for storage account name (must be globally unique)
resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

# VNet Integration for App Service
# Connects App Service to app-subnet, enabling access to private resources
resource "azurerm_app_service_virtual_network_swift_connection" "app_vnet_integration" {
  app_service_id = azurerm_linux_web_app.main.id
  subnet_id      = azurerm_subnet.app_subnet.id
}