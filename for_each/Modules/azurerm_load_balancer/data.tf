data "azurerm_public_ip" "pip" {
  for_each = var.public_ip_name

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}
