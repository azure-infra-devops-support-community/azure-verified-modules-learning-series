# ── Resource Group ─────────────────────────────────────────────────────────────
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

# ── Log Analytics Workspace ────────────────────────────────────────────────────
# Deploy first — the VNet module references this workspace ID for diagnostics
module "log_analytics" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.4.0"

  name                = "law-network-${var.environment}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  enable_telemetry    = true
}

# ── Network Security Group — Workload Subnet ───────────────────────────────────
# Deny internet inbound by default; allow VNet-to-VNet traffic
module "nsg_workload" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  name                = "nsg-workload-${var.environment}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  enable_telemetry    = true

  security_rules = {
    allow_vnet_inbound = {
      name                       = "AllowVnetInbound"
      priority                   = 900
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
    deny_internet_inbound = {
      name                       = "DenyInternetInbound"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "Internet"
      destination_address_prefix = "VirtualNetwork"
    }
  }
}

# ── Virtual Network ────────────────────────────────────────────────────────────
module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.7.0"

  name                = "vnet-foundation-${var.environment}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  address_space       = var.vnet_address_space
  enable_telemetry    = true

  subnets = {
    workload = {
      name             = "snet-workload"
      address_prefixes = ["10.10.1.0/24"]
      network_security_group = {
        id = module.nsg_workload.resource_id
      }
    }
    management = {
      name             = "snet-management"
      address_prefixes = ["10.10.2.0/24"]
    }
  }

  diagnostic_settings = {
    to_law = {
      name                  = "diag-vnet-to-law"
      workspace_resource_id = module.log_analytics.resource_id
    }
  }

  tags = {
    environment = var.environment
    managed_by  = "terraform-avm"
  }
}
