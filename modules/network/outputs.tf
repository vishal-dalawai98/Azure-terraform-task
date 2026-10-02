output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "subnet key (vm, aks, ...) => subnet id"
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}
