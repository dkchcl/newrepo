module "rg" {
  source = "../../Modules/azurerm_resource_group"
  resource_groups = {
    rg1 = {
      name     = "rg-dev-001"
      location = "East US"
    }
    rg2 = {
      name     = "rg-dev-002"
      location = "West US"
    }
  }
}




module "vnet" {
  source = "../../Modules/azurerm_virtual_network"
  vnet_name = {
    vnet1 = {
      name                = "vnet-dev-001"
      address_space       = ["10.0.0.0/16"]
      location            = "East US"
      resource_group_name = "rg-dev-001"
    }
  }
}

module "subnet" {
  source = "../../Modules/azurerm_subnet"
  subnet_name = {
    subnet1 = {
      name                 = "subnet-dev-001"
      address_prefix       = "10.0.1.0/24"
      virtual_network_name = "vnet-dev-001"
    }
    subnet2 = {
      name                 = "subnet-dev-002"
      address_prefix       = "10.0.2.0/24"
      virtual_network_name = "vnet-dev-001"
    }
    subnet3 = {
      name                 = "azurebastionsubnet"
      address_prefix       = "10.0.3.0/24"
      virtual_network_name = "vnet-dev-001"
    }
  }
}

module "nsg" {
  source = "../../Modules/azurerm_network_security_group"
  nsg_name = {
    nsg1 = {
      name                = "nsg-dev-001"
      location            = "East US"
      resource_group_name = "rg-dev-001"
    }
  }
}

module "pip" {
  source = "../../Modules/azurerm_public_ip"
  pip_name = {
    pip1 = {
      name                = "pip-dev-001"
      location            = "East US"
      resource_group_name = "rg-dev-001"
      allocation_method   = "Static"
      sku                 = "Standard"
    }
    pip2 = {
      name                = "pip-dev-002"
      location            = "East US"
      resource_group_name = "rg-dev-001"
      allocation_method   = "Static"
      sku                 = "Standard"
    }
  }

}

module "nic" {
  source = "../../Modules/azurerm_network_interface"
  for_each = {
    nic1 = {
      nic_name             = "nic-dev-001"
      location             = "East US"
      resource_group_name  = "rg-dev-001"
      subnet_name          = "subnet-dev-001"
      virtual_network_name = "vnet-dev-001"
    }
    nic2 = {
      nic_name             = "nic-dev-002"
      location             = "East US"
      resource_group_name  = "rg-dev-001"
      subnet_name          = "subnet-dev-002"
      virtual_network_name = "vnet-dev-001"
    }
  }

  nic_name    = each.value.nic_name
  subnet_name = each.value.subnet_name
}


module "nic_nsg_assoc" {
  source = "../../Modules/azurerm_network_interface_security_group_association"
  nic_nsg_assoc_name = {
    assoc1 = {
      network_interface_id      = module.nic.nic_name["nic1"].id
      network_security_group_id = module.nsg.nsg_name["nsg1"].id
    }
  }
}

module "vm" {
  source = "../../Modules/azurerm_virtual_machine"

  for_each = {
    vm1 = {
      name                 = "vm-dev-001"
      location             = "East US"
      resource_group_name  = "rg-dev-001"
      network_interface_id = module.nic["nic1"].id
      vm_size              = "Standard_DS1_v2"
      admin_username       = "adminuser"
      admin_password       = "P@ssw0rd123!"
    }
    vm2 = {
      name                 = "vm-dev-002"
      location             = "East US"
      resource_group_name  = "rg-dev-001"
      network_interface_id = module.nic["nic2"].id
      vm_size              = "Standard_DS1_v2"
      admin_username       = "adminuser"
      admin_password       = "P@ssw0rd123!"
    }
  }

  name                 = each.value.name
  location             = each.value.location
  resource_group_name  = each.value.resource_group_name
  network_interface_id = each.value.network_interface_id
  vm_size              = each.value.vm_size
  admin_username       = each.value.admin_username
  admin_password       = each.value.admin_password
}


module "lb" {
  source = "../../Modules/azurerm_lb"
  lb_name = {
    lb1 = {
      name                           = "lb-dev-001"
      location                       = "East US"
      resource_group_name            = "rg-dev-001"
      sku                            = "Standard"
      frontend_ip_configuration_name = "LoadBalancerFrontEnd"
      public_ip_address_id           = module.pip.pip_name["pip1"].id
      backend_address_pool_name      = ""
      lb_nat_pool_name = {
        natpool1 = {
          resource_group_name            = "rg-dev-001"
          frontend_ip_configuration_name = "LoadBalancerFrontEnd"
        }
      }
      lb_probe_name = {
        probe1 = {
          name = "http-probe"
        }
      }
      lb_rule_name = {
        rule1 = {
          name = "http-rule"
        }
      }
    }
  }

}



