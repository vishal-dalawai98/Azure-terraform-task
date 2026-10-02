resource "azurerm_service_plan" "this" {
  name                = var.plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                = var.app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    # always_on isn't supported on the free/shared tiers
    always_on           = !contains(["F1", "D1"], var.sku_name)
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"

    application_stack {
      node_version = var.node_version
    }
  }

  app_settings = var.app_settings

  tags = var.tags
}
