run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

variables {
  size            = "Standard_B1s"
  os_disk_size_gb = 30
  subnet_id       = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue/subnets/test"
  source_image = {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}


mock_provider "azurerm" {}

run "create_simple_vm" {
  command = plan

  variables {
    name                = "simplevm"
    location            = run.setup_tests.resource_group.location
    resource_group_name = run.setup_tests.resource_group.name

  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.name == "simplevm"
    error_message = "Invalid VM Name"
  }

  assert {
    condition     = azurerm_network_interface.eth0.name == "simplevm-nic"
    error_message = "Invalid Virtual NIC Name"
  }

}
