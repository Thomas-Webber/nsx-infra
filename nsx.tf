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

#
# Here we show that you define a NSX tag which can be used later to easily to
# search for the created objects in NSX.
#
variable "nsx_tag_scope" {
  default = "project"
}

variable "nsx_tag" {
  default = "terraform-demo"
}

#
# This part of the example shows some data sources we will need to refer to
# later in the .tf file. They include the transport zone, tier 0 router and
# edge cluster.
# Ther Tier-0 (T0) Gateway is considered a "provider" router that is pre-created
# by the NSX Admin. A T0 Gateway is used for north/south connectivity between
# the logical networking space and the physical networking space. Many Tier1
# Gateways will be connected to the T0 Gateway
#
data "nsxt_policy_edge_cluster" "demo" {
  display_name = "Edge-Cluster"
}

data "nsxt_policy_transport_zone" "overlay_tz" {
  display_name = "Overlay-TZ"
}

data "nsxt_policy_tier0_gateway" "t0_gateway" {
  display_name = "TF-T0-Gateway"
}

#
# Create a DHCP Profile that is used later
# Note, this resource is only in NSX 3.0.0+
resource "nsxt_policy_dhcp_server" "tier_dhcp" {
  display_name     = "tier_dhcp"
  description      = "DHCP server servicing all 3 Segments"
  server_addresses = ["10.0.99.2/24"]
}

#
# In this part of the example, the settings required to create a Tier1 Gateway
# are defined. In NSX a Tier1 Gateway is often used on a per user, tenant,
# department or application basis. Each application may have it's own Tier1
# Gateway. The Tier1 Gateway provides the default gateway for virtual machines
# connected to the Segments on the Tier1 Gateway
#
resource "nsxt_policy_tier1_gateway" "t1_gateway" {
  display_name              = "TF_T1"
  description               = "Tier1 provisioned by Terraform"
  edge_cluster_path         = data.nsxt_policy_edge_cluster.demo.path
  dhcp_config_path          = nsxt_policy_dhcp_server.tier_dhcp.path
  failover_mode             = "PREEMPTIVE"
  default_rule_logging      = "false"
  enable_firewall           = "true"
  enable_standby_relocation = "false"
  force_whitelisting        = "false"
  tier0_path                = data.nsxt_policy_tier0_gateway.t0_gateway.path
  route_advertisement_types = ["TIER1_STATIC_ROUTES", "TIER1_CONNECTED"]
  pool_allocation           = "ROUTING"

  tag {
    scope = var.nsx_tag_scope
    tag   = var.nsx_tag
  }

  route_advertisement_rule {
    name                      = "rule1"
    action                    = "DENY"
    subnets                   = ["20.0.0.0/24", "21.0.0.0/24"]
    prefix_operator           = "GE"
    route_advertisement_types = ["TIER1_CONNECTED"]
  }
}

resource "nsxt_policy_segment" "app" {
  display_name        = "app-tier"
  description         = "Terraform provisioned App Segment"
  connectivity_path   = nsxt_policy_tier1_gateway.t1_gateway.path
  transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path

  subnet {
    cidr        = "10.0.1.1/24"
    dhcp_ranges = ["10.0.1.100-10.0.1.160"]

    dhcp_v4_config {
      server_address = "10.0.1.2/24"
      lease_time     = 36000

      dhcp_option_121 {
        network  = "6.6.6.0/24"
        next_hop = "1.1.1.21"
      }
    }
  }

  tag {
    scope = var.nsx_tag_scope
    tag   = var.nsx_tag
  }
}
