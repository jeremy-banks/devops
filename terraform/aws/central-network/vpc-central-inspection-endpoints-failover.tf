# module "vpc_inspection_endpoints_failover" {
#   source    = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version   = "~> 6.0.1"
#   providers = { aws = aws.this_failover }

#   count = var.create_failover_region_network ? 1 : 0

#   vpc_id = module.vpc_inspection_failover[0].vpc_id

#   create_security_group = false
#   # create_security_group      = true
#   # security_group_name_prefix = "${local.resource_name_failover}-central-inspection-firewall-sg"
#   # security_group_rules       = { ingress_https = { cidr_blocks = ["0.0.0.0/0"] } }

#   endpoints = {
#     network-firewall-fips = {
#       service             = "network-firewall-fips"
#       private_dns_enabled = true
#       subnet_ids          = module.vpc_inspection_failover[0].private_subnets
#       security_group_ids  = [module.sg_inspection_main_failover[0].security_group_id]
#     }
#   }
# }