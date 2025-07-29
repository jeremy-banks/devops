# output "vpc_id_inbound_primary" {
#   value = module.vpc_central_ingress_primary.*.vpc_id
# }

# output "vpc_public_subnets_ids_inbound_primary" {
#   value = {
#     for idx, subnet_id in flatten(module.vpc_central_ingress_primary.*.public_subnets) :
#     "${local.number_words[idx + 1]}" => subnet_id
#   }
# }

output "vpc_nat_public_ips_outbound_primary" {
  value = { public_ips = aws_eip.vpc_central_egress_primary_nat.*.public_ip }
}

# output "vpc_id_inbound_failover" {
#   value = module.vpc_central_ingress_failover.*.vpc_id
# }

# output "vpc_public_subnets_ids_inbound_failover" {
#   value = {
#     for idx, subnet_id in flatten(module.vpc_central_ingress_failover.*.public_subnets) :
#     "${local.number_words[idx + 1]}" => subnet_id
#   }
# }

output "vpc_nat_public_ips_outbound_failover" {
  value = { public_ips = aws_eip.vpc_central_egress_failover_nat.*.public_ip }
}