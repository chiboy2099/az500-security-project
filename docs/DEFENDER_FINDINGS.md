# Defender for Cloud Findings - Phase 5A

**Date:** 2026-04-09  
**Secure Score:** (Will update after Sentinel deployment)  
**Resources Assessed:** 4 workload resources (App Service, Function App, SQL Server, Storage Accounts)

---

## Summary

Defender assessed our infrastructure and found **17 recommendations**, mostly categorized as **detection/observability gaps** rather than preventive control failures. Our defense-in-depth implementation (private endpoints, managed identities, NSGs, VNet integration) remains strong.

---

## Key Findings by Category

### Detection Gaps (To be addressed by Sentinel deployment)
- SQL Server auditing not enabled
- App Service diagnostic logs not enabled
- Subscription security contact not configured
- Email notifications for high-severity alerts not enabled

### Defense Hardening (Accepted risks for dev environment)
- Storage accounts: Public access allowed (needed for Terraform state, Cloud Shell)
- Function App: VNet integration not configured (not critical for dev workload)
- SQL Server: Azure AD-only authentication not enforced (SQL admin retained for emergency access)

### Advanced Features (Future improvements)
- SQL vulnerability assessment not configured
- Storage accounts: Shared key access prevention

---

## Decisions Made

**Prioritizing Sentinel deployment over individual resource logging:**
- Sentinel provides centralized log aggregation
- Avoids duplicate configuration effort
- Enables cross-resource correlation and advanced analytics

**Accepted Risks:**
- Dev environment tolerates some "nice-to-have" recommendations
- Will revisit after Sentinel is operational
- All critical preventive controls remain in place

---

## Next Steps

- Deploy Microsoft Sentinel (Phase 5B)
- Configure centralized logging for SQL, App Service, Storage
- Create analytics rules for threat detection
- Revisit Defender recommendations after Sentinel deployment