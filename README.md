### It creates the following objects:
- Tier 0 Gateway
- Tier-1 Gateway (that gets attached to the Tier-0 Gateway)
- A DHCP Server providing DHCP Addresses to all 3 Segments
- 1 Segments (Web, App, DB)
### The config below requires the following to be pre-created
- Edge Cluster
- Overlay Transport Zone


```
#Example terraform.tfvars
nsx_manager = "192.168.145.10"
nsx_username = "admin"
nsx_password = "VMware1!VMwawre1!"
```

## Limites
Terraform can not create Route Advertisement rules for T0 Gateway
