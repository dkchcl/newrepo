# since these variables are re-used - a locals block makes this more maintainable
# locals {
#   backend_address_pool_name      = "${azurerm_virtual_network.vnet.name}-beap"
#   frontend_port_name             = "${azurerm_virtual_network.example.name}-feport"
#   frontend_ip_configuration_name = "${azurerm_virtual_network.example.name}-feip"
#   http_setting_name              = "${azurerm_virtual_network.example.name}-be-htst"
#   listener_name                  = "${azurerm_virtual_network.example.name}-httplstn"
#   request_routing_rule_name      = "${azurerm_virtual_network.example.name}-rqrt"
#   redirect_configuration_name    = "${azurerm_virtual_network.example.name}-rdrcfg"
# }

resource "azurerm_application_gateway" "appgw" {
  name                = var.application_gateway_name
  resource_group_name = var.rg_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
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
    
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
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
