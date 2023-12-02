variable "location" {
  type    = string
  default = "brazilsouth"
}

variable "vm_windows_size" {
  type = string
}

variable "vm_password" {
  type      = string
  sensitive = true
}

### Entra ID ###
# variable "entraid_tenant_domain" {
#   type = string
# }

# variable "entraid_sqldeveloper_user_password" {
#   type      = string
#   sensitive = true
# }
