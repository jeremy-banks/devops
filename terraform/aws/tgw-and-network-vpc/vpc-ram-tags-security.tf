resource "aws_ec2_tag" "vpc_log_archive" {
  provider    = aws.log_archive
  depends_on  = [
    aws_ram_principal_association.network_primary_security_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count = length(merge(local.vpc_tags_primary, local.default_tags, { "Name" = "${local.resource_name_stub_primary}-${local.this_slug}-vpc" }))

  resource_id = module.vpc_primary[0].vpc_id
  key         = keys(merge(local.vpc_tags_primary, local.default_tags, { "Name" = "${local.resource_name_stub_primary}-${local.this_slug}-vpc" }))[count.index]
  value       = merge(local.vpc_tags_primary, local.default_tags, { "Name" = "${local.resource_name_stub_primary}-${local.this_slug}-vpc" })[keys(merge(local.vpc_tags_primary, local.default_tags, { "Name" = "${local.resource_name_stub_primary}-${local.this_slug}-vpc" }))[count.index]]
}

resource "aws_ec2_tag" "subnets_pub_log_archive" {
  provider    = aws.log_archive
  depends_on  = [
    aws_ram_principal_association.network_primary_security_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count       = length(module.vpc_primary[0].public_subnets)

  resource_id = module.vpc_primary[0].public_subnets[count.index]
  key         = keys(merge(local.public_subnet_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}${count.index}" }))[count.index]
  value       = merge(local.public_subnet_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}${count.index}" })[keys(merge(local.public_subnet_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}${count.index}" }))[count.index]]
}

resource "aws_ec2_tag" "subnets_pvt_log_archive" {
  provider    = aws.log_archive
  depends_on  = [
    aws_ram_principal_association.network_primary_security_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count       = length(module.vpc_primary[0].private_subnets)

  resource_id = module.vpc_primary[0].private_subnets[count.index]
  key         = keys(merge(local.private_subnet_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}${count.index}" }))[count.index]
  value       = merge(local.private_subnet_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}${count.index}" })[keys(merge(local.private_subnet_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}${count.index}" }))[count.index]]
}

resource "aws_ec2_tag" "vpc_security_tooling" {
  provider    = aws.security_tooling
  depends_on  = [
    aws_ram_principal_association.network_primary_security_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count = length(merge(local.vpc_tags_primary, local.default_tags, { "Name" = "${local.resource_name_stub_primary}-${local.this_slug}-vpc" }))

  resource_id = module.vpc_primary[0].vpc_id
  key         = keys(merge(local.vpc_tags_primary, local.default_tags, { "Name" = "${local.resource_name_stub_primary}-${local.this_slug}-vpc" }))[count.index]
  value       = merge(local.vpc_tags_primary, local.default_tags, { "Name" = "${local.resource_name_stub_primary}-${local.this_slug}-vpc" })[keys(merge(local.vpc_tags_primary, local.default_tags, { "Name" = "${local.resource_name_stub_primary}-${local.this_slug}-vpc" }))[count.index]]
}

resource "aws_ec2_tag" "subnets_pub_security_tooling" {
  provider    = aws.security_tooling
  depends_on  = [
    aws_ram_principal_association.network_primary_security_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count       = length(module.vpc_primary[0].public_subnets)

  resource_id = module.vpc_primary[0].public_subnets[count.index]
  key         = keys(merge(local.public_subnet_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}${count.index}" }))[count.index]
  value       = merge(local.public_subnet_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}${count.index}" })[keys(merge(local.public_subnet_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}${count.index}" }))[count.index]]
}

resource "aws_ec2_tag" "subnets_pvt_security_tooling" {
  provider    = aws.security_tooling
  depends_on  = [
    aws_ram_principal_association.network_primary_security_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count       = length(module.vpc_primary[0].private_subnets)

  resource_id = module.vpc_primary[0].private_subnets[count.index]
  key         = keys(merge(local.private_subnet_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}${count.index}" }))[count.index]
  value       = merge(local.private_subnet_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}${count.index}" })[keys(merge(local.private_subnet_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}${count.index}" }))[count.index]]
}

resource "aws_ec2_tag" "vpc_log_archive_failover" {
  provider    = aws.log_archive_failover
  depends_on = [
    aws_ram_principal_association.network_failover_security_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count = var.vpc_failover_enabled ? length(merge(local.vpc_tags_failover, local.default_tags, { "Name" = "${local.resource_name_stub_failover}-${local.this_slug}-vpc" })) : 0

  resource_id = module.vpc_failover[0].vpc_id
  key         = keys(merge(local.vpc_tags_failover, local.default_tags, { "Name" = "${local.resource_name_stub_failover}-${local.this_slug}-vpc" }))[count.index]
  value       = merge(local.vpc_tags_failover, local.default_tags, { "Name" = "${local.resource_name_stub_failover}-${local.this_slug}-vpc" })[keys(merge(local.vpc_tags_failover, local.default_tags, { "Name" = "${local.resource_name_stub_failover}-${local.this_slug}-vpc" }))[count.index]]
}

resource "aws_ec2_tag" "subnets_pub_log_archive_failover" {
  provider    = aws.log_archive_failover
  depends_on = [
    aws_ram_principal_association.network_failover_security_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count       = var.vpc_failover_enabled ? length(module.vpc_failover[0].public_subnets) : 0

  resource_id = module.vpc_failover[0].public_subnets[count.index]
  key         = keys(merge(local.public_subnet_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}${count.index}" }))[count.index]
  value       = merge(local.public_subnet_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}${count.index}" })[keys(merge(local.public_subnet_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}${count.index}" }))[count.index]]
}

resource "aws_ec2_tag" "subnets_pvt_log_archive_failover" {
  provider    = aws.log_archive_failover
  depends_on = [
    aws_ram_principal_association.network_failover_security_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count       = var.vpc_failover_enabled ? length(module.vpc_failover[0].private_subnets) : 0

  resource_id = module.vpc_failover[0].private_subnets[count.index]
  key         = keys(merge(local.private_subnet_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}${count.index}" }))[count.index]
  value       = merge(local.private_subnet_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}${count.index}" })[keys(merge(local.private_subnet_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}${count.index}" }))[count.index]]
}

resource "aws_ec2_tag" "vpc_security_tooling_failover" {
  provider    = aws.security_tooling_failover
  depends_on = [
    aws_ram_principal_association.network_failover_security_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count = var.vpc_failover_enabled ? length(merge(local.vpc_tags_failover, local.default_tags, { "Name" = "${local.resource_name_stub_failover}-${local.this_slug}-vpc" })) : 0

  resource_id = module.vpc_failover[0].vpc_id
  key         = keys(merge(local.vpc_tags_failover, local.default_tags, { "Name" = "${local.resource_name_stub_failover}-${local.this_slug}-vpc" }))[count.index]
  value       = merge(local.vpc_tags_failover, local.default_tags, { "Name" = "${local.resource_name_stub_failover}-${local.this_slug}-vpc" })[keys(merge(local.vpc_tags_failover, local.default_tags, { "Name" = "${local.resource_name_stub_failover}-${local.this_slug}-vpc" }))[count.index]]
}

resource "aws_ec2_tag" "subnets_pub_security_tooling_failover" {
  provider    = aws.security_tooling_failover
  depends_on = [
    aws_ram_principal_association.network_failover_security_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count       = var.vpc_failover_enabled ? length(module.vpc_failover[0].public_subnets) : 0

  resource_id = module.vpc_failover[0].public_subnets[count.index]
  key         = keys(merge(local.public_subnet_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}${count.index}" }))[count.index]
  value       = merge(local.public_subnet_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}${count.index}" })[keys(merge(local.public_subnet_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}${count.index}" }))[count.index]]
}

resource "aws_ec2_tag" "subnets_pvt_security_tooling_failover" {
  provider    = aws.security_tooling_failover
  depends_on = [
    aws_ram_principal_association.network_failover_security_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count       = var.vpc_failover_enabled ? length(module.vpc_failover[0].private_subnets) : 0

  resource_id = module.vpc_failover[0].private_subnets[count.index]
  key         = keys(merge(local.private_subnet_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}${count.index}" }))[count.index]
  value       = merge(local.private_subnet_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}${count.index}" })[keys(merge(local.private_subnet_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}${count.index}" }))[count.index]]
}