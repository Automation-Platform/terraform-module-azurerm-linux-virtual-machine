output "azurerm_public_ip" {
  value = var.public_ip_enabled ? azurerm_public_ip.pip[0].ip_address : null
}

output "azurerm_network_interface" {
  value = azurerm_network_interface.eth0.private_ip_address
}

output "azurerm_linux_virtual_machine" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "azurerm_managed_disk" {
  value = azurerm_managed_disk.data
}
