resource "aws_organizations_organizational_unit" "security" {
  name      = "security"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "security_prd" {
  name      = "prd"
  parent_id = aws_organizations_organizational_unit.security.id
}

# resource "aws_organizations_account" "log_archive_prd" {
#   name  = "log-archive-prd"
#   email = "${var.org_owner_email_prefix}-log-archive-prd@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.security_prd.id
#   role_name                  = var.account_role_name
# }

# resource "aws_organizations_account" "security_tooling_prd" {
#   name  = "security-tooling-prd"
#   email = "${var.org_owner_email_prefix}-security-tooling-prd@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.security_prd.id
#   role_name                  = var.account_role_name
# }

resource "aws_organizations_organizational_unit" "security_stg" {
  name      = "stg"
  parent_id = aws_organizations_organizational_unit.security.id
}
