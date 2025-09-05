module "rg" {
  source   = "../../Modules/resource_group"
  rg_name  = "rg-dev-001"
  location = "West Europe"
}

module "vnet" {
  depends_on           = [module.rg]
  source               = "../../Modules/virtual_networks"
  rg_name              = "rg-dev-001"
  location             = "West Europe"
  virtual_network_name = "vnet-dev-001"
  address_space        = ["10.0.0.0/16"]
}

module "subnet1" {
  depends_on           = [module.vnet]
  source               = "../../Modules/subnet"
  rg_name              = "rg-dev-001"
  virtual_network_name = "vnet-dev-001"
  subnet_name          = "snet-dev-001"
  address_prefixes     = ["10.0.1.0/24"]
}

module "subnet2" {
  depends_on           = [module.vnet]
  source               = "../../Modules/subnet"
  rg_name              = "rg-dev-001"
  virtual_network_name = "vnet-dev-001"
  subnet_name          = "AzureBastionSubnet"
  address_prefixes     = ["10.0.2.0/24"]
}

module "nsg" {
  depends_on = [module.rg]
  source     = "../../Modules/network_security_group"
  rg_name    = "rg-dev-001"
  location   = "West Europe"
  nsg_name   = "nsg-dev-001"
}

module "public_ip1" {
  depends_on     = [module.rg]
  source         = "../../Modules/public_ip"
  rg_name        = "rg-dev-001"
  location       = "West Europe"
  public_ip_name = "pip-dev-001"
}

module "public_ip2" {
  depends_on     = [module.rg]
  source         = "../../Modules/public_ip"
  rg_name        = "rg-dev-001"
  location       = "West Europe"
  public_ip_name = "pip-dev-002"
}

module "bastion_host" {
  depends_on     = [module.subnet2, module.public_ip2]
  source         = "../../Modules/bastion_host"
  rg_name        = "rg-dev-001"
  location       = "West Europe"
  subnet_name    = "AzureBastionSubnet"
  vnet_name      = "vnet-dev-001"
  public_ip_name = "pip-dev-002"
  bastion_name   = "bastion-dev-001"
}

# module "kv" {
#   depends_on     = [module.rg]
#   source         = "../../Modules/key_vault"
#   rg_name        = "rg-dev-001"
#   location       = "West Europe"
#   key_vault_name = "kv-dev-001"  
# }

# module "kvs" {
#   depends_on          = [module.kv]
#   source              = "../../Modules/key_vault_secret"
#   rg_name             = "rg-dev-001"
#   key_vault_name      = "kv-dev-001"
#   key_vault_secret_name = "adminPassword"
#   key_vault_value     = "Password1234!"
# }

module "lb" {
  depends_on     = [module.public_ip1]
  source         = "../../Modules/load_balancer"
  rg_name        = "rg-dev-001"
  location       = "West Europe"
  lb_name        = "lb-dev-001"
  public_ip_name = "pip-dev-001"
}

module "lb_backend_address_pool" {
  depends_on                = [module.lb]
  source                    = "../../Modules/lb_backend_address_pool"
  rg_name                   = "rg-dev-001"
  lb_name                   = "lb-dev-001"
  backend_address_pool_name = "lb-backend-pool-001"

}

module "lb_probe" {
  depends_on    = [module.lb]
  source        = "../../Modules/lb_probe"
  lb_name       = "lb-dev-001"
  lb_probe_name = "tcp-probe-001"
  rg_name       = "rg-dev-001"
}

module "lb_rule" {
  depends_on                     = [module.lb, module.lb_backend_address_pool, module.lb_probe]
  source                         = "../../Modules/lb_rule"
  lb_name                        = "lb-dev-001"
  lb_rule_name                   = "http-rule-001"
  frontend_ip_configuration_name = "PublicFrontEnd"
  rg_name                        = "rg-dev-001"
  lb_probe_name                  = "tcp-probe-001"
  backend_address_pool_name      = "lb-backend-pool-001"
  probe_id                       = module.lb_probe.lb_probe_id
}

module "vmss" {
  depends_on                = [module.subnet1, module.nsg, module.lb, module.lb_backend_address_pool, module.lb_rule]
  source                    = "../../Modules/vmss"
  rg_name                   = "rg-dev-001"
  location                  = "West Europe"
  vmss_name                 = "vmss-dev-001"
  admin_username            = "azureuser"
  admin_password            = "Password1234!"
  virtual_network_name      = "vnet-dev-001"
  subnet_name               = "snet-dev-001"
  nsg_name                  = "nsg-dev-001"
  lb_name                   = "lb-dev-001"
  backend_address_pool_name = "lb-backend-pool-001"
}

module "monitor_autoscale" {
  depends_on = [module.vmss]
  source     = "../../Modules/monitor_autoscale"
  vmss_name  = "vmss-dev-001"
  rg_name    = "rg-dev-001"
  location   = "West Europe"

}



