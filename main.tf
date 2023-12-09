terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.84.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.46.0"
    }
  }
}

### ON-PREMISES ###
resource "azurerm_resource_group" "onpremises" {
  name     = "rg-onpremises"
  location = var.location
}

module "onpremises_vnet" {
  source              = "./modules/onpremises/vnet"
  resource_group_name = azurerm_resource_group.onpremises.name
  location            = azurerm_resource_group.onpremises.location
}

module "storage" {
  source              = "./modules/storage"
  resource_group_name = azurerm_resource_group.onpremises.name
  location            = azurerm_resource_group.onpremises.location
  subnet_id           = module.onpremises_vnet.subnet_id
  allow_ips           = var.allow_ips
}

module "entraid" {
  source                      = "./modules/entraid"
  entraid_tenant_domain       = var.entraid_tenant_domain
  administrator_user_name     = var.entraid_administrator_user_name
  administrator_user_password = var.entraid_administrator_user_password
  resource_group_id           = azurerm_resource_group.onpremises.id
}

module "onpremises_active_directory" {
  source              = "./modules/onpremises/activedirectory"
  resource_group_name = azurerm_resource_group.onpremises.name
  location            = azurerm_resource_group.onpremises.location
  subnet_id           = module.onpremises_vnet.subnet_id
  size                = var.vm_windows_size
  password            = var.vm_password
  ps1_url             = module.storage.ps1_url
}
