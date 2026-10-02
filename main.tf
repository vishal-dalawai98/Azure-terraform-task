locals {
  prefix = "${var.project}-${var.environment}"

  tags = merge(
    {
      project     = var.project
      environment = var.environment
      managed_by  = "terraform"
    },
    var.extra_tags
  )
}

# storage account, key vault and the web app all need globally unique names,
# so a short random suffix saves us from name clashes
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

# the VM password is generated here and dropped into Key Vault,
# so it never has to be typed or committed anywhere
resource "random_password" "vm_admin" {
  length           = 20
  special          = true
  override_special = "!#%*-_"
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.prefix}"
  location = var.location
  tags     = local.tags
}

module "network" {
  source = "./modules/network"

  name                = "vnet-${local.prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vnet_address_space
  subnets             = var.subnets
  tags                = local.tags
}

module "storage" {
  source = "./modules/storage_account"

  # e.g. stdemodev1a2b3 (max 24 chars, no dashes allowed)
  name                = "st${var.project}${var.environment}${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  replication_type    = var.storage_replication_type
  containers          = var.storage_containers
  tags                = local.tags
}

module "app_service" {
  source = "./modules/app_service"

  plan_name           = "asp-${local.prefix}"
  app_name            = "app-${local.prefix}-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = var.app_service_sku
  node_version        = var.app_node_version

  app_settings = {
    STORAGE_ACCOUNT_NAME = module.storage.name
  }

  tags = local.tags
}

module "key_vault" {
  source = "./modules/key_vault"

  name                = "kv${var.project}${var.environment}${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # the web app's managed identity gets read access to secrets
  reader_principals = {
    webapp = module.app_service.principal_id
  }

  secrets = {
    "vm-admin-password" = random_password.vm_admin.result
  }

  tags = local.tags
}

module "vm" {
  source = "./modules/vm"

  name                = "vm-${local.prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.network.subnet_ids["vm"]
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  admin_password      = random_password.vm_admin.result
  ssh_source_cidr     = var.ssh_source_cidr
  tags                = local.tags
}

module "aks" {
  source = "./modules/aks"

  name                = "aks-${local.prefix}"
  dns_prefix          = "aks-${local.prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kubernetes_version  = var.kubernetes_version
  node_count          = var.aks_node_count
  node_vm_size        = var.aks_node_vm_size
  vnet_subnet_id      = module.network.subnet_ids["aks"]
  tags                = local.tags
}
