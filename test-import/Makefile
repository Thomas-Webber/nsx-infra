export TF_LOG=ERROR

init:
	terraform init

import:
	terraform import nsxt_policy_vlan_segment.vlan "vlan-segment" || echo 
	# terraform import nsxt_policy_dhcp_server.dhcp "Default_dhcp" || echo 

	# # terraform import nsxt_ip_pool.ip_pool "VTEP-IP-Pool" # ERROR
	# terraform import nsxt_policy_ip_pool_static_subnet.ip_pool_vtep "VTEP-IP-Pool/e6868dfa-d085-4a31-94cc-fa0e402fae65" || echo 

	# terraform import nsxt_policy_tier0_gateway.t0_gateway T0_Default || echo 
	# # terraform import nsxt_policy_tier0_gateway_interface.interface1 'T0_Default/6b0eb391-713b-4451-9387-e9d8caba1ef7/vtp0' # ERROR
	# terraform import nsxt_policy_tier1_gateway.t1_gateway "t1default" || echo 
	
	# terraform import nsxt_policy_segment.seg1 "test" || echo 
	terraform show

