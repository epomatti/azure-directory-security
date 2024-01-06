resource "random_string" "storage" {
  length  = 14
  special = false
  upper   = false
}

resource "azurerm_storage_account" "default" {
  name                            = "st${random_string.storage.result}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = true
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = var.allow_ips
    virtual_network_subnet_ids = [var.subnet_id]
    bypass                     = ["AzureServices"]
  }
}

resource "azurerm_storage_container" "install" {
  name                  = "install"
  storage_account_name  = azurerm_storage_account.default.name
  container_access_type = "blob"

  depends_on = [azurerm_role_assignment.current]
}

resource "azurerm_storage_blob" "ps1" {
  name                   = "userdata.ps1"
  storage_account_name   = azurerm_storage_account.default.name
  storage_container_name = azurerm_storage_container.install.name
  type                   = "Block"
  source                 = "${path.module}/userdata.ps1"
}

### Permissions (just in case) ###
data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "current" {
  scope                = azurerm_storage_account.default.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "administrator" {
  scope                = azurerm_storage_account.default.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.administrator_user_object_id
}
