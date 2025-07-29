# output "vpc_id_central_ingress_primary" {
#   value = module.vpc_central_ingress_primary.*.vpc_id
# }

# output "vpc_public_subnets_ids_central_ingress_primary" {
#   value = {
#     for idx, subnet_id in flatten(module.vpc_central_ingress_primary.*.public_subnets) :
#     "${local.number_words[idx + 1]}" => subnet_id
#   }
# }

output "vpc_nat_public_ips_central_egress_primary" {
  value = aws_eip.vpc_central_egress_primary_nat.*.public_ip
}

# output "vpc_id_central_ingress_failover" {
#   value = module.vpc_central_ingress_failover.*.vpc_id
# }

# output "vpc_public_subnets_ids_central_ingress_failover" {
#   value = {
#     for idx, subnet_id in flatten(module.vpc_central_ingress_failover.*.public_subnets) :
#     "${local.number_words[idx + 1]}" => subnet_id
#   }
# }

output "vpc_nat_public_ips_central_egress_failover" {
  value = aws_eip.vpc_central_egress_failover_nat.*.public_ip
}