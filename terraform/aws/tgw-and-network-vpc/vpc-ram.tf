resource "aws_ram_resource_association" "primary_pub" {
  provider = aws.network

  count = length(module.vpc_primary.public_subnet_arns)
  resource_arn       = module.vpc_primary.public_subnet_arns[count.index]
  resource_share_arn = module.tgw_primary.ram_resource_share_id
}

resource "aws_ram_resource_association" "primary_pvt" {
  provider = aws.network

  count = length(module.vpc_primary.private_subnet_arns)
  resource_arn       = module.vpc_primary.private_subnet_arns[count.index]
  resource_share_arn = module.tgw_primary.ram_resource_share_id
}

resource "aws_ram_resource_association" "failover_pub" {
  provider = aws.network_failover

  count = length(module.vpc_failover.public_subnet_arns)
  resource_arn       = module.vpc_failover.public_subnet_arns[count.index]
  resource_share_arn = module.tgw_failover.ram_resource_share_id
}

resource "aws_ram_resource_association" "failover_pvt" {
  provider = aws.network_failover

  count = length(module.vpc_failover.private_subnet_arns)
  resource_arn       = module.vpc_failover.private_subnet_arns[count.index]
  resource_share_arn = module.tgw_failover.ram_resource_share_id
}