resource "aws_organizations_policy" "ai_services_opt_out" {
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_ai-opt-out_syntax.html
  name        = "ai-services-opt-out"
  description = "Opt out of all AI services for all accounts in the organization"
  type        = "AISERVICES_OPT_OUT_POLICY"
  content = jsonencode(
    {
      "services" : {
        "@@operators_allowed_for_child_policies" : ["@@none"],
        "default" : {
          "@@operators_allowed_for_child_policies" : ["@@none"],
          "opt_out_policy" : {
            "@@operators_allowed_for_child_policies" : ["@@none"],
            "@@assign" : "optOut"
          }
        }
      }
    }
  )
}

resource "aws_organizations_policy_attachment" "ai_services_opt_out_attachment_org" {
  policy_id = aws_organizations_policy.ai_services_opt_out.id
  target_id = data.aws_organizations_organization.this.roots[0].id
}