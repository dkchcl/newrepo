variable "rg_name" {
  description = "The name of the resource group"
  type        = string
  
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  
}

variable "bastion_name" {
  description = "The name of the bastion host"
  type        = string  
}

variable "ip_configuration_name" {
  description = "The name of the gateway IP configuration"
  type        = string  
}

variable "subnet_name" {
  description = "The ID of the subnet"
  type        = string    
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string 
}

variable "pip_name" {
  description = "The name of the public IP"
  type        = string 
}
