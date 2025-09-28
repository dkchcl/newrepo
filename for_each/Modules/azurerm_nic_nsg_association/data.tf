data "azurerm_network_interface" "nic" {
  for_each = var.nic_name

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_network_security_group" "nsg" {
  for_each = var.nsg_name

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}