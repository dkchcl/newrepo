variable "nic_name" {
  description = "The name of the network interface"
  type        = map(any)
  
}

variable "nsg_name" {
  description = "The name of the network security group"
  type        = map(any)

}