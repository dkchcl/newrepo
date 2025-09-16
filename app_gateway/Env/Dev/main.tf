module "rg" {
  source   = "../../Modules/azurerm_resource_group"
  rg_name  = "rg-dev-weu-001"
  location = "West Europe"
}

module "vnet" {
  depends_on    = [module.rg]
  source        = "../../Modules/azurerm_virtual_network"
  vnet_name     = "vnet-dev-weu-001"
  address_space = ["10.0.0.0/16"]
  rg_name       = "rg-dev-weu-001"
  location      = "West Europe"
}

module "subnet1" {
  depends_on       = [module.vnet]
  source           = "../../Modules/azurerm_subnet"
  subnet_name      = "snet-dev-weu-001"
  vnet_name        = "vnet-dev-weu-001"
  address_prefixes = ["10.0.1.0/24"]
  rg_name          = "rg-dev-weu-001"
}

module "subnet2" {
  depends_on       = [module.vnet]
  source           = "../../Modules/azurerm_subnet"
  subnet_name      = "snet-dev-appgw-002"
  vnet_name        = "vnet-dev-weu-001"
  address_prefixes = ["10.0.2.0/24"]
  rg_name          = "rg-dev-weu-001"
}

module "subnet3" {
  depends_on       = [module.vnet]
  source           = "../../Modules/azurerm_subnet"
  subnet_name      = "AzureBastionSubnet"
  vnet_name        = "vnet-dev-weu-001"
  address_prefixes = ["10.0.3.0/24"]
  rg_name          = "rg-dev-weu-001"
}

module "pip1" {
  depends_on        = [module.rg]
  source            = "../../Modules/azurerm_public_ip"
  pip_name          = "bastion-pip-dev-001"
  rg_name           = "rg-dev-weu-001"
  location          = "West Europe"
  allocation_method = "Static"
}

module "pip2" {
  depends_on        = [module.rg]
  source            = "../../Modules/azurerm_public_ip"
  pip_name          = "appgw-pip-dev-001"
  rg_name           = "rg-dev-weu-001"
  location          = "West Europe"
  allocation_method = "Static"
}

module "nsg" {
  depends_on = [module.rg]
  source     = "../../Modules/azurerm_network_security_group"
  nsg_name   = "nsg-dev-weu-001"
  rg_name    = "rg-dev-weu-001"
  location   = "West Europe"
}

module "nic" {
  depends_on            = [module.subnet1, module.vnet]
  source                = "../../Modules/azurerm_network_interface"
  nic_name1             = "vm-nic-dev-001"
  nic_name2             = "vm-nic-dev-002"
  rg_name               = "rg-dev-weu-001"
  location              = "West Europe"
  subnet_name           = "snet-dev-weu-001"
  vnet_name             = "vnet-dev-weu-001"
  ip_configuration_name = "vm-ip-config"
}

# module "bastion" {
#   depends_on            = [module.pip1, module.subnet3]
#   source                = "../../Modules/azurerm_bastion_host"
#   bastion_name          = "bastion-dev-weu-001"
#   rg_name               = "rg-dev-weu-001"
#   location              = "West Europe"
#   bsubnet_name          = "AzureBastionSubnet"
#   vnet_name             = "vnet-dev-weu-001"
#   pip_name              = "bastion-pip-dev-001"
#   ip_configuration_name = "bastion-ip-config"
# }

module "nic_sub_nsg_assoc" {
  depends_on  = [module.nsg, module.nic, module.subnet2, module.vnet]
  source      = "../../Modules/azurerm_nic_sub_nsg_assoc"
  rg_name     = "rg-dev-weu-001"
  nic_name1   = "vm-nic-dev-001"
  nic_name2   = "vm-nic-dev-002"
  nsg_name    = "nsg-dev-weu-001"
  vnet_name   = "vnet-dev-weu-001"
  subnet_name = "snet-dev-appgw-002"
}

module "vm1" {
  depends_on                   = [module.nic, module.nic_sub_nsg_assoc, module.subnet1, module.vnet]
  source                       = "../../Modules/azurerm_virtual_machine"
  vm_name                      = "vm1-dev-weu-001"
  rg_name                      = "rg-dev-weu-001"
  location                     = "West Europe"
  vm_size                      = "Standard_B1s"
  nic_name                     = "vm-nic-dev-001"
  admin_username               = "adminuser"
  admin_password               = "Password1234!"
  os_disk_caching              = "ReadWrite"
  os_disk_storage_account_type = "Standard_LRS"
  image_publisher              = "Canonical"
  image_offer                  = "UbuntuServer"
  image_sku                    = "18.04-LTS"
  image_version                = "latest"
}

module "vm2" {
  depends_on                   = [module.nic, module.nic_sub_nsg_assoc, module.subnet1, module.vnet]
  source                       = "../../Modules/azurerm_virtual_machine"
  vm_name                      = "vm2-dev-weu-001"
  rg_name                      = "rg-dev-weu-001"
  location                     = "West Europe"
  vm_size                      = "Standard_B1s"
  nic_name                     = "vm-nic-dev-002"
  admin_username               = "adminuser"
  admin_password               = "Password1234!"
  os_disk_caching              = "ReadWrite"
  os_disk_storage_account_type = "Standard_LRS"
  image_publisher              = "Canonical"
  image_offer                  = "UbuntuServer"
  image_sku                    = "18.04-LTS"
  image_version                = "latest"
}

module "appgw" {
  depends_on                     = [module.pip2, module.vm1, module.vm2, module.nic_sub_nsg_assoc]
  source                         = "../../Modules/azurerm_application_gateway"
  application_gateway_name       = "appgw-dev-weu-001"
  rg_name                        = "rg-dev-weu-001"
  location                       = "West Europe"
  gateway_ip_configuration_name  = "appgw-gateway-ip-config"
  frontend_ip_configuration_name = "appgw-frontend-ip-config"
  frontend_port_name             = "appgw-frontend-port"
  backend_address_pool_name      = "appgw-backend-pool"
  http_setting_name              = "appgw-backend-http-settings"
  listener_name                  = "appgw-http-listener"
  request_routing_rule_name      = "appgw-request-routing-rule"
  subnet_name                    = "snet-dev-appgw-002"
  vnet_name                      = "vnet-dev-weu-001"
  pip_name                       = "appgw-pip-dev-001"
  vm1_nic_name                   = "vm-nic-dev-001"
  vm2_nic_name                   = "vm-nic-dev-002"
}



