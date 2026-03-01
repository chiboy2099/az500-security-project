# Create CHANGELOG.md
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Phase 1: Identity Foundation (In Progress)
- Planning Entra ID group structure
- Designing PIM role assignments
- Planning Conditional Access policies

---

## [0.1.0] - 2026-02-XX

### Phase 0: Foundation - COMPLETE

#### Added
- Created Azure subscription and activated Entra ID P2 trial
- Configured Terraform remote state backend in Azure Storage Account
  - Storage: `az500tfstate70610566`
  - Encryption at rest enabled (AES-256)
  - Blob versioning enabled (corruption protection)
  - HTTPS-only access (TLS 1.2+)
  - No public blob access
- Created project structure:
  - `terraform/modules/` - Reusable Terraform modules
  - `terraform/environments/dev/` - Dev environment config
  - `docs/` - Architecture and threat model documentation
  - `scripts/` - Helper scripts
- Initialized Terraform with providers:
  - azurerm ~> 3.110 (Azure resources)
  - azuread ~> 2.53 (Entra ID)
  - random ~> 3.6 (unique names)
- Deployed first resource: `az500-security-dev-rg` (resource group)

#### Security Controls Implemented
- **Identity**: Azure CLI authentication with MFA
- **Data Protection**: State file encrypted at rest and in transit
- **Resilience**: Blob versioning for state rollback
- **Concurrency**: Blob leasing prevents state corruption

#### Validation
- ✅ Terraform state stored remotely in Azure Storage
- ✅ Resource group visible in Azure Portal
- ✅ State file accessible with blob versioning
- ✅ All tags applied correctly (project, environment, managed_by)

#### Infrastructure Deployed
- Resource Group: `az500-security-tfstate-rg` (Terraform state)
- Storage Account: `az500tfstate70610566` (state backend)
- Resource Group: `az500-security-dev-rg` (application resources)

---

## Template for Future Entries

### [Version] - YYYY-MM-DD

#### Added
- New features or resources

#### Changed
- Updates to existing resources

#### Security
- Security controls added/modified
- Threat mitigations implemented

#### Fixed
- Bug fixes
- Security vulnerabilities addressed

#### Removed
- Deprecated features
