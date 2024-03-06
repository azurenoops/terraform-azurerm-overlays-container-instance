# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "random_id" "example" {
  byte_length = 8
}

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