output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vm_public_ip" {
  value = module.vm.public_ip
}

output "vm_admin_username" {
  value = var.vm_admin_username
}

output "storage_account_name" {
  value = module.storage.name
}

output "storage_blob_endpoint" {
  value = module.storage.primary_blob_endpoint
}

output "key_vault_name" {
  value = module.key_vault.name
}

output "key_vault_uri" {
  value = module.key_vault.vault_uri
}

output "app_service_url" {
  value = "https://${module.app_service.default_hostname}"
}

output "aks_cluster_name" {
  value = module.aks.name
}

# handy copy-paste commands after apply
output "next_steps" {
  value = <<-EOT
    Get the VM password:
      az keyvault secret show --vault-name ${module.key_vault.name} --name vm-admin-password --query value -o tsv

    SSH into the VM:
      ssh ${var.vm_admin_username}@${module.vm.public_ip}

    Connect kubectl to AKS:
      az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${module.aks.name}
  EOT
}
