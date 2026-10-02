variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "size" {
  type    = string
  default = "Standard_B2s"
}

variable "admin_username" {
  type    = string
  default = "azureadmin"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "ssh_source_cidr" {
  description = "who can reach port 22"
  type        = string
}

variable "os_disk_type" {
  type    = string
  default = "Standard_LRS"
}

variable "tags" {
  type    = map(string)
  default = {}
}
