terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "aks" {
  name     = var.resource_group_name
  location = var.location
}

# VNet + subnet: same shape as Microsoft Learn (deploy-cluster-terraform-verified-module); names/CIDRs from terraform.tfvars.
resource "azurerm_virtual_network" "aks" {
  name                = var.vnet_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "aks_nodes" {
  name                 = var.node_subnet_name
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.node_subnet_prefixes
}

# AVM 0.5.0 enables node Encryption at Host by default; that requires the subscription
# feature Microsoft.Compute/EncryptionAtHost. If apply fails with SubscriptionNotEnabledEncryptionAtHost,
# register the feature (see Microsoft docs) or set host_encryption_enabled = false in
# .terraform/modules/aks_production/main.tf (re-do after terraform init).
module "aks_production" {
  source  = "Azure/avm-ptn-aks-production/azurerm"
  version = "0.5.0"

  depends_on = [
    azurerm_subnet.aks_nodes,
  ]

  name                = var.aks_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name

  network = {
    node_subnet_id = azurerm_subnet.aks_nodes.id
    pod_cidr       = var.pod_cidr
    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
  }

  kubernetes_version               = var.kubernetes_version
  default_node_pool_vm_sku         = var.default_node_pool_vm_sku
  enable_telemetry                 = var.enable_telemetry
  rbac_aad_tenant_id = (
    var.rbac_aad_tenant_id != ""
    ? var.rbac_aad_tenant_id
    : data.azurerm_client_config.current.tenant_id
  )
  rbac_aad_admin_group_object_ids = var.rbac_aad_admin_group_object_ids
  tags                             = var.tags
}