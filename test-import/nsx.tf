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

# IP Pool
resource "nsxt_policy_ip_pool" "ip_pool" {}
resource "nsxt_policy_ip_pool_static_subnet" "ip_pool_vtep" {}

# Vlan Segment
resource "nsxt_policy_vlan_segment" "vlan" {}

# DHCP
resource "nsxt_policy_dhcp_server" "dhcp" {}

# T0
resource "nsxt_policy_tier0_gateway" "t0_gateway" {}
resource "nsxt_policy_tier0_gateway_interface" "interface1" {}

# T1
resource "nsxt_policy_tier1_gateway" "t1_gateway" {}

# Segments
resource "nsxt_policy_segment" "seg1" {}
