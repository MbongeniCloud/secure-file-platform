# Secure File Platform on Azure


**A production-grade, secure cloud file storage platform built entirely with Infrastructure as Code**

*Deployed on Microsoft Azure | South Africa North Region*

</div>

---

## Project Overview

This project demonstrates the design and implementation of a production-grade secure file storage platform on Microsoft Azure, aligned with Zero Trust principles and enterprise cloud governance standards.

The solution simulates a regulated environment where sensitive data must be protected from unauthorized access, misconfiguration, and exposure. All resources are deployed using a secure-by-design approach, enforcing private network access, strong identity controls, and strict security configurations.

Infrastructure is provisioned entirely using Terraform, enabling consistent, repeatable, and version-controlled deployments. The platform includes centralized secrets management, monitoring, backup and disaster recovery, and cost governance.

This implementation focuses on risk reduction, operational visibility, and audit readiness — key requirements for enterprise and financial services environments.



---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Azure Subscription                        │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Resource Group: rg-securefiles          │   │
│  │                                                      │   │
│  │  ┌─────────────────────────────────────────────┐    │   │
│  │  │         Virtual Network: vnet-securefiles   │    │   │
│  │  │                                             │    │   │
│  │  │  ┌──────────────────────────────────────┐  │    │   │
│  │  │  │  Subnet: snet-privateendpoints       │  │    │   │
│  │  │  │                                      │  │    │   │
│  │  │  │  ┌─────────────┐  ┌──────────────┐  │  │    │   │
│  │  │  │  │  Private    │  │  Private     │  │  │    │   │
│  │  │  │  │  Endpoint   │──│  Storage     │  │  │    │   │
│  │  │  │  │             │  │  Account     │  │  │    │   │
│  │  │  │  └─────────────┘  └──────────────┘  │  │    │   │
│  │  │  └──────────────────────────────────────┘  │    │   │
│  │  └─────────────────────────────────────────────┘    │   │
│  │                                                      │   │
│  │  ┌────────────────┐  ┌─────────────────────────┐    │   │
│  │  │  Key Vault     │  │  Recovery Services Vault│    │   │
│  │  │  kv-securefiles│  │  rsv-securefiles        │    │   │
│  │  └────────────────┘  └─────────────────────────┘    │   │
│  │                                                      │   │
│  │  ┌────────────────┐  ┌─────────────────────────┐    │   │
│  │  │  Log Analytics │  │  Monitor Action Group   │    │   │
│  │  │  law-securefiles│  │  ag-securefiles         │    │   │
│  │  └────────────────┘  └─────────────────────────┘    │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  Budget Alert: budget-securefiles ($50/month)                │
└─────────────────────────────────────────────────────────────┘
```

---

## Infrastructure Components

| Resource | Name | Purpose |
|----------|------|---------|
| Resource Group | `rg-securefiles` | Logical container for all resources |
| Virtual Network | `vnet-securefiles` | Private network — 10.0.0.0/16 |
| Subnet | `snet-privateendpoints` | Dedicated subnet — 10.0.1.0/24 |
| Storage Account | `stsecurefiles001` | Azure Files with SMB 3.0 |
| Private Endpoint | `pe-stsecurefiles` | Eliminates public internet exposure |
| Key Vault | `kv-securefiles-001` | Secrets and encryption key management |
| Log Analytics Workspace | `law-securefiles` | Centralised logging and monitoring |
| Monitor Action Group | `ag-securefiles` | Email alerting system |
| Recovery Services Vault | `rsv-securefiles` | Backup and disaster recovery |
| Consumption Budget | `budget-securefiles` | Cost management — $50/month limit |

---

## Security Implementation

### Zero Trust Principles Applied

**1. Never Trust, Always Verify**
- All access to storage requires identity verification
- No anonymous or public access permitted
- Azure AD-based authentication enforced

**2. Least Privilege Access**
- RBAC roles assigned at minimum required permissions
- Service principals scoped to specific subscriptions
- Key Vault access policies restrict who can read secrets

**3. Assume Breach**
- Private Endpoint removes public internet attack surface
- Network rules deny all traffic by default (`default_action = "Deny"`)
- Only Azure services explicitly bypassed
- TLS 1.2 minimum enforced on all connections

### Network Security
```
Internet ──✗──> Storage Account    (Public access BLOCKED)
VNet ──────────> Private Endpoint ──> Storage Account (ALLOWED)
```

### Encryption
- **In transit**: TLS 1.2 minimum on all connections
- **At rest**: Azure Storage Service Encryption (AES-256)
- **Key management**: Azure Key Vault with soft delete protection

---

## Disaster Recovery & Backup

| Feature | Configuration |
|---------|--------------|
| Storage Replication | GRS (Geo-Redundant Storage) — data replicated to secondary Azure region |
| Blob Soft Delete | 30-day retention — deleted files recoverable |
| Blob Versioning | Enabled — previous versions preserved |
| Recovery Services Vault | Standard SKU with soft delete enabled |
| Key Vault Soft Delete | 7-day retention on deleted secrets |

---

## Monitoring & Alerting

- **Log Analytics Workspace**: Centralises all resource logs and metrics
- **Action Group**: Email notifications to administrator
- **Retention**: 30 days of log data
- **Budget Alerts**: Email at 80% and 100% of monthly spend

---

## Technologies Used

| Technology | Purpose |
|-----------|---------|
| Microsoft Azure | Cloud platform |
| Terraform v1.14.8 | Infrastructure as Code |
| Azure CLI v2.85.0 | Azure resource management |
| GitHub | Source control |
| GitHub Actions | CI/CD pipeline |
| VS Code | Development environment |
| PowerShell | Scripting and automation |

---

## Project Structure

```
secure-file-platform/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions CI/CD pipeline
├── terraform/
│   ├── main.tf                 # Core infrastructure resources
│   ├── providers.tf            # Azure provider configuration
│   └── variables.tf            # Input variables
├── scripts/                    # Utility scripts
├── docs/                       # Additional documentation
└── README.md                   # This file
```

---

## How to Deploy

### Prerequisites
- Azure CLI installed and authenticated (`az login`)
- Terraform >= 1.0 installed
- Azure subscription with Contributor access

### Deployment Steps

```bash
# 1. Clone the repository
git clone https://github.com/MbongeniCloud/secure-file-platform.git
cd secure-file-platform/terraform

# 2. Initialise Terraform
terraform init

# 3. Preview changes
terraform plan

# 4. Deploy infrastructure
terraform apply
```

---

## Challenges & Solutions

| Challenge | Solution |
|-----------|---------|
| Git submodule conflict in terraform folder | Removed `.git` directory from subfolder, re-tracked files |
| GitHub Actions YAML syntax errors | Iterative debugging, restructured env variable injection |
| Azure CLI authentication in CI/CD | Implemented service principal with scoped RBAC permissions |
| Terraform state management | Established proper `.gitignore` to exclude sensitive state files |
| Network lockdown breaking access | Configured `bypass = ["AzureServices"]` to allow Azure-internal traffic |

---

## Key Learnings

- **Infrastructure as Code** — Terraform enables repeatable, version-controlled deployments
- **Zero Trust Architecture** — Security must be designed in, not bolted on
- **Private Networking** — Private Endpoints completely eliminate public attack surface
- **Secrets Management** — Key Vault is the correct way to handle credentials in Azure
- **Cost Awareness** — Budget alerts prevent surprise bills in cloud environments
- **Disaster Recovery** — GRS replication and soft delete are essential for production data

- ## Live Deployment Evidence

All resources below are deployed live in Microsoft Azure — 
South Africa North region. Screenshots taken directly 
from the Azure Portal.

---

### 1. Resource Group Overview

> Complete resource group `rg-securefiles` showing all 
> deployed infrastructure components including Virtual Network, 
> Storage Account, Key Vault, Private Endpoint, Log Analytics 
> Workspace, Recovery Services Vault, and Budget Alert — 
> all provisioned via Terraform in a single automated deployment.
> <img width="1366" height="731" alt="Resource Group Overview" src="https://github.com/user-attachments/assets/c0b8d406-23d4-4238-88a0-1bb0ae706570" />

 ---

### 2. Virtual Network & Subnets

> Private Virtual Network `vnet-securefiles` configured with 
> address space 10.0.0.0/16 and dedicated subnet 
> `snet-privateendpoints` (10.0.1.0/24) for secure 
> Private Endpoint connectivity. No public-facing 
> network interfaces deployed.
<img width="1366" height="731" alt="Virtual Network" src="https://github.com/user-attachments/assets/2bd10251-b653-4771-9a95-77626ae04dcc" />

---

### 3. Private Endpoint

> Private Endpoint `pe-stsecurefiles` creates a private 
> network interface inside the Virtual Network, routing all 
> storage traffic through the internal network. Public internet 
> access to the storage account is completely eliminated — 
> a core Zero Trust security requirement.
> <img width="1366" height="732" alt="Private Endpoint" src="https://github.com/user-attachments/assets/d89dcc09-f69b-476d-b42a-e0fec4876eb3" />


---

### 4. Storage Account — Network Security

> Storage account `stsecurefiles001` with public network 
> access disabled and firewall rules set to Deny by default. 
> Only Azure Services are explicitly bypassed. Combined with 
> the Private Endpoint, this eliminates the storage account 
> from the public internet attack surface entirely.
> <img width="1366" height="727" alt="Storage Account Network Settings" src="https://github.com/user-attachments/assets/1b6f4291-3acb-46b6-8c4d-b451394fcaa1" />


---

### 5. Azure Key Vault

> Key Vault `kv-securefiles-001` deployed as the centralised 
> secrets and encryption key store. Access policies restrict 
> key and secret operations to authorised identities only. 
> Soft delete protection enabled with 7-day retention — 
> prevents accidental or malicious permanent deletion of 
> cryptographic material.
> <img width="1366" height="733" alt="Key Vault" src="https://github.com/user-attachments/assets/ef3c734d-e221-4fbd-b675-ab982adbc0f5" />


---

### 6. Recovery Services Vault

> Recovery Services Vault `rsv-securefiles` provides the 
> backup and disaster recovery foundation. Combined with 
> Geo-Redundant Storage (GRS) replication on the storage 
> account, data is automatically replicated to a secondary 
> Azure region — ensuring business continuity in the event 
> of a regional outage.
> <img width="1366" height="725" alt="Recovery Services Vault" src="https://github.com/user-attachments/assets/d96d4d6f-45c9-400f-9b33-d9199ce06e95" />


---

### 7. Log Analytics Workspace

> Centralised Log Analytics Workspace `law-securefiles` 
> collects diagnostic logs and metrics from all deployed 
> resources. 30-day log retention configured. Connected to 
> Azure Monitor Action Group for automated email alerting — 
> forming the observability layer of the platform.
> <img width="1366" height="731" alt="Log Analytics Workspace" src="https://github.com/user-attachments/assets/eaac9ae0-94de-4442-bc2a-40c97d2ad4bc" />


---

### 8. Microsoft Defender for Cloud

> Microsoft Defender for Cloud security posture assessment 
> showing active recommendations and security score for the 
> subscription. Defender provides continuous security 
> monitoring, misconfiguration detection, and threat 
> intelligence across all deployed Azure resources.
> <img width="1366" height="729" alt="Microsoft Defender for Cloud" src="https://github.com/user-attachments/assets/0aac088d-655f-4a8c-b16a-3d9fd9f8a78f" />


---

### 9. Budget Alert — Cost Management

> Azure Cost Management budget `budget-securefiles` configured 
> at $50/month with automated email notifications triggered 
> at 80% ($40) and 100% ($50) of monthly spend. Demonstrates 
> FinOps awareness and cost governance — a requirement in 
> every enterprise cloud environment.
> <img width="1366" height="731" alt="Budget Alert" src="https://github.com/user-attachments/assets/629a4ba8-7139-4ff0-be31-8718382b3e6e" />


---


## Author

**Mbongeni** | Cloud Engineering | Azure | Terraform  
GitHub: [@MbongeniCloud](https://github.com/MbongeniCloud)

---

<div align="center">

*Built from scratch as a self-taught cloud engineering project*  
*Deployed in Azure South Africa North region*

</div>
