# Azure infra with Terraform

Creates the following in one resource group:

- Virtual network with two subnets (vm, aks)
- Linux VM (Ubuntu 22.04) with a public IP, SSH restricted to your IP
- Storage account with private blob containers
- Key Vault (VM password is stored in it, web app can read secrets)
- App Service plan + Linux web app (Node)
- AKS cluster (Azure CNI, placed in the aks subnet)

## Layout

```
.
├── main.tf                  # wires the modules together
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars.example
└── modules/
    ├── network/
    ├── storage_account/
    ├── key_vault/
    ├── vm/
    ├── app_service/
    └── aks/
```

## Before you start

- Terraform >= 1.5
- Azure CLI, logged in: `az login`
- Pick the subscription: `az account set --subscription "<name or id>"`

## Running it step by step

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars, at least set ssh_source_cidr to your own IP

terraform init
terraform fmt -recursive
terraform validate
terraform plan -out main.tfplan
terraform apply main.tfplan
```

If you want to go one piece at a time (good for understanding what each
module does), target them in this order. Network goes first because VM and
AKS depend on it:

```bash
terraform apply -target=module.network
terraform apply -target=module.storage
terraform apply -target=module.app_service
terraform apply -target=module.key_vault
terraform apply -target=module.vm
terraform apply -target=module.aks
terraform apply          # final run to pick up anything left
```

## After apply

`terraform output next_steps` prints the commands for fetching the VM
password from Key Vault, SSH and kubectl.

## Clean up

```bash
terraform destroy
```

## Things worth knowing

- AKS takes around 5-10 minutes, the rest is quick.
- `Standard_B2s` is the default for both VM and AKS nodes. If you get a quota
  or SKU error, change `vm_size` / `aks_node_vm_size` or the region.
- Storage account, Key Vault and web app names get a random 5 character suffix
  so they don't clash with someone else's.
- Purge protection on Key Vault is off so destroy/recreate works in dev. Turn it on
  for prod (`purge_protection_enabled` in the key_vault module).
- State is local. Use the commented backend block in `providers.tf` once you
  have a storage account for it.
- Don't commit `terraform.tfvars` or state files, the password ends up in state.
