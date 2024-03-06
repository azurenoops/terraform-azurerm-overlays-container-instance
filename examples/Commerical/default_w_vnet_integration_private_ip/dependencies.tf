# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_resource_group" "aci-network-rg" {
  name     = "aci-network-rg"
  location = var.location
  tags = {
    environment = "test"
  }
}

resource "azurerm_log_analytics_workspace" "aci-log" {
  depends_on = [
    azurerm_resource_group.aci-network-rg
  ]
  name                = "aci-log"
  location            = var.location
  resource_group_name = azurerm_resource_group.aci-network-rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = {
    environment = "test"
  }
}

resource "azurerm_virtual_network" "aci-vnet" {
  depends_on = [
    azurerm_resource_group.aci-network-rg
  ]
  name                = "aci-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.aci-network-rg.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "test"
  }
}

resource "azurerm_subnet" "aci-snet" {
  depends_on = [
    azurerm_resource_group.aci-network-rg,
    azurerm_virtual_network.aci-vnet
  ]
  name                 = "aci-subnet"
  resource_group_name  = azurerm_resource_group.aci-network-rg.name
  virtual_network_name = azurerm_virtual_network.aci-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "aci-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}