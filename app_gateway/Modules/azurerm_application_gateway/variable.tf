variable "rg_name" {
  description = "The name of the resource group"
  type        = string
  
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  
}

variable "application_gateway_name" {
  description = "The name of the application gateway"
  type        = string
  
}

variable "gateway_ip_configuration_name" {
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

variable "frontend_port_name" {
  description = "The name of the frontend port"
  type        = string    
}

variable "frontend_ip_configuration_name" {
  description = "The name of the frontend IP configuration"
  type        = string  
}

variable "pip_name" {
  description = "The name of the public IP"
  type        = string 
}

variable "backend_address_pool_name" {
  description = "The name of the backend address pool"
  type        = string  
}

variable "http_setting_name" {
  description = "The name of the HTTP setting"
  type        = string  
}

variable "listener_name" {
  description = "The name of the listener"
  type        = string  
}

variable "request_routing_rule_name" {
  description = "The name of the request routing rule"
  type        = string  
}

variable "backend_vm_private_ips" {
  description = "List of private IP addresses of VM NICs to add to backend pool"
  type        = list(string)
  default     = []
}

variable "backend_vm_names" {
  description = "List of VM names to add to backend pool (optional, for reference)"
  type        = list(string)
  default     = []
}

variable "vm1_nic_name" {
  description = "The name of the network interface"
  type        = string 
}

variable "vm2_nic_name" {
  description = "The name of the network interface"
  type        = string 
}