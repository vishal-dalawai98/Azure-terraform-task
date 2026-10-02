variable "name" {
  description = "3-24 chars, letters, numbers and hyphens"
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
  default = "standard"
}

variable "soft_delete_retention_days" {
  type    = number
  default = 7
}

# keep this false for dev, otherwise destroy leaves the name locked for 90 days
variable "purge_protection_enabled" {
  type    = bool
  default = false
}

variable "reader_principals" {
  description = "label => object id of identities that should be able to read secrets (e.g. a web app's managed identity)"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "secret name => value"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
