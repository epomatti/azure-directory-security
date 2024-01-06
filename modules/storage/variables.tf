variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "allow_ips" {
  type = list(string)
}

variable "administrator_user_object_id" {
  type = string
}
