resource "aws_ec2_tag" "vpc_identity" {
  provider    = aws.identity
  depends_on  = [
    aws_ram_principal_association.network_primary_infrastructure_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count = length(local.vpc_tags_primary)

  resource_id = module.vpc_primary[0].vpc_id
  key         = keys(local.vpc_tags_primary)[count.index]
  value       = local.vpc_tags_primary[keys(local.vpc_tags_primary)[count.index]]
}

resource "aws_ec2_tag" "subnets_pub_identity" {
  provider    = aws.identity
  depends_on  = [
    aws_ram_principal_association.network_primary_infrastructure_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count       = length(module.vpc_primary[0].public_subnets)

  resource_id = module.vpc_primary[0].public_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-vpc-pub-${count.index}"
}

resource "aws_ec2_tag" "subnets_pvt_identity" {
  provider    = aws.identity
  depends_on  = [
    aws_ram_principal_association.network_primary_infrastructure_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count       = length(module.vpc_primary[0].private_subnets)

  resource_id = module.vpc_primary[0].private_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-vpc-pvt-${count.index}"
}

resource "aws_ec2_tag" "vpc_log_archive" {
  provider    = aws.log_archive
  depends_on  = [
    aws_ram_principal_association.network_primary_security_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count = length(local.vpc_tags_primary)

  resource_id = module.vpc_primary[0].vpc_id
  key         = keys(local.vpc_tags_primary)[count.index]
  value       = local.vpc_tags_primary[keys(local.vpc_tags_primary)[count.index]]
}

resource "aws_ec2_tag" "subnets_pub_log_archive" {
  provider    = aws.log_archive
  depends_on  = [
    aws_ram_principal_association.network_primary_security_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count       = length(module.vpc_primary[0].public_subnets)

  resource_id = module.vpc_primary[0].public_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-vpc-pub-${count.index}"
}

resource "aws_ec2_tag" "subnets_pvt_log_archive" {
  provider    = aws.log_archive
  depends_on  = [
    aws_ram_principal_association.network_primary_security_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count       = length(module.vpc_primary[0].private_subnets)

  resource_id = module.vpc_primary[0].private_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-vpc-pvt-${count.index}"
}

resource "aws_ec2_tag" "vpc_security_tooling" {
  provider    = aws.security_tooling
  depends_on  = [
    aws_ram_principal_association.network_primary_security_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count = length(local.vpc_tags_primary)

  resource_id = module.vpc_primary[0].vpc_id
  key         = keys(local.vpc_tags_primary)[count.index]
  value       = local.vpc_tags_primary[keys(local.vpc_tags_primary)[count.index]]
}

resource "aws_ec2_tag" "subnets_pub_security_tooling" {
  provider    = aws.security_tooling
  depends_on  = [
    aws_ram_principal_association.network_primary_security_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count       = length(module.vpc_primary[0].public_subnets)

  resource_id = module.vpc_primary[0].public_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-vpc-pub-${count.index}"
}

resource "aws_ec2_tag" "subnets_pvt_security_tooling" {
  provider    = aws.security_tooling
  depends_on  = [
    aws_ram_principal_association.network_primary_security_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count       = length(module.vpc_primary[0].private_subnets)

  resource_id = module.vpc_primary[0].private_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-vpc-pvt-${count.index}"
}

resource "aws_ec2_tag" "vpc_identity_failover" {
  provider    = aws.identity_failover
  depends_on = [
    aws_ram_principal_association.network_failover_infrastructure_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count = var.vpc_failover_enabled ? length(local.vpc_tags_failover) : 0

  resource_id = module.vpc_failover[0].vpc_id
  key         = keys(local.vpc_tags_primary)[count.index]
  value       = local.vpc_tags_primary[keys(local.vpc_tags_primary)[count.index]]
}

resource "aws_ec2_tag" "subnets_pub_identity_failover" {
  provider    = aws.identity_failover
  depends_on = [
    aws_ram_principal_association.network_failover_infrastructure_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count       = var.vpc_failover_enabled ? length(module.vpc_failover[0].public_subnets) : 0

  resource_id = module.vpc_failover[0].public_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-vpc-pub-${count.index}"
}

resource "aws_ec2_tag" "subnets_pvt_identity_failover" {
  provider    = aws.identity_failover
  depends_on = [
    aws_ram_principal_association.network_failover_infrastructure_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count       = var.vpc_failover_enabled ? length(module.vpc_failover[0].private_subnets) : 0

  resource_id = module.vpc_failover[0].private_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-vpc-pvt-${count.index}"
}

resource "aws_ec2_tag" "vpc_log_archive_failover" {
  provider    = aws.log_archive_failover
  depends_on = [
    aws_ram_principal_association.network_failover_security_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count = var.vpc_failover_enabled ? length(local.vpc_tags_failover) : 0


  resource_id = module.vpc_failover[0].vpc_id
  key         = keys(local.vpc_tags_primary)[count.index]
  value       = local.vpc_tags_primary[keys(local.vpc_tags_primary)[count.index]]
}

resource "aws_ec2_tag" "subnets_pub_log_archive_failover" {
  provider    = aws.log_archive_failover
  depends_on = [
    aws_ram_principal_association.network_failover_security_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count       = var.vpc_failover_enabled ? length(module.vpc_failover[0].public_subnets) : 0

  resource_id = module.vpc_failover[0].public_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-vpc-pub-${count.index}"
}

resource "aws_ec2_tag" "subnets_pvt_log_archive_failover" {
  provider    = aws.log_archive_failover
  depends_on = [
    aws_ram_principal_association.network_failover_security_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count       = var.vpc_failover_enabled ? length(module.vpc_failover[0].private_subnets) : 0

  resource_id = module.vpc_failover[0].private_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-vpc-pvt-${count.index}"
}

resource "aws_ec2_tag" "vpc_security_tooling_failover" {
  provider    = aws.security_tooling_failover
  depends_on = [
    aws_ram_principal_association.network_failover_security_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count = var.vpc_failover_enabled ? length(local.vpc_tags_failover) : 0

  resource_id = module.vpc_failover[0].vpc_id
  key         = keys(local.vpc_tags_primary)[count.index]
  value       = local.vpc_tags_primary[keys(local.vpc_tags_primary)[count.index]]
}

resource "aws_ec2_tag" "subnets_pub_security_tooling_failover" {
  provider    = aws.security_tooling_failover
  depends_on = [
    aws_ram_principal_association.network_failover_security_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count       = var.vpc_failover_enabled ? length(module.vpc_failover[0].public_subnets) : 0

  resource_id = module.vpc_failover[0].public_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-vpc-pub-${count.index}"
}

resource "aws_ec2_tag" "subnets_pvt_security_tooling_failover" {
  provider    = aws.security_tooling_failover
  depends_on = [
    aws_ram_principal_association.network_failover_security_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count       = var.vpc_failover_enabled ? length(module.vpc_failover[0].private_subnets) : 0

  resource_id = module.vpc_failover[0].private_subnets[count.index]
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-vpc-pvt-${count.index}"
}