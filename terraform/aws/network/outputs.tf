output "vpc_nat_public_ips_central_egress_primary" { value = aws_eip.vpc_central_egress_primary_nat.*.public_ip }

output "vpc_nat_public_ips_central_egress_failover" { value = aws_eip.vpc_central_egress_failover_nat.*.public_ip }