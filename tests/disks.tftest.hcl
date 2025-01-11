run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

mock_provider "azurerm" {
  source = "./tests/mocks"
}

run "test_single_data_disks" {
  command = apply

  variables {
    name                = "simplevm"
    location            = run.setup_tests.resource_group.location
    resource_group_name = run.setup_tests.resource_group.name
    data_disks = [
      {
        name = "disk1"
        size_gb = 100
      }
    ]
  }

  assert {
    condition = length(azurerm_managed_disk.data) == 1
    error_message = "expected 1 data disks"
  }

  assert {
    condition = azurerm_managed_disk.data["disk1"].disk_size_gb == 100
    error_message = "size of disk not match configuration passed by input variable"
  }

  assert {
    condition = azurerm_managed_disk.data["disk1"].name == "simplevm-disk1"
    error_message = "Disk name not match"
  }
}

run "test_multiple_data_disks" {
  command = apply

  variables {
    name                = "simplevm"
    location            = run.setup_tests.resource_group.location
    resource_group_name = run.setup_tests.resource_group.name
    data_disks = [
      {
        name = "disk1"
        size_gb = 100
      },
      {
        name = "disk2"
        size_gb = 50
      }
    ]
  }

  assert {
    condition = length(azurerm_managed_disk.data) == 2
    error_message = "expected 2 data disks"
  }

  # test disk1
  assert {
    condition = azurerm_managed_disk.data["disk1"].disk_size_gb == 100
    error_message = "size of disk not match configuration passed by input variable"
  }

  assert {
    condition = azurerm_managed_disk.data["disk1"].name == "simplevm-disk1"
    error_message = "Disk name not match"
  }

  # test disk2
  assert {
    condition = azurerm_managed_disk.data["disk2"].disk_size_gb == 50
    error_message = "size of disk not match configuration passed by input variable"
  }

  assert {
    condition = azurerm_managed_disk.data["disk2"].name == "simplevm-disk2"
    error_message = "Disk name not match"
  }
}

# check variable validation
run "check_disk_leather_than_30" {
  command = plan

  variables {
    name                = "simplevm"
    location            = run.setup_tests.resource_group.location
    resource_group_name = run.setup_tests.resource_group.name
    os_disk_size_gb = 29
  }

  expect_failures = [
    var.os_disk_size_gb
  ]
}

run "check_disk_leather_greather_than_512" {
  command = plan

  variables {
    name                = "simplevm"
    location            = run.setup_tests.resource_group.location
    resource_group_name = run.setup_tests.resource_group.name
    os_disk_size_gb = 513
  }

  expect_failures = [
    var.os_disk_size_gb
  ]
}
