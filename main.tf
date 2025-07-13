resource "azurerm_resource_group" "name" {
  name = "example-resource-group"
    location = "West Europe"
}

resource "azurerm_storage_account" "name1" {
  name                     = "examplestorageacct1"
  resource_group_name      = azurerm_resource_group.name.name
  location                 = azurerm_resource_group.name.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}