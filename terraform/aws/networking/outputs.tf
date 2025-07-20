output "vpc_inbound_failover" {
  value = {
    subnets_public = module.vpc_inbound_failover.*.public_subnets
    vpc_id = module.vpc_inbound_failover.*.vpc_id
  }
}

output "vpc_inbound_primary" {
  value = {
    subnets_public = module.vpc_inbound_primary.*.public_subnets
    vpc_id = module.vpc_inbound_primary.vpc_id
  }
}

output "vpc_outbound_failover" {
  value = {
    public_ips = aws_eip.vpc_outbound_failover_nat.*.public_ip
  }
}

output "vpc_outbound_primary" {
  value = {    public_ips = aws_eip.vpc_outbound_primary_nat.*.public_ip
  }
}