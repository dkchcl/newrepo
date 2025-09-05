variable "rg_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-vmss"
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
  default     = "West Europe"
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "vnet-vmss"
}