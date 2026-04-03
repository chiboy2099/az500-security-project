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

## [0.3.0] - 2026-03-16

### Phase 2: Network Foundation - COMPLETE

#### Added - Virtual Network Architecture
- Created Virtual Network `az500-security-dev-vnet` with address space `10.0.0.0/16`
- Created `app-subnet` (10.0.1.0/24) for application tier resources (App Service, Azure Functions)
- Created `data-subnet` (10.0.2.0/24) for data tier resources (SQL Database, Storage Account, Key Vault via private endpoints)
- Implemented network segmentation to separate trust zones and limit blast radius

#### Added - Network Security Groups (NSGs)
- Created `az500-security-dev-app-nsg` for application tier traffic control
- Created `az500-security-dev-data-nsg` for data tier traffic control
- Associated app-nsg with app-subnet (enforces all rules on subnet traffic)
- Associated data-nsg with data-subnet (enforces all rules on subnet traffic)

#### Added - NSG Security Rules (App Tier)
- **Priority 100:** Allow-HTTPS-Inbound (Internet → App subnet, port 443) - enables user access to web application
- **Priority 110:** Allow-HTTP-Inbound (Internet → App subnet, port 80) - enables HTTP to HTTPS redirect
- **Priority 200:** Allow-SQL-Outbound (App subnet → Data subnet, port 1433) - enables application database queries
- **Priority 210:** Allow-HTTPS-Outbound (App subnet → Data subnet, port 443) - enables Key Vault and Storage access

#### Added - NSG Security Rules (Data Tier)
- **Priority 100:** Allow-SQL-From-App (App subnet → Data subnet, port 1433) - permits application tier database access
- **Priority 110:** Allow-HTTPS-From-App (App subnet → Data subnet, port 443) - permits application tier Key Vault/Storage access
- **Priority 4000:** Deny-Internet-Inbound (Internet → Data subnet, all ports) - blocks all public internet access to data tier

#### Security Controls Implemented
- **Network segmentation:** Application and data tiers isolated into separate subnets
- **Zero-trust networking:** Default-deny posture with explicit allow rules for required traffic only
- **Defense-in-depth:** NSG rules provide network-layer security independent of future identity-based controls
- **Least-privilege traffic flows:** Only specific source/destination/port combinations allowed
- **Public exposure minimization:** Data tier completely blocked from internet access
- **Micro-segmentation:** Inter-subnet traffic requires explicit allow rules

#### Infrastructure as Code
- All network resources defined in Terraform (network.tf, nsg.tf)
- 14 resources deployed via `terraform apply` (1 VNet, 2 subnets, 2 NSGs, 7 NSG rules, 2 subnet-NSG associations)
- Configuration is version-controlled, repeatable, and portable
- Infrastructure changes tracked in Git with full audit trail

#### AZ-500 Domain Coverage
- ✅ **Domain 2 (Secure Networking):** 20-25% - Network segmentation, NSGs, traffic control, private vs public exposure

#### Validation
- ✅ All 14 resources created successfully via Terraform
- ✅ VNet address space confirmed as 10.0.0.0/16 in Azure Portal
- ✅ Both subnets visible with correct address prefixes (10.0.1.0/24, 10.0.2.0/24)
- ✅ NSG associations verified (app-nsg → app-subnet, data-nsg → data-subnet)
- ✅ Security rules present with correct priorities and actions
- ✅ Deny-Internet-Inbound rule confirmed blocking public access to data tier

#### Threat Mitigation
- **Direct database attacks from internet:** Blocked by Priority 4000 Deny-Internet-Inbound rule on data-subnet
- **Lateral movement after app tier compromise:** Limited by NSG rules requiring specific source subnets
- **Unauthorized data exfiltration:** Controlled by outbound rules limiting destination subnets and ports
- **Port scanning of data tier:** Blocked by default-deny posture and explicit internet denial
- **Blast radius containment:** Compromise of app tier cannot directly access data tier without going through NSG-controlled paths

#### Security Architecture Decisions
- **Two-tier segmentation chosen** over flat network to implement defense-in-depth and limit lateral movement
- **Private endpoints planned** for data tier (Phase 4) - current NSG rules prepare for private-only data access
- **Priority gaps maintained** (100, 110, 200, 210, 4000) to allow future rule insertion without renumbering
- **Explicit deny at priority 4000** rather than relying on Azure's default 65000 deny - makes security intent visible

#### Infrastructure State
- Virtual Network: 1 (az500-security-dev-vnet)
- Subnets: 2 (app-subnet, data-subnet)
- Network Security Groups: 2 (app-nsg, data-nsg)
- NSG Rules: 7 total (4 app tier, 3 data tier)
- Subnet-NSG Associations: 2

#### Cost Impact
- **Current monthly cost:** $0 (VNets, subnets, and NSGs are free in Azure)
- **Future cost considerations:** Application Gateway + WAF (Phase 3) will be the primary network cost driver

---
## [0.4.0] - 2026-03-26

### Phase 3: VNet Integration & Network Security

### Added
- VNet integration for App Service (connects to app-subnet via swift connection)
- Subnet delegation for Microsoft.Web/serverFarms on app-subnet
- App Service now sources traffic from 10.0.1.0/24 IP range
- Function App with managed identity for passwordless authentication

### Changed
- App Service can now reach private IP addresses within VNet
- App-subnet configured to allow Web App integration

### Security Impact
- App Service traffic now flows through NSG security controls (app-nsg outbound rules apply)
- Prepared infrastructure for private endpoint connectivity (Phase 4)
- Network path validated: App Service → app-nsg (Allow-SQL-Outbound) → data-nsg (Allow-SQL-From-App) → future private data services

### Lessons Learned
- Subnet delegation required for VNet integration with App Services
- Terraform state management: handled orphaned resource from failed creation
- VNet integration provides outbound private IP access WITHOUT blocking public inbound access
- Network securit

## [2026-03-31] - Phase 4: Data Layer Security DEPLOYED ✅

### Completed
- Successfully migrated infrastructure from East US to Central US
- SQL Server deployed with private endpoint (public access disabled)
- SQL Database: Basic tier, 2GB, TDE enabled
- Private DNS zone for SQL Server name resolution
- VNet integration for App Service maintained
- All 26 resources deployed successfully in Central US

### Migration Notes
- East US had SQL Server provisioning restrictions
- Full infrastructure recreated in Central US
- SQL Server deployment took 1h+ (Azure capacity issues)
- Clean Terraform state after migration

### Next Steps
- Configure managed identity RBAC (App Service → SQL Database)
- Test passwordless authentication
- Add Key Vault with private endpoint
----

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
