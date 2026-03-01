# Provider Configuration
# Defines which cloud providers and versions to use

terraform {
  required_version = ">= 1.7.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Azure Resource Manager Provider
provider "azurerm" {
  skip_provider_registration = true

  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
    
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Azure Active Directory Provider
# Manages Entra ID resources (users, groups, app registrations)
provider "azuread" {}

# Random Provider
# Used for generating unique resource name suffixes
provider "random" {}
