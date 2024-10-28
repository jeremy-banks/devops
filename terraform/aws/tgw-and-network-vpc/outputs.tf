output "vpc_primary" {
  value = {
    subnets_private = module.vpc_primary.*.private_subnets
    subnets_public = module.vpc_primary.*.public_subnets
    vpc_id = module.vpc_primary.*.vpc_id
  }
}

output "vpc_nat_public_ips_primary" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value = aws_eip.vpc_nat_primary.*.public_ip
}

output "vpc_security_group_id_main_primary" {
  description = "The ID of the security group created for general use"
  value       = module.vpc_main_sg_primary.*.security_group_id
}

output "vpc_failover" {
  value = {
    subnets_private = module.vpc_failover.*.private_subnets
    subnets_public = module.vpc_failover.*.public_subnets
    vpc_id = module.vpc_failover.*.vpc_id
 }
}

output "vpc_nat_public_ips_failover" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value = aws_eip.vpc_nat_failover.*.public_ip
}

output "vpc_security_group_id_main_failover" {
  description = "The ID of the security group created for general use"
  value       = module.vpc_main_sg_failover.*.security_group_id
}