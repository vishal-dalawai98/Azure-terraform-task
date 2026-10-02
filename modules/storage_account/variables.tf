variable "name" {
  description = "3-24 chars, lowercase letters and numbers only"
  type        = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "replication_type" {
  type    = string
  default = "LRS"
}

variable "containers" {
  description = "private blob containers to create"
  type        = list(string)
  default     = []
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
