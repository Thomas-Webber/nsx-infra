### It creates the following objects:
- Tier-1 Gateway (that gets attached to an existing Tier-0 Gateway)
- A DHCP Server providing DHCP Addresses to all 3 Segments
- 3 Segments (Web, App, DB)
### The config below requires the following to be pre-created
- Edge Cluster
- Overlay Transport Zone
- Tier-0 Gateway

```
#Example terraform.tfvars
nsx_manager = "nsx-manager.adlere.priv"
nsx_username = "admin"
nsx_password = "VMware1!VMwawre1!"
```