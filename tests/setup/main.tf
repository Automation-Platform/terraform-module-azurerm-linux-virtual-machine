terraform {
  required_version = ">=1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  location = "italynorth"
  name     = "rg-test-vm"
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = ["192.168.100.0/24"]
  location            = azurerm_resource_group.rg.location
  name                = "vnet-test"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet_fe" {
  address_prefixes     = ["192.168.100.0/25"]
  name                 = "frontend"
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "subnet_be" {
  address_prefixes     = ["192.168.100.128/25"]
  name                 = "backend"
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

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
