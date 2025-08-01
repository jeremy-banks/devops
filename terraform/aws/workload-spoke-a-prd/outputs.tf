output "kms_arn_primary" { value = module.kms_primary.*.key_arn }

output "s3_bucket_name_primary" { value = module.s3_primary.s3_bucket_id }

output "vpc_id_primary" { value = module.vpc_primary.*.vpc_id }

output "vpc_public_subnets_ids_primary" { value = [for idx, subnet_id in flatten(module.vpc_primary.*.public_subnets) : "${local.number_words[idx + 1]}: ${subnet_id}"] }

output "vpc_private_subnets_ids_primary" { value = [for idx, subnet_id in flatten(module.vpc_primary.*.private_subnets) : "${local.number_words[idx + 1]}: ${subnet_id}"] }

# output "vpc_security_group_id_primary" { value = module.sg_main_primary.*.security_group_id }

output "kms_arn_failover" { value = module.kms_failover.*.key_arn }

output "s3_bucket_name_failover" { value = module.s3_failover.s3_bucket_id }

output "vpc_id_failover" { value = module.vpc_failover.*.vpc_id }

output "vpc_public_subnets_ids_failover" { value = [for idx, subnet_id in flatten(module.vpc_failover.*.public_subnets) : "${local.number_words[idx + 1]}: ${subnet_id}"] }

output "vpc_private_subnets_ids_failover" { value = [for idx, subnet_id in flatten(module.vpc_failover.*.private_subnets) : "${local.number_words[idx + 1]}: ${subnet_id}"] }

# output "vpc_security_group_id_failover" { value = module.sg_main_failover.*.security_group_id }