# resource "aws_ec2_tag" "vpc_log_archive" {
#   provider    = aws.log_archive
#   depends_on  = [
#     aws_ram_principal_association.network_primary_security_ou,
#     aws_ram_resource_association.vpc_primary_subnets,
#   ]
#   count       = length(merge(local.vpc_tags_primary, local.default_tags, { "Name" = "${local.vpc_name_primary}" }))

#   resource_id = module.vpc_primary[0].vpc_id
#   key         = keys(merge(local.vpc_tags_primary, local.default_tags, { "Name" = "${local.vpc_name_primary}" }))[count.index]
#   value       = merge(local.vpc_tags_primary, local.default_tags, { "Name" = "${local.vpc_name_primary}" })[keys(merge(local.vpc_tags_primary, local.default_tags, { "Name" = "${local.vpc_name_primary}" }))[count.index]]
# }

# resource "aws_ec2_tag" "subnets_pub0_log_archive" {
#   provider    = aws.log_archive
#   depends_on  = [
#     aws_ram_principal_association.network_primary_security_ou,
#     aws_ram_resource_association.vpc_primary_subnets,
#   ]
#   count       = length(merge(local.subnet_pub_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}0}" }))

#   resource_id = module.vpc_primary[0].public_subnets[0]
#   key         = keys(merge(local.subnet_pub_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}0" }))[count.index]
#   value       = merge(local.subnet_pub_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}0" })[keys(merge(local.subnet_pub_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}${count.index}" }))[count.index]]
# }

# resource "aws_ec2_tag" "subnets_pub1_log_archive" {
#   provider    = aws.log_archive
#   depends_on  = [
#     aws_ram_principal_association.network_primary_security_ou,
#     aws_ram_resource_association.vpc_primary_subnets,
#   ]
#   count       = length(merge(local.subnet_pub_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}1}" }))

#   resource_id = module.vpc_primary[0].public_subnets[1]
#   key         = keys(merge(local.subnet_pub_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}1" }))[count.index]
#   value       = merge(local.subnet_pub_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}1" })[keys(merge(local.subnet_pub_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}${count.index}" }))[count.index]]
# }

# resource "aws_ec2_tag" "subnets_pub2_log_archive" {
#   provider    = aws.log_archive
#   depends_on  = [
#     aws_ram_principal_association.network_primary_security_ou,
#     aws_ram_resource_association.vpc_primary_subnets,
#   ]
#   count       = var.vpc_five9s_enabled ? length(merge(local.subnet_pub_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}2" })) : 0

#   resource_id = module.vpc_primary[0].public_subnets[2]
#   key         = keys(merge(local.subnet_pub_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}2" }))[count.index]
#   value       = merge(local.subnet_pub_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}2" })[keys(merge(local.subnet_pub_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_primary}${count.index}" }))[count.index]]
# }

# resource "aws_ec2_tag" "subnets_pvt0_log_archive" {
#   provider    = aws.log_archive
#   depends_on  = [
#     aws_ram_principal_association.network_primary_security_ou,
#     aws_ram_resource_association.vpc_primary_subnets,
#   ]
#   count       = length(merge(local.subnet_pvt_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}0" }))

#   resource_id = module.vpc_primary[0].private_subnets[0]
#   key         = keys(merge(local.subnet_pvt_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}0" }))[count.index]
#   value       = merge(local.subnet_pvt_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}0" })[keys(merge(local.subnet_pvt_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}${count.index}" }))[count.index]]
# }

# resource "aws_ec2_tag" "subnets_pvt1_log_archive" {
#   provider    = aws.log_archive
#   depends_on  = [
#     aws_ram_principal_association.network_primary_security_ou,
#     aws_ram_resource_association.vpc_primary_subnets,
#   ]
#   count       = length(merge(local.subnet_pvt_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}1" }))

#   resource_id = module.vpc_primary[0].private_subnets[1]
#   key         = keys(merge(local.subnet_pvt_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}1" }))[count.index]
#   value       = merge(local.subnet_pvt_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}1" })[keys(merge(local.subnet_pvt_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}${count.index}" }))[count.index]]
# }

# resource "aws_ec2_tag" "subnets_pvt2_log_archive" {
#   provider    = aws.log_archive
#   depends_on  = [
#     aws_ram_principal_association.network_primary_security_ou,
#     aws_ram_resource_association.vpc_primary_subnets,
#   ]
#   count       = var.vpc_five9s_enabled ? length(merge(local.subnet_pvt_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}2" })) : 0

#   resource_id = module.vpc_primary[0].private_subnets[2]
#   key         = keys(merge(local.subnet_pvt_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}2" }))[count.index]
#   value       = merge(local.subnet_pvt_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}2" })[keys(merge(local.subnet_pvt_tags_primary, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_primary}${count.index}" }))[count.index]]
# }

# resource "aws_ec2_tag" "vpc_log_archive_failover" {
#   provider    = aws.log_archive_failover
#   depends_on  = [
#     aws_ram_principal_association.network_failover_infrastructure_ou,
#     aws_ram_resource_association.vpc_failover_subnets,
#   ]
#   count       = local.create_failover_region ? length(merge(local.vpc_tags_failover, local.default_tags, { "Name" = "${local.vpc_name_failover}" })) : 0

#   resource_id = module.vpc_failover[0].vpc_id
#   key         = keys(merge(local.vpc_tags_failover, local.default_tags, { "Name" = "${local.vpc_name_failover}" }))[count.index]
#   value       = merge(local.vpc_tags_failover, local.default_tags, { "Name" = "${local.vpc_name_failover}" })[keys(merge(local.vpc_tags_failover, local.default_tags, { "Name" = "${local.vpc_name_failover}" }))[count.index]]
# }

# resource "aws_ec2_tag" "subnets_pub0_log_archive_failover" {
#   provider    = aws.log_archive_failover
#   depends_on  = [
#     aws_ram_principal_association.network_failover_security_ou,
#     aws_ram_resource_association.vpc_failover_subnets,
#   ]
#   count       = local.create_failover_region ? length(merge(local.subnet_pub_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}0}" })) : 0

#   resource_id = module.vpc_failover[0].public_subnets[0]
#   key         = keys(merge(local.subnet_pub_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}0" }))[count.index]
#   value       = merge(local.subnet_pub_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}0" })[keys(merge(local.subnet_pub_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}${count.index}" }))[count.index]]
# }

# resource "aws_ec2_tag" "subnets_pub1_log_archive_failover" {
#   provider    = aws.log_archive_failover
#   depends_on  = [
#     aws_ram_principal_association.network_failover_security_ou,
#     aws_ram_resource_association.vpc_failover_subnets,
#   ]
#   count       = local.create_failover_region ? length(merge(local.subnet_pub_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}1}" })) : 0

#   resource_id = module.vpc_failover[0].public_subnets[1]
#   key         = keys(merge(local.subnet_pub_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}1" }))[count.index]
#   value       = merge(local.subnet_pub_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}1" })[keys(merge(local.subnet_pub_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}${count.index}" }))[count.index]]
# }

# resource "aws_ec2_tag" "subnets_pub2_log_archive_failover" {
#   provider    = aws.log_archive_failover
#   depends_on  = [
#     aws_ram_principal_association.network_failover_security_ou,
#     aws_ram_resource_association.vpc_failover_subnets,
#   ]
#   count       = local.create_failover_region && var.vpc_five9s_enabled ? length(merge(local.subnet_pub_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}2" })) : 0

#   resource_id = module.vpc_failover[0].public_subnets[2]
#   key         = keys(merge(local.subnet_pub_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}2" }))[count.index]
#   value       = merge(local.subnet_pub_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}2" })[keys(merge(local.subnet_pub_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pub_name_failover}${count.index}" }))[count.index]]
# }

# resource "aws_ec2_tag" "subnets_pvt0_log_archive_failover" {
#   provider    = aws.log_archive_failover
#   depends_on  = [
#     aws_ram_principal_association.network_failover_security_ou,
#     aws_ram_resource_association.vpc_failover_subnets,
#   ]
#   count       = local.create_failover_region ? length(merge(local.subnet_pvt_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}0" })) : 0

#   resource_id = module.vpc_failover[0].private_subnets[0]
#   key         = keys(merge(local.subnet_pvt_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}0" }))[count.index]
#   value       = merge(local.subnet_pvt_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}0" })[keys(merge(local.subnet_pvt_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}${count.index}" }))[count.index]]
# }

# resource "aws_ec2_tag" "subnets_pvt1_log_archive_failover" {
#   provider    = aws.log_archive_failover
#   depends_on  = [
#     aws_ram_principal_association.network_failover_security_ou,
#     aws_ram_resource_association.vpc_failover_subnets,
#   ]
#   count       = local.create_failover_region ? length(merge(local.subnet_pvt_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}1" })) : 0

#   resource_id = module.vpc_failover[0].private_subnets[1]
#   key         = keys(merge(local.subnet_pvt_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}1" }))[count.index]
#   value       = merge(local.subnet_pvt_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}1" })[keys(merge(local.subnet_pvt_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}${count.index}" }))[count.index]]
# }

# resource "aws_ec2_tag" "subnets_pvt2_log_archive_failover" {
#   provider    = aws.log_archive_failover
#   depends_on  = [
#     aws_ram_principal_association.network_failover_security_ou,
#     aws_ram_resource_association.vpc_failover_subnets,
#   ]
#   count       = local.create_failover_region && var.vpc_five9s_enabled ? length(merge(local.subnet_pvt_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}2" })) : 0

#   resource_id = module.vpc_failover[0].private_subnets[2]
#   key         = keys(merge(local.subnet_pvt_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}2" }))[count.index]
#   value       = merge(local.subnet_pvt_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}2" })[keys(merge(local.subnet_pvt_tags_failover, local.default_tags, { "Name" = "${local.vpc_subnet_pvt_name_failover}${count.index}" }))[count.index]]
# }