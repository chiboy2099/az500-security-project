# Network Security Group for Application Subnet
# This NSG will contain rules for controlling traffic to/from App Service and Functions
resource "azurerm_network_security_group" "app_nsg" {
  name                = "${var.project_name}-${var.environment}-app-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

# Network Security Group for Data Subnet
# This NSG will contain rules for controlling traffic to/from SQL, Storage, Key Vault
resource "azurerm_network_security_group" "data_nsg" {
  name                = "${var.project_name}-${var.environment}-data-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

#============================================================================
# APP SUBNET NSG RULES
#============================================================================

# Allow HTTPS inbound from Internet to App Subnet
# This allows users to access the web application
resource "azurerm_network_security_rule" "app_allow_https_inbound" {
  name                        = "Allow-HTTPS-Inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "10.0.1.0/24"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.app_nsg.name
}

# Allow HTTP inbound from Internet to App Subnet
# This allows HTTP to HTTPS redirect
resource "azurerm_network_security_rule" "app_allow_http_inbound" {
  name                        = "Allow-HTTP-Inbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "10.0.1.0/24"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.app_nsg.name
}

# Allow outbound SQL from App Subnet to Data Subnet
# This allows App Service and Functions to query SQL Database
resource "azurerm_network_security_rule" "app_allow_sql_outbound" {
  name                        = "Allow-SQL-Outbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "10.0.1.0/24"
  destination_address_prefix  = "10.0.2.0/24"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.app_nsg.name
}

# Allow outbound HTTPS from App Subnet to Data Subnet
# This allows App Service and Functions to access Key Vault and Storage Account
resource "azurerm_network_security_rule" "app_allow_https_outbound" {
  name                        = "Allow-HTTPS-Outbound"
  priority                    = 210
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "10.0.1.0/24"
  destination_address_prefix  = "10.0.2.0/24"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.app_nsg.name
}

#============================================================================
# DATA SUBNET NSG RULES
#============================================================================

# Allow SQL inbound from App Subnet to Data Subnet
# This allows App tier to query SQL Database
resource "azurerm_network_security_rule" "data_allow_sql_from_app" {
  name                        = "Allow-SQL-From-App"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "10.0.1.0/24"
  destination_address_prefix  = "10.0.2.0/24"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.data_nsg.name
}

# Allow HTTPS inbound from App Subnet to Data Subnet
# This allows App tier to access Key Vault and Storage Account
resource "azurerm_network_security_rule" "data_allow_https_from_app" {
  name                        = "Allow-HTTPS-From-App"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "10.0.1.0/24"
  destination_address_prefix  = "10.0.2.0/24"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.data_nsg.name
}

# Deny all inbound from Internet to Data Subnet
# This ensures data tier is NOT accessible from public internet
resource "azurerm_network_security_rule" "data_deny_internet_inbound" {
  name                        = "Deny-Internet-Inbound"
  priority                    = 4000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "10.0.2.0/24"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.data_nsg.name
}

#============================================================================
# SUBNET-NSG ASSOCIATIONS
#============================================================================

# Associate App NSG with App Subnet
# This attaches all the app_nsg rules to the app-subnet
resource "azurerm_subnet_network_security_group_association" "app_subnet_nsg" {
  subnet_id                 = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

# Associate Data NSG with Data Subnet  
# This attaches all the data_nsg rules to the data-subnet
resource "azurerm_subnet_network_security_group_association" "data_subnet_nsg" {
  subnet_id                 = azurerm_subnet.data_subnet.id
  network_security_group_id = azurerm_network_security_group.data_nsg.id
}