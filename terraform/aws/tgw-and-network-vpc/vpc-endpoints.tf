resource "aws_vpc_endpoint" "primary" {
  provider = aws.network

  count = var.vpc_network_endpoints_enabled && length(var.vpc_network_endpoint_services) > 0 ? length(var.vpc_network_endpoint_services) : 0

  vpc_id            = module.vpc_primary[0].vpc_id
  service_name      = "com.amazonaws.${var.region.primary}.${var.vpc_network_endpoint_services[count.index]}"
  vpc_endpoint_type = "Interface"
  security_group_ids = [module.vpc_main_sg_primary[0].security_group_id]
  subnet_ids = module.vpc_primary[0].private_subnets
}

resource "aws_vpc_endpoint" "failover" {
  provider = aws.network_failover

  count = var.vpc_failover_enabled && var.vpc_network_endpoints_enabled && length(var.vpc_network_endpoint_services) > 0 ? length(var.vpc_network_endpoint_services) : 0

  vpc_id            = module.vpc_failover[0].vpc_id
  service_name      = "com.amazonaws.${var.region.failover}.${var.vpc_network_endpoint_services[count.index]}"
  vpc_endpoint_type = "Interface"
  security_group_ids = [module.vpc_main_sg_failover[0].security_group_id]
  subnet_ids = module.vpc_failover[0].private_subnets
}