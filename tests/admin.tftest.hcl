run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

mock_provider "azurerm" {
  source = "./tests/mocks"
}

run "use_password_authentication" {
  command = apply

  variables {
    name                = "simplevm"
    location            = run.setup_tests.resource_group.location
    resource_group_name = run.setup_tests.resource_group.name
    admin_password = "123Passw0rd!"
  }
  # test default value for admin_username
  assert {
    condition     = azurerm_linux_virtual_machine.vm.admin_password == "123Passw0rd!"
    error_message = "Invalid value fr admin_password"
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.disable_password_authentication == false
    error_message = "when password is used password_authentication must be enabled"
  }

  assert {
    condition = length(azurerm_linux_virtual_machine.vm.admin_ssh_key) == 0
    error_message = "when admin_password is specified admin_ssh_key must not be used"
  }
}


run "use_ssh_authentication" {
  command = apply

  variables {
    name                = "simplevm"
    location            = run.setup_tests.resource_group.location
    resource_group_name = run.setup_tests.resource_group.name
    admin_ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCI/gIcZpQis0zB8emzhQDokIwFzTnxL0PgFqyCfXhZFW4ClI0ROovdUa1QvzevWYrF18LRaZwEv6z144aksfifpDA1lMjJMRmYb2kTB8/J4kbdxXKvT4CVik+BhzxJSNG3/H+cutzK6gpBF+WpqmzPzD0pvCJj0W/AtXSfN4gwchXxJQJsU1MVMPkONoJGjkwn51mnryQtHM4jbTicysEHETX0StlDMLZPAnASC2My72CpSaSgCl9c5mo8RHgLQrZKxH7JaEj5ebDYZqSERhfzAkPvzTy7OPj663/rfq/noCfemataPVKUcpfyqxPHvXrNMI1GQGu1eq+pTs7oIrPF"
  }
  # test default value for admin_username
  assert {
    condition     = tolist(azurerm_linux_virtual_machine.vm.admin_ssh_key)[0].public_key == "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCI/gIcZpQis0zB8emzhQDokIwFzTnxL0PgFqyCfXhZFW4ClI0ROovdUa1QvzevWYrF18LRaZwEv6z144aksfifpDA1lMjJMRmYb2kTB8/J4kbdxXKvT4CVik+BhzxJSNG3/H+cutzK6gpBF+WpqmzPzD0pvCJj0W/AtXSfN4gwchXxJQJsU1MVMPkONoJGjkwn51mnryQtHM4jbTicysEHETX0StlDMLZPAnASC2My72CpSaSgCl9c5mo8RHgLQrZKxH7JaEj5ebDYZqSERhfzAkPvzTy7OPj663/rfq/noCfemataPVKUcpfyqxPHvXrNMI1GQGu1eq+pTs7oIrPF"
    error_message = "Invalid value for public key"
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.disable_password_authentication == true
    error_message = "when ssh key is used password_authentication must be disabled"
  }

  assert {
    condition = azurerm_linux_virtual_machine.vm.admin_password == null
    error_message = "when ssh_key is specified admin_password must not be used"
  }
}
