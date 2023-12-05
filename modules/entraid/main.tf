locals {
  user = "administrator"
}

resource "azuread_user" "administrator" {
  account_enabled     = true
  user_principal_name = "${local.user}@${var.entraid_tenant_domain}"
  display_name        = local.user
  mail_nickname       = local.user
  password            = var.administrator_user_password
}

resource "azuread_directory_role" "hybrid_identity_administrator" {
  display_name = "Hybrid Identity Administrator"
}

# To read CloudSync insights and ++: Security Administrator
resource "azuread_directory_role" "security_administrator" {
  display_name = "Security Administrator"
}

resource "azuread_directory_role_assignment" "administrator" {
  role_id             = azuread_directory_role.hybrid_identity_administrator.template_id
  principal_object_id = azuread_user.administrator.object_id
}

resource "azuread_directory_role_assignment" "administrator_security_administrator" {
  role_id             = azuread_directory_role.security_administrator.template_id
  principal_object_id = azuread_user.administrator.object_id
}

resource "azurerm_role_assignment" "administrator" {
  scope                = var.resource_group_id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = azuread_user.administrator.object_id
}

resource "azurerm_role_assignment" "reader" {
  scope                = var.resource_group_id
  role_definition_name = "Reader"
  principal_id         = azuread_user.administrator.object_id
}
