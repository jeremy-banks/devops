# resource "aws_vpc_endpoint" "primary" {
#   provider = aws.network_prd

#   count = var.vpc_endpoint_services_enabled != [] ? length(var.vpc_endpoint_services_enabled) : 0

#   vpc_id             = module.vpc_central_egress_primary.vpc_id
#   service_name       = "com.amazonaws.${var.region_primary.full}.${var.vpc_endpoint_services_enabled[count.index]}"
#   vpc_endpoint_type  = "Interface"
#   security_group_ids = ["${module.vpc_endpoint_sg_primary[count.index].security_group_id}"]
#   subnet_ids         = module.vpc_central_egress_primary.public_subnets
# }

# module "vpc_endpoint_sg_primary" {
#   source    = "terraform-aws-modules/security-group/aws"
#   version   = "~> 5.3.0"
#   providers = { aws = aws.network_prd }

#   count = var.vpc_endpoint_services_enabled != [] ? length(var.vpc_endpoint_services_enabled) : 0

#   name            = "vpc-endpoint-${element(var.vpc_endpoint_services_enabled, count.index)}"
#   use_name_prefix = false
#   description     = "vpc endpoint security group for ${element(var.vpc_endpoint_services_enabled, count.index)}"
#   vpc_id          = module.vpc_central_egress_primary.vpc_id

#   ingress_with_self = [
#     {
#       rule        = "all-all"
#       description = "allow ingress from self"
#     },
#   ]

#   egress_with_self = [
#     {
#       rule        = "all-all"
#       description = "allow egress to self"
#     },
#   ]
# }

# resource "aws_vpc_endpoint" "failover" {
#   provider = aws.network_prd_failover

#   count = var.create_failover_region_network && var.vpc_endpoint_services_enabled != [] ? length(var.vpc_endpoint_services_enabled) : 0

#   vpc_id             = module.vpc_central_egress_failover[0].vpc_id
#   service_name       = "com.amazonaws.${var.region_failover.full}.${var.vpc_endpoint_services_enabled[count.index]}"
#   vpc_endpoint_type  = "Interface"
#   security_group_ids = [module.vpc_endpoint_sg_failover[count.index].security_group_id]
#   subnet_ids         = module.vpc_central_egress_failover[0].public_subnets
# }

# module "vpc_endpoint_sg_failover" {
#   source    = "terraform-aws-modules/security-group/aws"
#   version   = "~> 5.3.0"
#   providers = { aws = aws.network_prd_failover }

#   count = var.create_failover_region_network && var.vpc_endpoint_services_enabled != [] ? length(var.vpc_endpoint_services_enabled) : 0

#   name            = "vpc-endpoint-${element(var.vpc_endpoint_services_enabled, count.index)}"
#   use_name_prefix = false
#   description     = "vpc endpoint security group for ${element(var.vpc_endpoint_services_enabled, count.index)}"
#   vpc_id          = module.vpc_central_egress_failover[0].vpc_id

#   ingress_with_self = [
#     {
#       rule        = "all-all"
#       description = "allow ingress from self"
#     },
#   ]

#   egress_with_self = [
#     {
#       rule        = "all-all"
#       description = "allow egress to self"
#     },
#   ]
# }