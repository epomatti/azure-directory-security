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
}

resource "azurerm_storage_container" "install" {
  name                  = "install"
  storage_account_name  = azurerm_storage_account.default.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "ps1" {
  name                   = "userdata.ps1"
  storage_account_name   = azurerm_storage_account.default.name
  storage_container_name = azurerm_storage_container.install.name
  type                   = "Block"
  source                 = "${path.module}/userdata.ps1"
}
