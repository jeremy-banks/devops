resource "aws_organizations_organizational_unit" "customer_42069" {
  name      = "customer_42069"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "customer_42069_nonprod" {
  name      = "nonprod"
  parent_id = aws_organizations_organizational_unit.customer_42069.id
}

resource "aws_organizations_organizational_unit" "customer_42069_prod" {
  name      = "prod"
  parent_id = aws_organizations_organizational_unit.customer_42069.id
}

resource "aws_organizations_account" "customer_42069_prd" {
  name  = "${local.resource_name_stub}-customer-42069-prd"
  email = "${var.org_owner_email_prefix}-customer-42069-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.customer_42069_prod.id
  role_name                   = var.assumable_role_name.superadmin
}

output "customer_42069_prd" {
  value = aws_organizations_account.customer_42069_prd.id
}

resource "aws_organizations_account" "customer_42069_stg" {
  name  = "${local.resource_name_stub}-customer-42069-stg"
  email = "${var.org_owner_email_prefix}-customer-42069-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.customer_42069_nonprod.id
  role_name                   = var.assumable_role_name.superadmin
}

output "customer_42069_stg" {
  value = aws_organizations_account.customer_42069_stg.id
}

resource "aws_organizations_account" "customer_42069_tst" {
  name  = "${local.resource_name_stub}-customer-42069-tst"
  email = "${var.org_owner_email_prefix}-customer-42069-tst@${var.org_owner_email_domain_tld}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.customer_42069_nonprod.id
  role_name                   = var.assumable_role_name.superadmin
}

output "customer_42069_tst" {
  value = aws_organizations_account.customer_42069_tst.id
}

resource "aws_organizations_account" "customer_42069_dev" {
  name  = "${local.resource_name_stub}-customer-42069-dev"
  email = "${var.org_owner_email_prefix}-customer-42069-dev@${var.org_owner_email_domain_tld}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.customer_42069_nonprod.id
  role_name                   = var.assumable_role_name.superadmin
}

output "customer_42069_dev" {
  value = aws_organizations_account.customer_42069_dev.id
}