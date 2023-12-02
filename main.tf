terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.83.0"
    }
    # azuread = {
    #   source  = "hashicorp/azuread"
    #   version = "2.46.0"
    # }
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

module "vm_windows" {
  source              = "./modules/onpremises/activedirectory"
  resource_group_name = azurerm_resource_group.onpremises.name
  location            = azurerm_resource_group.onpremises.location
  subnet_id           = module.onpremises_vnet.subnet_id
  size                = var.vm_windows_size
  password            = var.vm_password
}

# module "entraid" {
#   source                     = "./modules/entraid"
#   entraid_tenant_domain      = var.entraid_tenant_domain
#   sqldeveloper_user_password = var.entraid_sqldeveloper_user_password
# }
