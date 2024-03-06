# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_aci" {
  #source  = "azurenoops/overlays-container-instance/azurerm"
  #version = "x.x.x"
  source = "../../.."

  depends_on = [azurerm_resource_group.aci-network-rg]

  # Resource Group, location, VNet and Subnet details
  existing_resource_group_name = azurerm_resource_group.aci-network-rg.name
  location                     = var.location
  deploy_environment           = var.deploy_environment
  environment                  = var.environment
  org_name                     = var.org_name
  workload_name                = var.workload_name

  # Container Instance details
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.aci-log.workspace_id
  log_analytics_workspace_key = azurerm_log_analytics_workspace.aci-log.primary_shared_key

  vnet_integration_enabled = true # Enable VNet integration. Default is false, which means public IP
  subnet_ids               = [azurerm_subnet.aci-snet.id]

  # Container Group details
  containers_config = [
    {
      name   = "hello-world"
      image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
      cpu    = 1
      memory = 1

      ports = [{
        port     = 443
        protocol = "TCP"
      }]
    }
  ]

  # Optional: Set DNS configuration
  dns_config = {
    nameservers = ["1.1.1.1"]
  }
}
