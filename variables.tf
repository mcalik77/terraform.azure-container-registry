variable info {
  type = object({
    domain      = string
    subdomain   = string
    environment = string
    sequence    = string
  })

  description = "Info object used to construct naming convention for all resources."
}

variable tags {
  type        = map(string)
  description = "Tags object used to tag resources."
}

# Resource Group
variable resource_group_name {}
variable location {}

variable sku {}

// variable ip_range {
//     default = "204.153.155.151,104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26"
// }
variable admin_enabled {
    default = false
}

variable georeplication_locations {
type = list
default = []
}

variable ip_whitelist {}

variable "subnet_whitelist" {
 type = list(object({
   virtual_network_name                = string
   virtual_network_subnet_name         = string
   virtual_network_resource_group_name = string
  }
))
} 

variable private_endpoint_subnet{
  type = object (
    {
      virtual_network_name                = string
      virtual_network_subnet_name         = string
      virtual_network_resource_group_name = string
    }
  )
}

variable subresource_names {
     type = list
}

variable dns_resource_group_name {
     type    = string
     default = "hubvnetrg"
}

variable private_endpoint_enabled {
  type    = bool
  default = false
}