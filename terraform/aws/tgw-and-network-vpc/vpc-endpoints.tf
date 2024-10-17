# module "vpc_endpoints_primary" {
#   source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version = "5.13.0"
#   providers = { aws = aws.network }

#   vpc_id             = module.vpc_primary.vpc_id
#   security_group_ids = [module.vpc_main_sg_primary.security_group_id]

#   endpoints = {
#     # dynamodb = {
#     #   service             = "dynamodb"
#     #   service_type        = "Interface"
#     #   security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
#     #   subnet_ids          = module.vpc_primary.private_subnets
#     #   route_table_ids     = module.vpc_primary.private_route_table_ids
#     #   tags                = { Name = "${local.resource_name_stub}-${var.region.primary_short}-dynamodb-endpoint" }
#     # },
#     # kms = {
#     #   service             = "kms"
#     #   service_type        = "Interface"
#     #   private_dns_enabled = true
#     #   security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
#     #   subnet_ids          = module.vpc_primary.private_subnets
#     #   route_table_ids     = module.vpc_primary.private_route_table_ids
#     #   tags                = { Name = "${local.resource_name_stub}-${var.region.primary_short}-kms-endpoint" }
#     # },
#     # rds = {
#     #   service             = "rds"
#     #   private_dns_enabled = true
#     #   security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
#     #   subnet_ids          = module.vpc_primary.private_subnets
#     #   tags                = { Name = "${local.resource_name_stub}-${var.region.primary_short}-rds-endpoint" }
#     # },
#     s3 = {
#       service             = "s3"
#       service_type        = "Interface"
#       security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
#       subnet_ids          = module.vpc_primary.private_subnets
#       route_table_ids     = module.vpc_primary.private_route_table_ids
#       tags                = { Name = "${local.resource_name_stub}-${var.region.primary_short}-s3-endpoint" }
#     },
#     # secretsmanager = {
#     #   service             = "secretsmanager"
#     #   service_type        = "Interface"
#     #   private_dns_enabled = true
#     #   security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
#     #   subnet_ids          = module.vpc_primary.private_subnets
#     #   route_table_ids     = module.vpc_primary.private_route_table_ids
#     #   tags                = { Name = "${local.resource_name_stub}-${var.region.primary_short}-secretsmanager-endpoint" }
#     # },
#     # sns = {
#     #   service             = "sns"
#     #   service_type        = "Interface"
#     #   private_dns_enabled = true
#     #   security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
#     #   subnet_ids          = module.vpc_primary.private_subnets
#     #   route_table_ids     = module.vpc_primary.private_route_table_ids
#     #   tags                = { Name = "${local.resource_name_stub}-${var.region.primary_short}-sns-endpoint" }
#     # },
#     # sqs = {
#     #   service             = "sqs"
#     #   service_type        = "Interface"
#     #   private_dns_enabled = true
#     #   security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
#     #   subnet_ids          = module.vpc_primary.private_subnets
#     #   route_table_ids     = module.vpc_primary.private_route_table_ids
#     #   tags                = { Name = "${local.resource_name_stub}-${var.region.primary_short}-sqs-endpoint" }
#     # },
#   }
# }

# module "vpc_endpoints_failover" {
#   source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version = "5.13.0"
#   providers = { aws = aws.network_failover }

#   vpc_id             = module.vpc_failover.vpc_id
#   security_group_ids = [module.vpc_main_sg_failover.security_group_id]

#   endpoints = {
#     s3 = {
#       # interface endpoint
#       service             = "s3"
#       service_type  = "Gateway"
#       # private_dns_enabled = true
#       # security_group_ids  = [module.vpc_main_sg_failover.security_group_id]
#       subnet_ids = module.vpc_failover.private_subnets
#       route_table_ids = flatten([module.vpc_failover.private_route_table_ids, module.vpc_failover.public_route_table_ids])
#       tags                = { Name = "${local.resource_name_stub}-${var.region.failover_short}-s3-vpc-endpoint" }
#     },
#     rds = {
#       # interface endpoint
#       service             = "rds"
#       # service_type  = "Gateway"
#       private_dns_enabled = true
#       # security_group_ids  = [module.vpc_main_sg_failover.security_group_id]
#       subnet_ids = module.vpc_failover.private_subnets
#       # route_table_ids = flatten([module.vpc_failover.private_route_table_ids, module.vpc_failover.public_route_table_ids])
#       tags                = { Name = "${local.resource_name_stub}-${var.region.failover_short}-rds-endpoint" }
#     },
#     # dynamodb = {
#     #   # gateway endpoint
#     #   service         = "dynamodb"
#     #   route_table_ids = ["rt-12322456", "rt-43433343", "rt-11223344"]
#     #   tags            = { Name = "dynamodb-vpc-endpoint" }
#     # },
#     # sns = {
#     #   service    = "sns"
#     #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
#     #   tags       = { Name = "sns-vpc-endpoint" }
#     # },
#     # sqs = {
#     #   service             = "sqs"
#     #   private_dns_enabled = true
#     #   security_group_ids  = ["sg-987654321"]
#     #   subnet_ids          = ["subnet-12345678", "subnet-87654321"]
#     #   tags                = { Name = "sqs-vpc-endpoint" }
#     # },
#   }
# }