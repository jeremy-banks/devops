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

resource "aws_ec2_tag" "vpc_identity_name" {
  provider    = aws.identity

  resource_id = module.vpc_primary.vpc_id
  key         = "Name"
  value       = module.vpc_primary.name
}

resource "aws_ec2_tag" "vpc_identity_failover_name" {
  provider    = aws.identity_failover

  resource_id = module.vpc_failover.vpc_id
  key         = "Name"
  value       = module.vpc_failover.name
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

resource "aws_ec2_tag" "vpc_log_archive" {
  provider    = aws.log_archive
  for_each    = local.vpc_tags_primary

  resource_id = module.vpc_primary.vpc_id
  key         = each.key
  value       = each.value
}

resource "aws_ec2_tag" "vpc_log_archive_failover" {
  provider    = aws.log_archive_failover
  for_each    = local.vpc_tags_failover

  resource_id = module.vpc_failover.vpc_id
  key         = each.key
  value       = each.value
}

resource "aws_ec2_tag" "vpc_log_archive_name" {
  provider    = aws.log_archive

  resource_id = module.vpc_primary.vpc_id
  key         = "Name"
  value       = module.vpc_primary.name
}

resource "aws_ec2_tag" "vpc_log_archive_failover_name" {
  provider    = aws.log_archive_failover

  resource_id = module.vpc_failover.vpc_id
  key         = "Name"
  value       = module.vpc_failover.name
}

resource "aws_ec2_tag" "vpc_subnets_pub_log_archive_primary" {
  provider    = aws.log_archive
  count    = length(module.vpc_primary.public_subnets)

  resource_id = module.vpc_primary.public_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-network-vpc-pub-${count.index}"
}

resource "aws_ec2_tag" "vpc_subnets_pvt_log_archive_primary" {
  provider    = aws.log_archive
  count    = length(module.vpc_primary.private_subnets)

  resource_id = module.vpc_primary.private_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-network-vpc-pvt-${count.index}"
}

resource "aws_ec2_tag" "vpc_subnets_pub_log_archive_failover" {
  provider    = aws.log_archive_failover
  count    = length(module.vpc_failover.public_subnets)

  resource_id = module.vpc_failover.public_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-network-vpc-pub-${count.index}"
}

resource "aws_ec2_tag" "vpc_subnets_pvt_log_archive_failover" {
  provider    = aws.log_archive_failover
  count    = length(module.vpc_failover.private_subnets)

  resource_id = module.vpc_failover.private_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-network-vpc-pvt-${count.index}"
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

resource "aws_ec2_tag" "vpc_security_tooling_name" {
  provider    = aws.security_tooling

  resource_id = module.vpc_primary.vpc_id
  key         = "Name"
  value       = module.vpc_primary.name
}

resource "aws_ec2_tag" "vpc_security_tooling_failover_name" {
  provider    = aws.security_tooling_failover

  resource_id = module.vpc_failover.vpc_id
  key         = "Name"
  value       = module.vpc_failover.name
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