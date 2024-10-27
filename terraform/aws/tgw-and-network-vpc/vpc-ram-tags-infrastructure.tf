resource "aws_ec2_tag" "vpc_identity" {
  provider    = aws.identity
  depends_on  = [
    aws_ram_principal_association.network_primary_infrastructure_ou,
    aws_ram_resource_association.vpc_primary_subnets,
  ]
  count = length(merge(local.vpc_tags_primary, local.default_tags))

  resource_id = module.vpc_primary[0].vpc_id
  key         = keys(merge(local.vpc_tags_primary, local.default_tags))[count.index]
  value       = merge(local.vpc_tags_primary, local.default_tags)[keys(merge(local.vpc_tags_primary, local.default_tags))[count.index]]
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
  value       = "${local.resource_name_stub_primary}-${local.this_slug}-vpc-pub-${count.index}"
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
  value       = "${local.resource_name_stub_primary}-${local.this_slug}-vpc-pvt-${count.index}"
}

resource "aws_ec2_tag" "vpc_identity_failover" {
  provider    = aws.identity_failover
  depends_on = [
    aws_ram_principal_association.network_failover_infrastructure_ou,
    aws_ram_resource_association.vpc_failover_subnets,
  ]
  count = var.vpc_failover_enabled ? length(merge(local.vpc_tags_primary, local.default_tags)) : 0

  resource_id = module.vpc_failover[0].vpc_id
  key         = keys(merge(local.vpc_tags_failover, local.default_tags))[count.index]
  value       = merge(local.vpc_tags_failover, local.default_tags)[keys(merge(local.vpc_tags_failover, local.default_tags))[count.index]]
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
  value       = "${local.resource_name_stub_failover}-${local.this_slug}-vpc-pub-${count.index}"
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
  value       = "${local.resource_name_stub_failover}-${local.this_slug}-vpc-pvt-${count.index}"
}