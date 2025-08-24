module "iam_assumable_roles_sdlc_prd" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role"
  version   = "6.2.0"
  providers = { aws = aws.sdlc_prd }

  for_each = {
    "${var.admin_role_name}" = {
      trusted_arns    = ["arn:aws:iam::${data.aws_organizations_organization.this.master_account_id}:root"]
      trusted_type    = "AWS"
      trusted_actions = ["sts:AssumeRole"]
      policies = {
        AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
    }
  }

  name            = each.key
  use_name_prefix = false

  max_session_duration = 43200

  trust_policy_permissions = {
    TrustRoleAndServiceToAssume = {
      principals = [
        {
          type        = each.value.trusted_type
          identifiers = each.value.trusted_arns
        }
      ]
      actions = each.value.trusted_actions
    }
  }

  policies = each.value.policies
}

module "iam_assumable_roles_sdlc_stg" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role"
  version   = "6.2.0"
  providers = { aws = aws.sdlc_stg }

  for_each = {
    "${var.admin_role_name}" = {
      trusted_arns    = ["arn:aws:iam::${data.aws_organizations_organization.this.master_account_id}:root"]
      trusted_type    = "AWS"
      trusted_actions = ["sts:AssumeRole"]
      policies = {
        AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
    }
  }

  name            = each.key
  use_name_prefix = false

  max_session_duration = 43200

  trust_policy_permissions = {
    TrustRoleAndServiceToAssume = {
      principals = [
        {
          type        = each.value.trusted_type
          identifiers = each.value.trusted_arns
        }
      ]
      actions = each.value.trusted_actions
    }
  }

  policies = each.value.policies
}

module "iam_assumable_roles_sdlc_tst" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role"
  version   = "6.2.0"
  providers = { aws = aws.sdlc_tst }

  for_each = {
    "${var.admin_role_name}" = {
      trusted_arns    = ["arn:aws:iam::${data.aws_organizations_organization.this.master_account_id}:root"]
      trusted_type    = "AWS"
      trusted_actions = ["sts:AssumeRole"]
      policies = {
        AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
    }
  }

  name            = each.key
  use_name_prefix = false

  max_session_duration = 43200

  trust_policy_permissions = {
    TrustRoleAndServiceToAssume = {
      principals = [
        {
          type        = each.value.trusted_type
          identifiers = each.value.trusted_arns
        }
      ]
      actions = each.value.trusted_actions
    }
  }

  policies = each.value.policies
}

module "iam_assumable_roles_sdlc_dev" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role"
  version   = "6.2.0"
  providers = { aws = aws.sdlc_dev }

  for_each = {
    "${var.admin_role_name}" = {
      trusted_arns    = ["arn:aws:iam::${data.aws_organizations_organization.this.master_account_id}:root"]
      trusted_type    = "AWS"
      trusted_actions = ["sts:AssumeRole"]
      policies = {
        AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
    }
  }

  name            = each.key
  use_name_prefix = false

  max_session_duration = 43200

  trust_policy_permissions = {
    TrustRoleAndServiceToAssume = {
      principals = [
        {
          type        = each.value.trusted_type
          identifiers = each.value.trusted_arns
        }
      ]
      actions = each.value.trusted_actions
    }
  }

  policies = each.value.policies
}