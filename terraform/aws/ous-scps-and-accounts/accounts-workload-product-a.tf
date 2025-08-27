resource "aws_organizations_account" "workload_product_a_prd" {
  name  = "${var.account_name_slug.workload_product_a}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.workload_product_a}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workloads_product_a_prd.id
  role_name                  = var.account_role_name
}

resource "aws_organizations_account" "workload_product_a_stg" {
  name  = "${var.account_name_slug.workload_product_a}-stg"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.workload_product_a}-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workloads_product_a_stg.id
  role_name                  = var.account_role_name
}

resource "aws_organizations_account" "workload_product_a_tst" {
  name  = "${var.account_name_slug.workload_product_a}-tst"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.workload_product_a}-tst@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workloads_product_a_tst.id
  role_name                  = var.account_role_name
}

resource "aws_organizations_account" "workload_product_a_dev" {
  name  = "${var.account_name_slug.workload_product_a}-dev"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.workload_product_a}-dev@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workloads_product_a_dev.id
  role_name                  = var.account_role_name
}