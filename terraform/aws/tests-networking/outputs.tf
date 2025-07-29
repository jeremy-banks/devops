output "central_ingress_primary" {
  value = module.central_ingress_primary.public_ip
}

output "inspection_primary" {
  value = module.inspection_primary.private_ip
}

output "central_egress_primary" {
  value = module.central_egress_primary.private_ip
}

output "central_ingress_failover" {
  value = module.central_ingress_failover[0].public_ip
}

output "inspection_failover" {
  value = module.inspection_failover[0].private_ip
}

output "central_egress_failover" {
  value = module.central_egress_failover[0].private_ip
}

output "spoke_a_prd_primary" {
  value = module.spoke_a_prd_primary.private_ip
}

output "spoke_a_prd_failover" {
  value = module.spoke_a_prd_failover[0].private_ip
}

output "spoke_b_prd_primary" {
  value = module.spoke_b_prd_primary.private_ip
}

output "spoke_b_prd_failover" {
  value = module.spoke_b_prd_failover[0].private_ip
}