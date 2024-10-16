resource "aws_ec2_tag" "tgw_security_tooling" {
  provider    = aws.security_tooling

  resource_id = module.tgw_primary.ec2_transit_gateway_id
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-tgw"
}

resource "aws_ec2_tag" "tgw_security_tooling_failover" {
  provider    = aws.security_tooling_failover

  resource_id = module.tgw_failover.ec2_transit_gateway_id
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-tgw"
}

resource "aws_ec2_tag" "vpc_security_tooling" {
  provider    = aws.security_tooling
  for_each    = local.vpc_tags_primary

  resource_id = module.vpc_primary.vpc_id
  key         = each.key
  value       = each.value
}

resource "aws_ec2_tag" "vpc_security_tooling_failover" {
  provider    = aws.security_tooling_failover
  for_each    = local.vpc_tags_failover

  resource_id = module.vpc_failover.vpc_id
  key         = each.key
  value       = each.value
}

resource "aws_ec2_tag" "vpc_subnets_pub_security_tooling_primary" {
  provider    = aws.security_tooling
  count    = length(module.vpc_primary.public_subnets)

  resource_id = module.vpc_primary.public_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-network-vpc-pub-${count.index}"
}

resource "aws_ec2_tag" "vpc_subnets_pvt_security_tooling_primary" {
  provider    = aws.security_tooling
  count    = length(module.vpc_primary.private_subnets)

  resource_id = module.vpc_primary.private_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-network-vpc-pvt-${count.index}"
}

resource "aws_ec2_tag" "vpc_subnets_pub_security_tooling_failover" {
  provider    = aws.security_tooling_failover
  count    = length(module.vpc_failover.public_subnets)

  resource_id = module.vpc_failover.public_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-network-vpc-pub-${count.index}"
}

resource "aws_ec2_tag" "vpc_subnets_pvt_security_tooling_failover" {
  provider    = aws.security_tooling_failover
  count    = length(module.vpc_failover.private_subnets)

  resource_id = module.vpc_failover.private_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-network-vpc-pvt-${count.index}"
}