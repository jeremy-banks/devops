resource "aws_ram_sharing_with_organization" "enable" {
  depends_on = [
    # aws_organizations_account.identity_prd,
    # aws_organizations_account.log_archive_prd,
    aws_organizations_account.networking_prd,
    # aws_organizations_account.security_tooling_prd,
  ]
}