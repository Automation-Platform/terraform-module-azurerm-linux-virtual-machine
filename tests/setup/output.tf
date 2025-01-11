output "resource_group" {
  value = azurerm_resource_group.rg
}

output "vnet" {
  value = azurerm_virtual_network.vnet
}

output "subnet_frontend" {
  value = azurerm_subnet.subnet_fe
}

output "subnet_backend" {
  value = azurerm_subnet.subnet_be
}
