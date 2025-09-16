resource "azurerm_application_gateway" "appgw" {
  name                = var.application_gateway_name
  resource_group_name = var.rg_name
  location            = var.location

  enable_http2 = true

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
    # capacity = 2
  }

  autoscale_configuration {
    min_capacity = 2
    max_capacity = 10
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_configuration_name
    subnet_id = data.azurerm_subnet.subnet.id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = data.azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = var.backend_address_pool_name

    ip_addresses = [data.azurerm_network_interface.nic1.private_ip_address, data.azurerm_network_interface.nic2.private_ip_address]
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
    host_name                      = "infraautomate.store"
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
  }
}



