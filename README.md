Task is create resources using terraform

- Virtual network with two subnets (vm, aks)
- Linux VM (Ubuntu 22.04) with a public IP, SSH restricted to your IP
- Storage account with private blob containers
- Key Vault (VM password is stored in it, web app can read secrets)
- App Service plan + Linux web app (Node)
- AKS cluster (Azure CNI, placed in the aks subnet)
