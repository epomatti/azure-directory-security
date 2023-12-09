variable "entraid_tenant_domain" {
  type = string
}

variable "administrator_user_name" {
  type = string
}

variable "administrator_user_password" {
  type      = string
  sensitive = true
}

variable "resource_group_id" {
  type = string
}
