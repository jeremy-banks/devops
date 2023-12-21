output "primary_vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_primary.vpc_id
}

output "primary_public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc_primary.public_subnets
}

output "primary_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_primary.private_subnets
}

output "primary_nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value = aws_eip.vpc_nat_primary[*].public_ip
}

output "primary_security_group_id_main" {
  description = "The ID of the security group created for general use"
  value       = module.vpc_primary_main_sg.security_group_id
}

output "primary_security_group_id_alb" {
  description = "The ID of the security group created for application load balancers"
  value       = module.vpc_primary_alb_sg.security_group_id
}

# output "vpc_endpoints" {
#   description = "Array containing the full resource object and attributes for all endpoints created"
#   value       = module.vpc_endpoints.endpoints
# }

output "primary_acm_arn" {
  description = "The ARN of the certificate"
  value       = module.acm_wildcard_cert.acm_certificate_arn
}

output "primary_kms_arn" {
  description = "The ARN of the key"
  value       = module.kms_primary.key_arn
}

# output "vpc_failover" {
#   value       = module.vpc_primary.vpc_id
# }

# output "vpc_subnets_failover_public" {
#   value       = module.vpc_failover.public_subnets
# }

# output "vpc_subnets_failover_private" {
#   value       = module.vpc_failover.private_subnets
# }
