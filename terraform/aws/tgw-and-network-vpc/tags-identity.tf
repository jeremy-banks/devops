resource "aws_ec2_tag" "tgw_identity" {
  provider    = aws.identity

  resource_id = module.tgw_primary.ec2_transit_gateway_id
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-tgw"
}

resource "aws_ec2_tag" "tgw_identity_failover" {
  provider    = aws.identity_failover

  resource_id = module.tgw_failover.ec2_transit_gateway_id
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-tgw"
}

resource "aws_ec2_tag" "vpc_identity" {
  provider    = aws.identity
  for_each    = local.vpc_tags_primary

  resource_id = module.vpc_primary.vpc_id
  key         = each.key
  value       = each.value
}

resource "aws_ec2_tag" "vpc_identity_failover" {
  provider    = aws.identity_failover
  for_each    = local.vpc_tags_failover

  resource_id = module.vpc_failover.vpc_id
  key         = each.key
  value       = each.value
}

resource "aws_ec2_tag" "vpc_subnets_pub_identity_primary" {
  provider    = aws.identity
  count    = length(module.vpc_primary.public_subnets)

  resource_id = module.vpc_primary.public_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-network-vpc-pub-${count.index}"
}

resource "aws_ec2_tag" "vpc_subnets_pvt_identity_primary" {
  provider    = aws.identity
  count    = length(module.vpc_primary.private_subnets)

  resource_id = module.vpc_primary.private_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-network-vpc-pvt-${count.index}"
}

resource "aws_ec2_tag" "vpc_subnets_pub_identity_failover" {
  provider    = aws.identity_failover
  count    = length(module.vpc_failover.public_subnets)

  resource_id = module.vpc_failover.public_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-network-vpc-pub-${count.index}"
}

resource "aws_ec2_tag" "vpc_subnets_pvt_identity_failover" {
  provider    = aws.identity_failover
  count    = length(module.vpc_failover.private_subnets)

  resource_id = module.vpc_failover.private_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-network-vpc-pvt-${count.index}"
}