output "vnet_id" {
  value       = module.vnet.resource_id
  description = "Resource ID of the virtual network"
}

output "vnet_name" {
  value       = module.vnet.name
  description = "Name of the virtual network"
}

output "workload_subnet_id" {
  value       = module.vnet.subnets["workload"].resource_id
  description = "Resource ID of the workload subnet"
}

output "management_subnet_id" {
  value       = module.vnet.subnets["management"].resource_id
  description = "Resource ID of the management subnet"
}

output "law_id" {
  value       = module.log_analytics.resource_id
  description = "Resource ID of the Log Analytics Workspace"
}

output "nsg_workload_id" {
  value       = module.nsg_workload.resource_id
  description = "Resource ID of the workload NSG"
}
