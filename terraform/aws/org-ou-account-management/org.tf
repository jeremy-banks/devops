resource "aws_ram_sharing_with_organization" "enable" {
  depends_on = [
    # aws_organizations_organization.org,
    aws_organizations_account.identity,
    aws_organizations_account.log_archive,
    aws_organizations_account.network,
    aws_organizations_account.sdlc_prd,
    aws_organizations_account.security_tooling,
  ]
}

data "aws_caller_identity" "this" {}