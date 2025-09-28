resource "azurerm_lb" "lb" {
  for_each = var.lb_name

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = "Standard"
  sku_tier            = "Regional"

  frontend_ip_configuration {

    name                 = each.value.frontend_ip_configuration_name
    public_ip_address_id = data.azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  for_each = var.backend_address_pool_name

  loadbalancer_id = azurerm_lb.lb.id
  name            = each.value.name
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  for_each = var.lb_nat_pool_name

  resource_group_name            = each.value.resource_group_name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
}

resource "azurerm_lb_probe" "lb_probe" {
  for_each = var.lb_probe_name

  loadbalancer_id = azurerm_lb.lb.id
  name            = each.value.name
  protocol        = "Http"
  request_path    = "/"
  port            = 80

}

resource "azurerm_lb_rule" "http_rule" {
  for_each = var.lb_rule_name

  loadbalancer_id                = azurerm_lb.lb.id
  name                           = each.value.name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
}



