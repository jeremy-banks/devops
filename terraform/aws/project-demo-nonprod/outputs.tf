output "vpc_primary" {
  value       = module.vpc_primary.vpc_id
}

output "vpc_subnets_primary_public" {
  value       = module.vpc_primary.public_subnets
}

output "vpc_subnets_primary_private" {
  value       = module.vpc_primary.private_subnets
}

output "vpc_failover" {
  value       = module.vpc_primary.vpc_id
}

output "vpc_subnets_failover_public" {
  value       = module.vpc_failover.public_subnets
}

output "vpc_subnets_failover_private" {
  value       = module.vpc_failover.private_subnets
}
