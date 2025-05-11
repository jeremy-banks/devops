output "inbound_primary" {
  value = module.inbound_primary.public_ip
}

output "inspection_primary" {
  value = module.inspection_primary.private_ip
}

output "outbound_primary" {
  value = module.outbound_primary.private_ip
}

output "inbound_failover" {
  value = module.inbound_failover[0].public_ip
}

output "inspection_failover" {
  value = module.inspection_failover[0].private_ip
}

output "outbound_failover" {
  value = module.outbound_failover[0].private_ip
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