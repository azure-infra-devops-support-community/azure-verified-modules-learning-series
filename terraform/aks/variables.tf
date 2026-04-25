variable "resource_group_name" {
  description = "Name of the resource group for AKS resources."
  type        = string
  default     = "rg-aksprod-demo"
}

variable "location" {
  description = "Azure region for deployment. Prefer eastus2 over eastus for this AVM: eastus often has no AKS-supported availability zones while the module still assigns zones from Compute SKUs, which fails with AvailabilityZoneNotSupported."
  type        = string
  default     = "eastus2"
}

variable "vnet_name" {
  description = "Virtual network name."
  type        = string
  default     = "vnet-aksprod-demo"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
  default     = ["10.31.0.0/16"]
}

variable "node_subnet_name" {
  description = "Subnet name for AKS nodes."
  type        = string
  default     = "snet-aks-nodes"
}

variable "node_subnet_prefixes" {
  description = "Address prefixes for the AKS node subnet."
  type        = list(string)
  default     = ["10.31.0.0/17"]
}

variable "aks_name" {
  description = "AKS cluster name."
  type        = string
  default     = "aksprod-demo"
}

variable "pod_cidr" {
  description = "CIDR for Kubernetes pods."
  type        = string
  default     = "192.168.0.0/16"
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services."
  type        = string
  default     = "10.32.0.0/16"
}

variable "dns_service_ip" {
  description = "DNS service IP within the service CIDR."
  type        = string
  default     = "10.32.0.10"
}

variable "kubernetes_version" {
  description = "AKS Kubernetes minor version only (e.g. 1.34). Avoid stale minors that resolve only to LTS-only patches unless you use Premium + LTS; check with: az aks get-versions -l <region>."
  type        = string
  default     = "1.34"
}

variable "default_node_pool_vm_sku" {
  description = "VM SKU for the default node pool."
  type        = string
  default     = "Standard_D4d_v5"
}

variable "enable_telemetry" {
  description = "Enable AVM telemetry."
  type        = bool
  default     = false
}

variable "rbac_aad_tenant_id" {
  description = "Microsoft Entra tenant ID for AKS AAD RBAC. Leave empty to use the tenant of the Azure provider credentials (same as the AVM module examples)."
  type        = string
  default     = ""
}

variable "rbac_aad_admin_group_object_ids" {
  description = "Optional Entra ID group object IDs for AKS admin access."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default = {
    environment = "demo"
    workload    = "aks"
    owner       = "platform"
  }
}