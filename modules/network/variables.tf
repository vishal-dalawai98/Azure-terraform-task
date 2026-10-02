variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnets" {
  description = "map of subnet name => address prefixes"
  type = map(object({
    address_prefixes = list(string)
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
