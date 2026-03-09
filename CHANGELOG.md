# Create CHANGELOG.md
cat > CHANGELOG.md << 'EOF'
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
## [0.2.0] - 2026-03-08

### Phase 1: Identity Foundation - COMPLETE

#### Added - Entra ID Security Groups
- Created `az500-security-admins` security group for privileged access management
- Created `az500-security-developers` security group for application deployment
- Created `az500-security-readers` security group for audit and monitoring
- Added current user to all three groups for testing

#### Added - Azure RBAC Role Assignments
- Assigned Contributor role to `az500-security-developers` at resource group scope (`az500-security-dev-rg`)
- Assigned Reader role to `az500-security-readers` at subscription scope
- Configured group-based access control (not individual user assignments)

#### Added - Privileged Identity Management (PIM)
- Configured `az500-security-admins` as ELIGIBLE for Owner role (not permanent)
- Set activation maximum duration: 4 hours
- Required Azure MFA on activation (credential theft protection)
- Required justification on activation (audit trail)
- Eligible assignment duration: 1 year (expires 2027-03-08)
- Tested activation workflow successfully

#### Security Controls Implemented
- **Eliminated standing privileged access:** Removed permanent Owner assignment from user account
- **Just-in-time admin access:** Owner role must be activated via PIM when needed
- **MFA-gated privilege escalation:** Requires MFA challenge to activate Owner (prevents credential theft)
- **Time-bound access:** Owner access auto-expires after 4 hours
- **Audit trail:** All PIM activations logged with justification
- **Least privilege:** Permanent roles limited to Reader (subscription) and Contributor (dev RG only)

#### AZ-500 Domain Coverage
- ✅ **Domain 1 (Secure Identity & Access):** Entra ID groups, Azure RBAC, PIM, MFA, least privilege

#### Validation
- ✅ Three security groups visible in Entra ID
- ✅ RBAC assignments verified via CLI and Portal
- ✅ PIM eligible assignment created and activated
- ✅ Time-bound activation expires automatically
- ✅ No permanent Owner assignments remain
- ✅ MFA requirement configured (session caching observed during testing)

#### Threat Mitigation
- **Credential theft:** Attacker cannot activate Owner without MFA device
- **Standing privilege abuse:** No permanent admin access exists
- **Insider threat:** Time-limited access with justification requirement
- **Blast radius:** Limited to Contributor permissions unless Owner explicitly activated

#### Infrastructure State
- Entra ID: 3 security groups
- Azure RBAC: 2 permanent assignments (Contributor on RG, Reader on subscription)
- PIM: 1 eligible assignment (Owner on subscription)
- Active Owner assignment: Time-bound, expires after 4 hours

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
