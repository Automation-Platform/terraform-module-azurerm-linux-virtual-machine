run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

mock_provider "azurerm" {
  source = "./tests/mocks"
}

run "create_simple_vm" {
  command = apply

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

  assert {
    condition     = azurerm_linux_virtual_machine.vm.size == "Standard_B1s"
    error_message = "Size not match value passed from input var"
  }

  # test default value for admin_username
  assert {
    condition     = azurerm_linux_virtual_machine.vm.admin_username == "azadmin"
    error_message = "Invalid value found for default admin_username variable"
  }

  assert {
    condition     = azurerm_network_interface.eth0.ip_configuration[0].public_ip_address_id == null
    error_message = "Public IP must be null"
  }

}

run "use_custom_admin_username" {
  command = apply

  variables {
    name                = "simplevm"
    location            = run.setup_tests.resource_group.location
    resource_group_name = run.setup_tests.resource_group.name
    admin_username      = "mytest"
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.admin_username == "mytest"
    error_message = "admin_username not match value from input var"
  }
}

run "test_tags" {
  command = plan

  variables {
    name                = "simplevm"
    location            = run.setup_tests.resource_group.location
    resource_group_name = run.setup_tests.resource_group.name
    vm_tags = {
      "tag1" : "value1"
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.tags["tag1"] == "value1"
    error_message = "tags not found"
  }
}

run "test_public_ip" {
  command = apply

  variables {
    name                = "simplevm"
    location            = run.setup_tests.resource_group.location
    resource_group_name = run.setup_tests.resource_group.name
    public_ip_enabled   = true
  }

  assert {
    condition     = length(azurerm_network_interface.eth0.ip_configuration[0].public_ip_address_id) > 0
    error_message = "Public IP must not be null"
  }

  assert {
    condition     = length(azurerm_public_ip.pip) == 1
    error_message = "azurerm_public_ip instance not found"
  }

  assert {
    condition     = azurerm_public_ip.pip[0].id != null
    error_message = "public ip not created"
  }
}

run "test_no_data_disks" {
  command = apply

  variables {
    name                = "simplevm"
    location            = run.setup_tests.resource_group.location
    resource_group_name = run.setup_tests.resource_group.name
  }

  assert {
    condition     = length(azurerm_managed_disk.data) == 0
    error_message = "expected 0 data disks"
  }
}
