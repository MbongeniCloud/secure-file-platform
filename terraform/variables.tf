variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-securefiles"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "southafricanorth"
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  default     = "stsecurefiles001"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "client_id" {
  description = "Azure Client ID"
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "Azure Client Secret"
  type        = string
  default     = ""
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  default     = ""
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = ""
}