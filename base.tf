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
data "nsxt_policy_edge_cluster" "edge_cluster" { display_name = var.edge_cluster }
data "nsxt_policy_transport_zone" "tz_overlay" { display_name = var.tz_overlay }
data "nsxt_policy_transport_zone" "tz_vlan" { display_name = var.tz_vlan }

# IP Pool
resource "nsxt_policy_ip_pool" "ip_pool" { display_name = var.ip_pool_name }
resource "nsxt_policy_ip_pool_static_subnet" "ip_pool_vtep" {
    cidr            = var.ip_pool_range.cidr
    display_name    = var.ip_pool_range.name
    gateway         = var.ip_pool_range.gateway
    pool_path       = nsxt_policy_ip_pool.ip_pool.path

    allocation_range {
        end   = var.ip_pool_range.end
        start = var.ip_pool_range.start
    }
}

# Vlan Segment
resource "nsxt_policy_vlan_segment" "vlan_segment" {
    display_name        = "vlan_segment"
    transport_zone_path = data.nsxt_policy_transport_zone.tz_vlan.path
    vlan_ids            = ["0"]
    advanced_config {
        connectivity = "ON"
        hybrid       = false
        local_egress = false
    }
}

# DHCP
resource "nsxt_policy_dhcp_server" "dhcp" {
    display_name         = var.dhcp_name
    edge_cluster_path    = data.nsxt_policy_edge_cluster.edge_cluster.path
    server_addresses     = [var.dhcp_subnet]
    lease_time           = 60
}


# T0
resource "nsxt_policy_tier0_gateway" "t0_gateway" {
    default_rule_logging     = false
    dhcp_config_path         = nsxt_policy_dhcp_server.dhcp.path
    display_name             = var.t0_name
    # edge_cluster_path        = nsxt_policy_edge_cluster.edge_cluster.path
    failover_mode            = "NON_PREEMPTIVE"
    ha_mode                  = "ACTIVE_ACTIVE"
    internal_transit_subnets = ["169.254.0.0/24"]
    transit_subnets          = ["100.64.0.0/16"]

    bgp_config {
        enabled                            = false
        inter_sr_ibgp                      = false
    }
}
resource "nsxt_policy_tier0_gateway_interface" "interface1" {
  display_name           = "vtp0"
  description            = "Virtual to Physical interface"
  type                   = "EXTERNAL"
  gateway_path           = nsxt_policy_tier0_gateway.t0_gateway.path
  segment_path           = nsxt_policy_vlan_segment.vlan_segment.path
  subnets                = [var.t0_static_route]
}