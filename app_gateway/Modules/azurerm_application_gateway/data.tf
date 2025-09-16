data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name  
}

data "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = var.rg_name
}

data "azurerm_network_interface" "nic1" {
  name                = var.vm1_nic_name
  resource_group_name = var.rg_name
}

data "azurerm_network_interface" "nic2" {
  name                = var.vm2_nic_name
  resource_group_name = var.rg_name
}