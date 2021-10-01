# Azure Container Registry 
Terraform module that provisions an azure container registry. When you choose sku to "Premium", you have option to create private endpoints,  georeplication_locations and network_rule_set ( White list the ip_rule). You can also choose to create a service enpoints but Microsoft recomended using private endpoints instead of service endpoints in most network scenarios bc there are some limitation using service enpoint. [More info to check](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet)

## Usage
You can include the module by using the following code:

```
# Azure Container Registry

## Resource Group Module
module "rg" {
  source = "git::git@ssh.dev.azure.com:v3/AZBlue/OneAZBlue/terraform.devops.resource-group?ref=v0.0.5"

  info = var.info
  tags = var.tags

  location = var.location
}

# Azure Container Registry Module
module "azure-container-registry" {
  source = "git::git@ssh.dev.azure.com:v3/AZBlue/OneAZBlue/terraform.devops.azure-container-registry?ref=v1.0.0"
  
  info = var.info
  tags = var.tags
  
  # Resource Group
  resource_group_name  = module.rg.name
  location             = module.rg.location
  
  sku          = var.sku
  ip_whitelist = var.ip_whitelist
  
  georeplication_locations = var.georeplication_locations
  subnet_whitelist         = var.subnet_whitelist
  
  # Private endpoints
  private_endpoint         = var.private_endpoint
  private_endpoint_enabled = var.private_endpoint_enabled
  subresource_names        = var.subresource_names
  dns_resource_group_name  = var.dns_resource_group_name

}
```

## Inputs

The following are the supported inputs for the module.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| info | Info object used to construct naming convention for all resources. | `object` | n/a | yes |
| tags | Tags object used to tag resources. | `object` | n/a | yes |
| resource_group | Name of the resource group where Azure Event Grid Subscription will be deployed. | `string` | n/a | yes |
| location | Location of Azure Event Grid Subscription. | `string` | n/a | yes |
| sku | The SKU name of the container registry. Possible values are Basic, Standard and Premium. Classic (which was previously Basic) is supported only for existing resources. | `string` | n/a | no |
| admin_enabled | Specifies whether the admin user is enabled. Defaults to false. | `bool` | false | no |
| georeplication_locations | A list of Azure locations where the container registry should be geo-replicated -  Only supported on new resources with the Premium SKU - The georeplication_locations list cannot contain the location where the Container Registry exists | `string` | [] | no |
| subnet_whitelist | One or more virtual_network blocks as defined below.  Configuring a registry service endpoint is available in the Premium container registry service tier. Microsoft recommend using private endpoints instead of service endpoints in most network scenarios bc there are some limitation using service enpoint. [More info to check](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet) | `List of Object` | n/a | no |
| ip_whitelist | White list of ip rules | `string` | N/A | no |
| private_endpoint | List of objects of the subnet information that private endpoint will be created.  | `list of object` | [] | yes, if private_endpoint_enabled |
| private_endpoint_enabled | Enable the private endpoint integration  | `bool` | `false` | no |
| subresource_names | List of subresource names  | `list` | n/a | yes, if private_endpoint_enabled |
| dns_resource_group_name | DNS resource group name | `string` | `hubvnetrg`