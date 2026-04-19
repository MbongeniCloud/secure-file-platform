# Secure File Platform on Azure

<div align="center">

![Azure](https://img.shields.io/badge/Microsoft_Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Security](https://img.shields.io/badge/Zero_Trust-Security-red?style=for-the-badge)

**A production-grade, secure cloud file storage platform built entirely with Infrastructure as Code**

*Deployed on Microsoft Azure | South Africa North Region*

</div>

---

## Project Overview

This project demonstrates the design and deployment of a **enterprise-grade secure file storage platform** on Microsoft Azure, implementing Zero Trust security principles from the ground up. Every resource is provisioned using Terraform, ensuring repeatable, version-controlled infrastructure.

The platform was built as a learning project to demonstrate real-world cloud engineering skills — from initial architecture design through to monitoring, backup, and cost management.

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

---

## Author

**Mbongeni** | Cloud Engineering | Azure | Terraform  
GitHub: [@MbongeniCloud](https://github.com/MbongeniCloud)

---

<div align="center">

*Built from scratch as a self-taught cloud engineering project*  
*Deployed in Azure South Africa North region*

</div>
