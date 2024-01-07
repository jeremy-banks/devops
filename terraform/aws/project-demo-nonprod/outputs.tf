output "vpc_id_primary" {
  description = "The ID of the VPC"
  value       = module.vpc_primary.vpc_id
}

output "public_subnets_primary" {
  description = "List of IDs of public subnets"
  value       = module.vpc_primary.public_subnets
}

output "private_subnets_primary" {
  description = "List of IDs of private subnets"
  value       = module.vpc_primary.private_subnets
}

output "nat_public_ips_primary" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value = aws_eip.vpc_nat_primary[*].public_ip
}

output "security_group_id_main_primary" {
  description = "The ID of the security group created for general use"
  value       = module.vpc_main_sg_primary.security_group_id
}

output "security_group_id_alb_primary" {
  description = "The ID of the security group created for application load balancers"
  value       = module.vpc_alb_sg_primary.security_group_id
}

output "acm_arn_primary" {
  description = "The ARN of the certificate"
  value       = module.acm_wildcard_cert_primary.acm_certificate_arn
}

output "kms_arn_primary" {
  description = "The ARN of the key"
  value       = module.kms_primary.key_arn
}
