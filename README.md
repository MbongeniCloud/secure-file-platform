# Secure File Platform on Azure

## Project Overview
A production-grade secure file storage solution built on 
Microsoft Azure using Infrastructure as Code principles.

## Architecture
- **Storage**: Azure Files with SMB 3.0 protocol
- **Network**: Virtual Network with Private Endpoints
- **Security**: Azure Key Vault, Zero Trust principles
- **Monitoring**: Azure Monitor, Log Analytics
- **Backup**: Recovery Services Vault, GRS replication
- **Cost**: Automated budget alerts

## Technologies Used
- Microsoft Azure
- Terraform (IaC)
- GitHub & GitHub Actions
- PowerShell
- VS Code

## Infrastructure Components
| Resource | Purpose |
|----------|---------|
| Azure Virtual Network | Private network isolation |
| Private Endpoint | Secure storage access |
| Azure Key Vault | Secrets & encryption keys |
| Log Analytics Workspace | Centralised logging |
| Recovery Services Vault | Backup & DR |
| Budget Alert | Cost management |

## Security Features
- No public internet access to storage
- Identity-based authentication
- Encrypted data at rest and in transit
- Soft delete protection (30 days)
- TLS 1.2 minimum

## Challenges Overcome
- Resolved Terraform submodule git conflicts
- Debugged GitHub Actions YAML syntax
- Configured Azure service principal authentication
- Managed infrastructure state across sessions

## What I Learned
- Infrastructure as Code with Terraform
- Azure networking and security concepts
- Zero Trust security principles
- Git version control workflows
- Cloud cost optimization strategies# secure-file-platform
Azure secure file platform with Terraform
