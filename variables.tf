variable "nsx_manager" {}
variable "nsx_username" {}
variable "nsx_password" {}


# required objets
variable "tz_overlay" { default = "nsx-overlay-transportzone" }
variable "tz_vlan" { default = "nsx-vlan-transportzone" }
variable "edge_cluster" { default = "Edge-Cluster" }


# IP management
variable "ip_pool1_name" { default = "vtep" }
variable "ip_pool1_range" { 
    default = {
        "name": "vtep_range",
        "start": "172.20.11.151",
        "end": "172.20.11.170",
        "cidr": "172.20.11.0/24",
        "gateway": "172.20.11.10" 
    }
}
variable "ip_pool2_name" { default = "vtep_edge" }
variable "ip_pool2_range" { 
    default = {
        "name": "vtep_range",
        "start": "172.20.21.151",
        "end": "172.20.21.170",
        "cidr": "172.20.21.0/24",
        "gateway": "172.20.21.10" 
    }
}
variable "dhcp_name" { default = "default_dhcp" }
variable "dhcp_subnet" {default = "3.3.3.3/24"}


# Base Router T0
variable "t0_name" { default = "default_t0" }
variable "t0_interface" { default = "192.168.145.85/24" }
variable "t0_next_hop" { default = "192.168.145.254" }




# Secondary Router T1
variable "t1_name" { default = "default_t1" }


# Segments
variable "segment_overlay_name" { default = "segment_1" }
variable "segment_overlay_config" { 
    default = {
        "cidr": "10.0.1.1/24",
        "dhcp": "10.0.1.69/24",
        "ranges": ["10.0.1.2-10.0.1.60"],
        "dns": ["192.168.145.2"]
    }
}

# Misc
variable "tag_scope" { default = "creator" }
variable "tag" { default = "terraform" }