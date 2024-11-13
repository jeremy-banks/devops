output "org" {
  value = data.aws_caller_identity.this.account_id
}

output "identity" {
  value = aws_organizations_account.identity.id
}

output "log_archive" {
  value = aws_organizations_account.log_archive.id
}

output "network" {
  value = aws_organizations_account.network.id
}

output "security_tooling" {
  value = aws_organizations_account.security_tooling.id
}