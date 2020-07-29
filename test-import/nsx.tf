provider "nsxt" {
  host                  = var.nsx_manager
  username              = var.nsx_username
  password              = var.nsx_password
  allow_unverified_ssl  = true
  max_retries           = 10
  retry_min_delay       = 500
  retry_max_delay       = 5000
  retry_on_status_codes = [429]
}


# Requirements
# data "nsxt_policy_edge_cluster" "edge_cluster" {
#   display_name = var.edge_cluster
# }

# data "nsxt_policy_transport_zone" "overlay_tz" {
#   display_name = var.transport_zone
# }


# T0
resource "nsxt_policy_tier0_gateway" "t0_gateway" {}

# # DHCP
# resource "nsxt_policy_dhcp_server" "tier_dhcp" {}

# # T1
# resource "nsxt_policy_tier1_gateway" "t1_gateway" {}

# # Segments
# resource "nsxt_policy_segment" "app" {}
