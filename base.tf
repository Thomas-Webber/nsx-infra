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
    edge_cluster_path        = data.nsxt_policy_edge_cluster.edge_cluster.path
    failover_mode            = "NON_PREEMPTIVE"
    ha_mode                  = "ACTIVE_ACTIVE"
    # internal_transit_subnets = ["169.254.0.0/24"]
    # transit_subnets          = ["100.64.0.0/16"]

    bgp_config {
        enabled                            = false
        inter_sr_ibgp                      = false
        ecmp                               = false
        multipath_relax                    = false
    }
}
resource "nsxt_policy_tier0_gateway_interface" "interface1" {
  display_name           = "vtp0"
  description            = "Virtual to Physical interface"
  type                   = "EXTERNAL"
  gateway_path           = nsxt_policy_tier0_gateway.t0_gateway.path
  segment_path           = nsxt_policy_vlan_segment.vlan_segment.path
  subnets                = [var.t0_interface]
}
resource "nsxt_policy_static_route" "route1" {
  display_name = "sroute"
  gateway_path = nsxt_policy_tier0_gateway.t0_gateway.path
  network      = "0.0.0.0/0"
  next_hop {
    ip_address     = var.t0_next_hop
  }
}


# T1
resource "nsxt_policy_tier1_gateway" "t1_gateway" {
    default_rule_logging      = false
    display_name              = var.t1_name
    edge_cluster_path         = data.nsxt_policy_edge_cluster.edge_cluster.path
    enable_firewall           = true
    enable_standby_relocation = false
    failover_mode             = "NON_PREEMPTIVE"
    force_whitelisting        = false
    pool_allocation           = "LB_SMALL"
    route_advertisement_types = [
        "TIER1_CONNECTED",
        "TIER1_DNS_FORWARDER_IP",
        "TIER1_IPSEC_LOCAL_ENDPOINT",
        "TIER1_STATIC_ROUTES",
    ]
    tier0_path                = nsxt_policy_tier0_gateway.t0_gateway.path
}

# Overlay Segment
resource "nsxt_policy_segment" "seg1" {
    connectivity_path   = nsxt_policy_tier1_gateway.t1_gateway.path
    dhcp_config_path    = nsxt_policy_dhcp_server.dhcp.path
    display_name        = var.segment_overlay_name
    transport_zone_path = data.nsxt_policy_transport_zone.tz_overlay.path

    subnet {
        cidr            = var.segment_overlay_config.cidr
        dhcp_ranges     = var.segment_overlay_config.ranges
        dhcp_v4_config {
            server_address  = var.segment_overlay_config.dhcp
            lease_time      = 60
            dns_servers     = var.segment_overlay_config.dns
        }
    }

    advanced_config {
        connectivity = "ON"
    }
}