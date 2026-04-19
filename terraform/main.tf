# Use the existing resource group we already created
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-securefiles"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Subnet for private endpoints
resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "snet-privateendpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 30
    }
    versioning_enabled = true
  }

  tags = {
    environment = var.environment
  }
}

# Key Vault
resource "azurerm_key_vault" "kv" {
  name                = "kv-securefiles-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = "0c9fd986-afa3-4186-adcc-56b58539612b"
  sku_name            = "standard"

  access_policy {
    tenant_id = "0c9fd986-afa3-4186-adcc-56b58539612b"
    object_id = "19328232-aa6a-41aa-b1b6-2ba7406be9a6"

    key_permissions = [
      "Get", "Create", "Delete", "List", "Recover"
    ]
    secret_permissions = [
      "Get", "Set", "Delete", "List", "Recover"
    ]
  }

  soft_delete_retention_days = 7
  purge_protection_enabled   = false
}

# Private Endpoint for Storage Account
resource "azurerm_private_endpoint" "storage_pe" {
  name                = "pe-stsecurefiles"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.private_endpoint_subnet.id

  private_service_connection {
    name                           = "psc-stsecurefiles"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  tags = {
    environment = var.environment
  }
}

# Disable public access on Storage Account
resource "azurerm_storage_account_network_rules" "storage_network_rules" {
  storage_account_id = azurerm_storage_account.storage.id
  default_action     = "Deny"
  bypass             = ["AzureServices"]
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-securefiles"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = var.environment
  }
}

# Monitor Action Group
resource "azurerm_monitor_action_group" "alert_group" {
  name                = "ag-securefiles"
  resource_group_name = var.resource_group_name
  short_name          = "securefiles"

  email_receiver {
    name          = "admin"
    email_address = "Lefotlhem@yahoo.com"
  }
}

# Recovery Services Vault (for backups)
resource "azurerm_recovery_services_vault" "rsv" {
  name                = "rsv-securefiles"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  soft_delete_enabled = true

  tags = {
    environment = var.environment
  }
}# Cost Management Budget
resource "azurerm_consumption_budget_subscription" "budget" {
  name            = "budget-securefiles"
  subscription_id = "/subscriptions/2e654a0b-bafe-43f6-bbc6-559d8a56e675"

  amount     = 50
  time_grain = "Monthly"

  time_period {
    start_date = "2026-05-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    threshold_type = "Actual"

    contact_emails = ["Lefotlhem@yahoo.com"]
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Actual"

    contact_emails = ["Lefotlhem@yahoo.com"]
  }
}