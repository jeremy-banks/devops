# module "vpc_inspection_endpoints_primary" {
#   source    = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version   = "~> 6.0.1"
#   providers = { aws = aws.network_prd }

#   vpc_id = module.vpc_inspection_primary.vpc_id

#   create_security_group = false
#   # create_security_group      = true
#   # security_group_name_prefix = "${local.resource_name_primary}-central-inspection-firewall-sg"
#   # security_group_rules       = { ingress_https = { cidr_blocks = ["0.0.0.0/0"] } }

#   endpoints = {
#     network-firewall-fips = {
#       service             = "network-firewall-fips"
#       private_dns_enabled = true
#       subnet_ids          = module.vpc_inspection_primary.private_subnets
#       security_group_ids  = [module.sg_inspection_main_primary.security_group_id]
#     }
#   }
# }