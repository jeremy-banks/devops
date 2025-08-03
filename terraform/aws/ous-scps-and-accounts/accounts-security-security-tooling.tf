# resource "aws_organizations_account" "security_tooling_prd" {
#   name  = "security-tooling-prd"
#   email = local.account_owner_email.security_tooling_prd

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.security_prd.id
#   role_name                  = var.account_role_name
# }