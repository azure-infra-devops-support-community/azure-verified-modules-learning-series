variable "location" {
  type        = string
  description = "Azure region for all resources"
}

variable "environment" {
  type        = string
  description = "Deployment environment: dev | staging | prod"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.10.0.0/16"]
  description = "Address space for the virtual network"
}
