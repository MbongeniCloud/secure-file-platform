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