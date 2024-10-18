# output "iam_role_eks_cluster" {
#   description = "The ID of the VPC"
#   value       = module.iam_role_eks_cluster.iam_role_arn
# }

# output "iam_role_eks_cluster_services" {
#   description = "The ID of the VPC"
#   value       = module.iam_role_eks_cluster_services_node.iam_role_arn
# }

# output "iam_role_eks_worker_node" {
#   description = "The ID of the VPC"
#   value       = module.iam_role_eks_worker_node.iam_role_arn
# }

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
  value       = module.vpc_main_sg_primary.security_group_id
}

# output "primary_acm_arn" {
#   description = "The ARN of the certificate"
#   value       = module.acm_wildcard_cert_primary[*].acm_certificate_arn
# }

output "primary_kms_arn" {
  description = "The ARN of the key"
  value       = module.kms_primary.key_arn
}

output "failover_vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_failover.vpc_id
}

output "failover_public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc_failover.public_subnets
}

output "failover_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_failover.private_subnets
}

output "failover_nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value = aws_eip.vpc_nat_failover[*].public_ip
}

output "failover_security_group_id_main" {
  description = "The ID of the security group created for general use"
  value       = module.vpc_main_sg_failover.security_group_id
}

# output "failover_acm_arn" {
#   description = "The ARN of the certificate"
#   value       = module.acm_wildcard_cert_failover[*].acm_certificate_arn.thi
# }

output "failover_kms_arn" {
  description = "The ARN of the key"
  value       = module.kms_failover.key_arn
}
