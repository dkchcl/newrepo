variable "rg_name" {
  description = "The name of the resource group"
  type        = string
  
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  
}

variable "nic_name1" {
  description = "The name of the network interface"
  type        = string 
}

variable "nic_name2" {
  description = "The name of the network interface"
  type        = string 
}

variable "ip_configuration_name" {
  description = "The name of the IP configuration"
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