# resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_primary" {
#   provider = aws.sdlc_prd

#   count = local.vpc_cidr_primary != "" ? 1 : 0

#   subnet_ids                                      = module.vpc_primary[0].private_subnets
#   transit_gateway_id                              = data.aws_ec2_transit_gateway.tgw_primary.id
#   vpc_id                                          = module.vpc_primary[0].vpc_id
#   dns_support                                     = "enable"
#   security_group_referencing_support              = "enable"
#   transit_gateway_default_route_table_association = true
#   transit_gateway_default_route_table_propagation = true
# }

# resource "aws_ec2_tag" "tgw_primary" {
#   provider    = aws.sdlc_prd

#   count = local.vpc_cidr_primary != "" ? 1 : 0

#   resource_id = data.aws_ec2_transit_gateway.tgw_primary.id
#   key         = "Name"
#   value       = "${local.resource_name_stub_primary}-network-tgw"
# }

# resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_failover" {
#   provider = aws.sdlc_prd_failover

#   count = var.create_failover_region ? 1 : 0

#   subnet_ids                                      = module.vpc_failover[0].private_subnets
#   transit_gateway_id                              = data.aws_ec2_transit_gateway.tgw_failover.id
#   vpc_id                                          = module.vpc_failover[0].vpc_id
#   dns_support                                     = "enable"
#   security_group_referencing_support              = "enable"
#   transit_gateway_default_route_table_association = true
#   transit_gateway_default_route_table_propagation = true
# }

# resource "aws_ec2_tag" "tgw_failover" {
#   provider    = aws.sdlc_prd_failover

#   count = var.create_failover_region ? 1 : 0

#   resource_id = data.aws_ec2_transit_gateway.tgw_failover.id
#   key         = "Name"
#   value       = "${local.resource_name_stub_failover}-network-tgw"
# }