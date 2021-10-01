data "azurerm_subnet" "subnet" {
  
  for_each = {
   for index, attribute in var.subnet_whitelist: index => attribute
  }

  name                 = each.value.virtual_network_subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.virtual_network_resource_group_name
  
  }

 
 locals {
  
  allowed_virtual_networks = [
    for subnet in data.azurerm_subnet.subnet : {
      action    = "Allow",
      subnet_id = subnet.id
    }
  ] 
}



locals {
  merged_tags = merge(var.tags, {
    domain = var.info.domain
    subdomain = var.info.subdomain
  })
}

module naming {
  source  = "github.com/Azure/terraform-azurerm-naming?ref=df6a893e8581ae2078fc40f65d3b9815ef86ac3d"
  // version = "0.1.0"
  suffix  = [ "${title(var.info.domain)}${title(var.info.subdomain)}" ]
}

module private_endpoint{

info    = var.info
tags    = var.tags
source  = "git::git@ssh.dev.azure.com:v3/AZBlue/OneAZBlue/terraform.devops.private-endpoint?ref=v0.0.6"

private_endpoint_subnet = var.private_endpoint_subnet

count               = var.private_endpoint_enabled ? 1:0
location            = var.location
resource_group_name = var.resource_group_name

resource_id             = azurerm_container_registry.acr.id
subresource_names       = ["registry"]
dns_resource_group_name = "hubvnetrg"


}




resource "azurerm_container_registry" "acr" {
  name                     = replace(
    format("%s%s%03d",
      lower(substr(
        module.naming.container_registry.name, 0, 
        module.naming.container_registry.max_length - 4
      )),
      lower(substr(title(var.info.environment), 0, 1)),
      title(var.info.sequence)
    ), "-", ""
  )
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.sku
  admin_enabled            = var.admin_enabled
  georeplication_locations = var.sku == "Premium" ? var.georeplication_locations : null


 network_rule_set = var.sku == "Premium" ?  [
   {
    default_action  = "Deny"
    ip_rule         = [
      {
      action = "Allow"
      ip_range = var.ip_whitelist
      }
    ]
    virtual_network = local.allowed_virtual_networks
   }] : []
  
}