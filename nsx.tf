# provider "nsxt" {
#   host                  = var.nsx_manager
#   username              = var.nsx_username
#   password              = var.nsx_password
#   allow_unverified_ssl  = true
#   max_retries           = 10
#   retry_min_delay       = 500
#   retry_max_delay       = 5000
#   retry_on_status_codes = [429]
# }


# # Requirements
# data "nsxt_policy_edge_cluster" "edge_cluster" {
#   display_name = var.edge_cluster
# }

# data "nsxt_policy_transport_zone" "overlay_tz" {
#   display_name = var.transport_zone
# }

# data "nsxt_policy_tier0_gateway" "t0_gateway" {
#   display_name = var.t0_name
# }

# # DHCP
# resource "nsxt_policy_dhcp_server" "tier_dhcp" {
#   display_name     = var.dhcp_name
#   server_addresses = [var.dhcp_subnet]
# }


# # T0 - TODO


# # T1
# resource "nsxt_policy_tier1_gateway" "t1_gateway" {
#   display_name              = "TF_T1"
#   description               = "Tier1 provisioned by Terraform"
#   edge_cluster_path         = data.nsxt_policy_edge_cluster.demo.path
#   dhcp_config_path          = nsxt_policy_dhcp_server.tier_dhcp.path
#   failover_mode             = "PREEMPTIVE"
#   default_rule_logging      = "false"
#   enable_firewall           = "true"
#   enable_standby_relocation = "false"
#   force_whitelisting        = "false"
#   tier0_path                = data.nsxt_policy_tier0_gateway.t0_gateway.path
#   route_advertisement_types = ["TIER1_STATIC_ROUTES", "TIER1_CONNECTED"]
#   pool_allocation           = "ROUTING"

#   tag {
#     scope = var.nsx_tag_scope
#     tag   = var.nsx_tag
#   }

#   route_advertisement_rule {
#     name                      = "rule1"
#     action                    = "DENY"
#     subnets                   = ["20.0.0.0/24", "21.0.0.0/24"]
#     prefix_operator           = "GE"
#     route_advertisement_types = ["TIER1_CONNECTED"]
#   }
# }

# # Segments
# resource "nsxt_policy_segment" "app" {
#   display_name        = "app-tier"
#   description         = "Terraform provisioned App Segment"
#   connectivity_path   = nsxt_policy_tier1_gateway.t1_gateway.path
#   transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path

#   subnet {
#     cidr        = "10.0.1.1/24"
#     dhcp_ranges = ["10.0.1.100-10.0.1.160"]

#     dhcp_v4_config {
#       server_address = "10.0.1.2/24"
#       lease_time     = 36000

#       dhcp_option_121 {
#         network  = "6.6.6.0/24"
#         next_hop = "1.1.1.21"
#       }
#     }
#   }

#   tag { 
#     scope = var.nsx_tag_scope
#     tag   = var.nsx_tag
#   }
# }
