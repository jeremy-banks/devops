output "org" {
  value = data.aws_caller_identity.current.account_id
}

output "security_tooling" {
  value = aws_organizations_account.security_tooling.id
}

output "log_archive" {
  value = aws_organizations_account.log_archive.id
}

output "network" {
  value = aws_organizations_account.network.id
}

output "shared_services" {
  value = aws_organizations_account.shared_services.id
}