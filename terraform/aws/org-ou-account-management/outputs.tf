output "account_id_org" {
  value = data.aws_caller_identity.current.account_id
}

output "account_id_security_tooling" {
  value = aws_organizations_account.security_tooling.id
}

output "account_id_log_archive" {
  value = aws_organizations_account.log_archive.id
}

output "account_id_network" {
  value = aws_organizations_account.network.id
}

output "account_id_shared_services" {
  value = aws_organizations_account.shared_services.id
}
