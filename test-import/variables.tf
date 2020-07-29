variable "nsx_manager" {}
variable "nsx_username" {}
variable "nsx_password" {}


# required objets
variable "transport_zone" { default = "Overlay-TZ" }
variable "edge_cluster" { default = "Edge-Cluster" }


# IP management
variable "dhcp_name" { default = "tier_dhcp" }
variable "dhcp_subnet" {default = "10.0.99.2/24"}


# Routers
# variable "t0_name" {}
# variable "t0_static_route" {}

# variable "t1_name" {}
# variable "t1_services" {}


# # Segments
# variable "segments" {}


# Misc
variable "tag_scope" { default = "creator" }
variable "tag" { default = "terraform" }