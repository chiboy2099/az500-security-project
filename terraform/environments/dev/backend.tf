terraform {
  backend "azurerm" {
    resource_group_name  = "az500-security-tfstate-rg"
    storage_account_name = "az500tfstate70610566"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
