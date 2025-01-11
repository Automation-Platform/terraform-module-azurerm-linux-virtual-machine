mock_resource "azurerm_public_ip" {
  defaults = {
    id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/publicIPAddresses/publicIPAddressesValue"
  }
}
mock_resource "azurerm_network_interface" {
  defaults = {
    id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/networkInterfaces/networkInterfaceValue"
  }
}
mock_resource "azurerm_linux_virtual_machine" {
  defaults = {
    id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Compute/virtualMachines/virtualMachineValue"
  }
}
mock_resource "azurerm_managed_disk" {
  defaults = {
    id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Compute/disks/diskValue"
  }
}
