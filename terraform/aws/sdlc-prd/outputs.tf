output "acm_arn_primary" {
  description = "The ARN of the certificate"
  value = module.acm_wildcard_cert_primary.acm_certificate_arn
}

output "kms_arn_primary" {
  description = "The ARN of the key"
  value       = module.kms_primary.key_arn
}

output "vpc_primary" {
  value = {
    subnets_private = {
      0 = module.vpc_primary.private_subnets[0]
      1 = module.vpc_primary.private_subnets[1]
      2 = module.vpc_primary.private_subnets[2]
    }
    subnets_public = {
      0 = module.vpc_primary.public_subnets[0]
      1 = module.vpc_primary.public_subnets[1]
      2 = module.vpc_primary.public_subnets[2]
    }
    vpc_id = module.vpc_primary.vpc_id
  }
}

output "vpc_nat_public_ips_primary" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value = aws_eip.vpc_nat_primary[*].public_ip
}

output "vpc_security_group_id_main_primary" {
  description = "The ID of the security group created for general use"
  value       = module.vpc_main_sg_primary.security_group_id
}

output "acm_arn_failover" {
  description = "The ARN of the certificate"
  value = module.acm_wildcard_cert_failover.acm_certificate_arn
}

output "kms_arn_failover" {
  description = "The ARN of the key"
  value       = module.kms_failover.key_arn
}

output "vpc_failover" {
  value = {
    subnets_private = {
      0 = module.vpc_failover.private_subnets[0]
      1 = module.vpc_failover.private_subnets[1]
      2 = module.vpc_failover.private_subnets[2]
    }
    subnets_public = {
      0 = module.vpc_failover.public_subnets[0]
      1 = module.vpc_failover.public_subnets[1]
      2 = module.vpc_failover.public_subnets[2]
    }
    vpc_id = module.vpc_failover.vpc_id
 }
}

output "vpc_nat_public_ips_failover" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value = aws_eip.vpc_nat_failover[*].public_ip
}

output "vpc_security_group_id_main_failover" {
  description = "The ID of the security group created for general use"
  value       = module.vpc_main_sg_failover.security_group_id
}