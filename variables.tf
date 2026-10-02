variable "project" {
  description = "Short project name, used in resource names. Lowercase letters/numbers only."
  type        = string
  default     = "demo"

  validation {
    condition     = can(regex("^[a-z0-9]{2,10}$", var.project))
    error_message = "project must be 2-10 characters, lowercase letters and numbers only (storage account and key vault names are picky)."
  }
}

variable "environment" {
  description = "Environment name (dev, test, prod ...)"
  type        = string
  default     = "dev"

  validation {
    condition     = can(regex("^[a-z0-9]{2,6}$", var.environment))
    error_message = "environment must be 2-6 characters, lowercase letters and numbers only."
  }
}

variable "location" {
  description = "Azure region for everything"
  type        = string
  default     = "eastus"
}

variable "extra_tags" {
  description = "Any additional tags you want on all resources"
  type        = map(string)
  default     = {}
}

# ---- network ----
variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Subnets to create. Keys 'vm' and 'aks' are used by the modules below."
  type = map(object({
    address_prefixes = list(string)
  }))
  default = {
    vm  = { address_prefixes = ["10.0.1.0/24"] }
    aks = { address_prefixes = ["10.0.2.0/24"] }
  }
}

# ---- vm ----
variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "vm_admin_username" {
  type    = string
  default = "azureadmin"
}

variable "ssh_source_cidr" {
  description = "CIDR allowed to SSH into the VM. Put your own public IP here, e.g. 203.0.113.10/32"
  type        = string
}

# ---- storage ----
variable "storage_containers" {
  description = "Blob containers to create in the storage account"
  type        = list(string)
  default     = ["app-data", "backups"]
}

variable "storage_replication_type" {
  type    = string
  default = "LRS"
}

# ---- app service ----
variable "app_service_sku" {
  type    = string
  default = "B1"
}

variable "app_node_version" {
  type    = string
  default = "20-lts"
}

# ---- aks ----
variable "aks_node_count" {
  type    = number
  default = 2
}

variable "aks_node_vm_size" {
  description = "AKS system pool needs at least 2 vCPU / 4 GB. Change if your region/quota doesn't have this size."
  type        = string
  default     = "Standard_B2s"
}

variable "kubernetes_version" {
  description = "Leave null to let Azure pick the current default"
  type        = string
  default     = null
}
