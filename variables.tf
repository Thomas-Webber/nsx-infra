variable "nsx_manager" {}
variable "nsx_username" {}
variable "nsx_password" {}


# required objets
variable "tz_overlay" { default = "nsx-overlay-transportzone" }
variable "tz_vlan" { default = "nsx-vlan-transportzone" }
variable "edge_cluster" { default = "Edge-Cluster" }


# IP management
variable "ip_pool_name" { default = "vtep" }
variable "ip_pool_range" { 
    default = {
        "name": "vtep_range",
        "start": "172.20.11.151",
        "end": "172.20.11.170",
        "cidr": "172.20.11.0/24",
        "gateway": "172.20.11.10" 
    }
}
variable "dhcp_name" { default = "default_dhcp" }
variable "dhcp_subnet" {default = "3.3.3.3/24"}


# Base Router
variable "t0_name" { default = "default_t0" }
variable "t0_static_route" { default = "192.168.95.41/24" }



# Secondary Router
# variable "t1_name" {}
# variable "t1_services" {}


# # Segments
# variable "segments" {}


# Misc
variable "tag_scope" { default = "creator" }
variable "tag" { default = "terraform" }