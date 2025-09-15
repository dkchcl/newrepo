variable "rg_name" {
  description = "The name of the resource group"
  type        = string
  
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  
}

variable "address_prefixes" {
  description = "The address prefixes of the subnet"
  type        = list(string)
  
}
