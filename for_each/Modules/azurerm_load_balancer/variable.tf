variable "lb_name" {
  description = "The name of the load balancer"
  type        = map(any)
  
}

# variable "frontend_ip_configuration_name" {
#   description = "The name of the frontend IP configuration"
#   type        = map(any)
  
# }

variable "backend_address_pool_name" {
  description = "The name of the backend address pool"
  type        = map(any)
  
}

variable "lb_nat_pool_name" {
  description = "The name of the load balancer NAT pool"
  type        = map(any)
  
}

variable "lb_probe_name" {
  description = "The name of the load balancer probe"
  type        = map(any)
  
}

variable "lb_rule_name" {
  description = "The name of the load balancer rule"
  type        = map(any)
  
}

variable "public_ip_name" {
  description = "The name of the public IP"
  type        = map(any)
  
}


