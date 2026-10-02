variable "name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "node_count" {
  type    = number
  default = 2
}

variable "node_vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "vnet_subnet_id" {
  type = string
}

# these two must NOT overlap with the vnet range, and the dns ip has to sit inside service_cidr
variable "service_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

variable "dns_service_ip" {
  type    = string
  default = "10.2.0.10"
}

variable "tags" {
  type    = map(string)
  default = {}
}
