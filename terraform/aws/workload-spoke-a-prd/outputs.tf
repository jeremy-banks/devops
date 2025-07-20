output "kms_arn_primary" {
  description = "The ARN of the key"
  value       = module.kms_primary.key_arn
}

output "vpc_primary" {
  value = {
    subnets_private = module.vpc_primary.private_subnets
    vpc_id          = module.vpc_primary.vpc_id
  }
}

output "kms_arn_failover" {
  description = "The ARN of the key"
  value       = module.kms_failover.key_arn
}

output "vpc_failover" {
  value = {
    subnets_private = module.vpc_failover.*.private_subnets
    vpc_id          = module.vpc_failover.*.vpc_id
  }
}