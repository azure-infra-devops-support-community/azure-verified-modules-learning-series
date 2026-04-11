# Secure VNet Foundation — AVM + Terraform

Deploys a secure Azure Virtual Network foundation using Azure Verified Modules (AVM).

## Resources deployed

| Resource | AVM Module |
|---|---|
| Virtual Network | `Azure/avm-res-network-virtualnetwork/azurerm` v0.7.0 |
| Network Security Group | `Azure/avm-res-network-networksecuritygroup/azurerm` v0.2.0 |
| Log Analytics Workspace | `Azure/avm-res-operationalinsights-workspace/azurerm` v0.4.0 |

## Prerequisites

- Terraform >= 1.5.0
- Azure CLI installed and authenticated
- An existing resource group for Terraform state storage (`rg-tfstate`)
- An existing storage account for state (`sttfstatedev`, container: `tfstate`)

## Usage

```bash
# 1. Authenticate
az login
az account set --subscription "<your-subscription-id>"

# 2. Initialise — downloads AVM modules
terraform init

# 3. Preview changes
terraform plan -var-file="terraform.tfvars"

# 4. Deploy
terraform apply -var-file="terraform.tfvars"

# 5. View outputs
terraform output
```

## Configuration

Edit `terraform.tfvars` to change environment values:

```hcl
location             = "uksouth"        # Azure region
environment          = "dev"            # dev | staging | prod
resource_group_name  = "rg-network-dev-uks"
vnet_address_space   = ["10.10.0.0/16"]
```

## Security defaults

- Internet inbound **denied** on workload subnet (priority 1000)
- VNet-to-VNet traffic **allowed** (priority 900)
- All VNet diagnostics flow to Log Analytics Workspace
- Tags applied to all resources: `environment` and `managed_by`

## References

- AVM portal: https://aka.ms/AVM
- Terraform module index: https://aka.ms/AVM/ModuleIndex/Terraform
- Terraform hands-on lab: https://aka.ms/avm/tf/labs
