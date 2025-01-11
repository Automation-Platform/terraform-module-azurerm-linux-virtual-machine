resource "azurerm_public_ip" "pip" {
  count               = var.public_ip_enabled ? 1 : 0
  allocation_method   = "Static"
  location            = var.location
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface" "eth0" {
  location            = var.location
  name                = "${var.name}-nic"
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "primary"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
    public_ip_address_id          = var.public_ip_enabled ? azurerm_public_ip.pip[0].id : null
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  location                        = var.location
  name                            = var.name
  network_interface_ids           = [azurerm_network_interface.eth0.id]
  resource_group_name             = var.resource_group_name
  size                            = var.size
  disable_password_authentication = var.admin_password != null ? false : true
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  dynamic "admin_ssh_key" {
    for_each = var.admin_password == null && var.admin_ssh_key != null ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.admin_ssh_key
    }
  }
  os_disk {
    caching              = "None"
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }
  source_image_reference {
    publisher = var.source_image.publisher
    offer     = var.source_image.offer
    sku       = var.source_image.sku
    version   = var.source_image.version
  }
  boot_diagnostics {
    storage_account_uri = var.boot_diagnostic_storage_account_uri
  }
  tags = var.vm_tags
}

resource "azurerm_managed_disk" "data" {
  for_each             = { for disk in var.data_disks : disk.name => disk }
  create_option        = "Empty"
  location             = var.location
  name                 = "${azurerm_linux_virtual_machine.vm.name}-${each.value.name}"
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.storage_account_type
  disk_size_gb         = each.value.size_gb
}

locals {
  data_disks = [for k, v in azurerm_managed_disk.data : v]
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  count              = length(local.data_disks)
  caching            = "None"
  lun                = count.index + 1
  managed_disk_id    = azurerm_managed_disk.data[var.data_disks[count.index].name].id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
}
