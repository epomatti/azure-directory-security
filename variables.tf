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

variable "allow_ips" {
  type = list(string)
}

### Entra ID ###
variable "entraid_tenant_domain" {
  type = string
}

variable "entraid_administrator_user_name" {
  type = string
}

variable "entraid_administrator_user_password" {
  type      = string
  sensitive = true
}
