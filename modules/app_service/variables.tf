variable "plan_name" {
  type = string
}

variable "app_name" {
  description = "must be globally unique, becomes <name>.azurewebsites.net"
  type        = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "B1"
}

variable "node_version" {
  type    = string
  default = "20-lts"
}

variable "app_settings" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
