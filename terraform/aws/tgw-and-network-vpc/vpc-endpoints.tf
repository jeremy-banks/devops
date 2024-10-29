resource "aws_vpc_endpoint" "primary" {
  provider = aws.network

  count = local.vpc_cidr_primary != "" && var.network_vpc_endpoint_services_enabled != [] ? length(var.network_vpc_endpoint_services_enabled) : 0

  vpc_id            = module.vpc_primary[0].vpc_id
  service_name      = "com.amazonaws.${var.region.primary}.${var.network_vpc_endpoint_services_enabled[count.index]}"
  vpc_endpoint_type = "Interface"
  security_group_ids = [module.vpc_main_sg_primary[0].security_group_id]
  subnet_ids = module.vpc_primary[0].private_subnets
}

resource "aws_vpc_endpoint" "failover" {
  provider = aws.network_failover

  count = local.create_failover_region && var.network_vpc_endpoint_services_enabled != [] ? length(var.network_vpc_endpoint_services_enabled) : 0

  vpc_id            = module.vpc_failover[0].vpc_id
  service_name      = "com.amazonaws.${var.region.failover}.${var.network_vpc_endpoint_services_enabled[count.index]}"
  vpc_endpoint_type = "Interface"
  security_group_ids = [module.vpc_main_sg_failover[0].security_group_id]
  subnet_ids = module.vpc_failover[0].private_subnets
}