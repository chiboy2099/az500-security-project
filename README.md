# Create README.md
cat > README.md << 'EOF'
# Azure Security Engineering Project - AZ-500 Certification

## 🎯 Project Overview

This project demonstrates enterprise-grade Azure security engineering skills aligned with the **Microsoft AZ-500: Azure Security Engineer** certification exam. It implements a production-style serverless web application with comprehensive security controls across identity, networking, compute, storage, and threat protection.

## 📋 AZ-500 Exam Domain Coverage

| Domain | Weight | Implementation |
|--------|--------|----------------|
| **Secure Identity and Access** | 15-20% | ✅ Entra ID, PIM, Conditional Access, RBAC, Managed Identities |
| **Secure Networking** | 20-25% | ⏳ VNet, NSGs, Private Endpoints, Application Gateway, WAF |
| **Secure Compute, Storage, Data** | 20-25% | ⏳ App Service, Functions, SQL Database, Key Vault, Encryption |
| **Manage Security Operations** | 30-35% | ⏳ Defender for Cloud, Sentinel, Analytics Rules, Playbooks |

**Legend:** ✅ Complete | 🚧 In Progress | ⏳ Planned

---

## 🏗️ Architecture

### High-Level Design
```
[Internet] → [App Gateway + WAF] → [VNet]
                                      ├─ [App Service]
                                      ├─ [Azure Functions]
                                      ├─ [SQL Database (Private)]
                                      ├─ [Storage Account (Private)]
                                      └─ [Key Vault (Private)]

Identity: Microsoft Entra ID
Monitoring: Defender + Sentinel
```

### Trust Boundaries

- **Public Zone:** Application Gateway (HTTPS + WAF only)
- **Private Zone:** All backend services (VNet-integrated, private endpoints)
- **Management Plane:** Azure Portal/Terraform (MFA + Conditional Access required)

---

## 🔐 Security Controls Implemented

### Identity & Access (Domain 1)
- [ ] Microsoft Entra ID for all authentication
- [ ] Privileged Identity Management (PIM) for admin access
- [ ] Conditional Access policies (MFA, risk-based)
- [ ] Managed Identities (no secrets in code)
- [ ] RBAC at multiple scopes

### Networking (Domain 2)
- [ ] VNet segmentation (app subnet, data subnet)
- [ ] Network Security Groups (NSGs) with least-privilege rules
- [ ] Private Endpoints for PaaS services
- [ ] Application Gateway with WAF (OWASP protection)
- [ ] TLS 1.2+ enforcement everywhere

### Compute & Data (Domain 3)
- [ ] App Service with VNet integration
- [ ] Azure Functions with VNet integration
- [ ] SQL Database with Entra ID authentication
- [ ] Azure Key Vault with RBAC (no secrets in code)
- [ ] Encryption at rest (TDE, Storage encryption)
- [ ] Encryption in transit (HTTPS-only, TLS 1.2+)

### Security Operations (Domain 4)
- [ ] Microsoft Defender for Cloud (all plans enabled)
- [ ] Secure Score monitoring and remediation
- [ ] Microsoft Sentinel (SIEM + SOAR)
- [ ] Custom analytics rules for threat detection
- [ ] Automated incident response playbooks

---

## 🎯 Threat Model

### STRIDE Analysis

| Threat Category | Top Threats | Controls | Detection |
|----------------|-------------|----------|-----------|
| **Spoofing** | Credential theft, token replay | MFA, Conditional Access, managed identities | Entra ID sign-in logs, Sentinel |
| **Tampering** | SQL injection, code injection | WAF, input validation, parameterized queries | Defender for App Service |
| **Repudiation** | Unauthorized actions | Audit logging, Entra ID logs | Sentinel analytics rules |
| **Information Disclosure** | Data exfiltration, leaked secrets | Private endpoints, Key Vault, encryption | Defender for Storage, DLP |
| **Denial of Service** | DDoS, resource exhaustion | Application Gateway DDoS, rate limiting | Defender for Cloud alerts |
| **Elevation of Privilege** | RBAC bypass, admin abuse | PIM, least privilege RBAC, Conditional Access | PIM audit logs, Sentinel |

*Full STRIDE threat model in `/docs/threat-model/`*

---

## 🚀 Deployment

### Prerequisites

- Azure subscription with Owner or Contributor access
- Azure CLI (`az`) installed and authenticated
- Terraform >= 1.7.0
- Microsoft Entra ID P2 trial (for PIM features)

### Setup
```bash
# 1. Clone repository
git clone https://github.com/YOUR_USERNAME/az500-security-project.git
cd az500-security-project

# 2. Load environment variables
source az500-env.fish

# 3. Navigate to Terraform environment
cd terraform/environments/dev

# 4. Initialize Terraform
terraform init

# 5. Review plan
terraform plan

# 6. Deploy (after reviewing plan)
terraform apply
```

### Teardown
```bash
# Destroy all resources
terraform destroy

# Remove Terraform state infrastructure (if desired)
az group delete --name az500-security-tfstate-rg --yes
```

---

## 📊 Project Status

## 📊 Project Status

**Phase 0: Foundation** - ✅ COMPLETE
- [x] Azure subscription setup
- [x] Entra ID P2 trial activated
- [x] Terraform backend configured (Azure Storage)
- [x] Project structure created
- [x] First resource deployed (resource group)

**Phase 1: Identity Foundation** - ✅ COMPLETE
- [x] Entra ID security groups created (admins, developers, readers)
- [x] Azure RBAC configured at multiple scopes
- [x] Privileged Identity Management (PIM) configured
- [x] Just-in-time Owner access implemented
- [x] Permanent Owner assignment removed
- [x] MFA + justification required for privilege escalation

**Phase 2: Network Foundation** - ✅ COMPLETE
- [x] Virtual Network and subnet architecture
- [x] Network Security Groups (NSGs)
- [x] NSG security rules (default-deny, least-privilege)
- [x] Subnet-NSG associations
- [x] Network segmentation (app tier, data tier)

**Phase 3-7:** See [CHANGELOG.md](./CHANGELOG.md) for detailed progress

---

## 💰 Cost Management

**Estimated Monthly Cost:** $40-70 USD

**Cost Reduction Strategies:**
- Delete Application Gateway when not in use ($20-30/month savings)
- Scale App Service to Free (F1) tier when not testing
- Pause SQL Database (preview feature)
- Reduce Log Analytics retention to 7 days

**Budget Alerts:** Set at $25, $50, $75 in Azure portal

---

## 🎓 Learning Outcomes

By completing this project, I can demonstrate:

1. **Identity-First Security Design**
   - Entra ID as central identity provider
   - Zero secrets in code (managed identities)
   - Privileged access management (PIM)

2. **Defense-in-Depth Architecture**
   - Network segmentation and isolation
   - Private connectivity for data tier
   - WAF protection for public endpoints

3. **Threat Detection and Response**
   - SIEM implementation (Sentinel)
   - Custom analytics rules
   - Automated incident response

4. **Infrastructure as Code (Terraform)**
   - Remote state management
   - Modular, reusable code
   - Security-hardened deployments

5. **Compliance and Governance**
   - MCSB alignment
   - Audit logging everywhere
   - Risk-based decision making

---

## 📚 Resources

- [Microsoft AZ-500 Exam Page](https://learn.microsoft.com/en-us/certifications/exams/az-500)
- [Microsoft Cloud Security Benchmark](https://learn.microsoft.com/en-us/security/benchmark/azure/)
- [Azure Security Documentation](https://learn.microsoft.com/en-us/azure/security/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

---

## 📝 Changelog

See [CHANGELOG.md](./CHANGELOG.md) for detailed project history.

---

## 🔒 Security Notice

This is a learning project. Some configurations prioritize education over production-grade security:
- Using dev environment (not prod)
- Some features use trial licenses (Entra ID P2)
- Simplified for single-user deployment

**Production differences documented in `/docs/production-considerations.md`**

---

## 👤 Author

**Your Name**  
Preparing for AZ-500 Certification  
[LinkedIn](https://linkedin.com/in/yourprofile) | [GitHub](https://github.com/yourusername)

---

## 📄 License

This project is for educational purposes.
EOF
