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






