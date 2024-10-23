module "r53_zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "4.1.0"
  providers = { aws = aws.sdlc_stg }

  create = length(var.r53_zones) > 0 ? true : false

  zones = { 
    for zone in var.r53_zones : zone => {
      domain_name = var.deployment_environment == "prd" ? zone : "${var.deployment_environment}.${zone}"
      comment     = "${zone} ${var.deployment_environment} ${var.deployment_environment == "prd" ? "public" : "private"}"

      vpc = var.deployment_environment == "prd" ? [] : [
        {
          vpc_id      = module.vpc_primary.vpc_id
          vpc_region  = var.region.primary
        },
        {
          vpc_id      = module.vpc_failover.vpc_id
          vpc_region  = var.region.failover
        }
      ]

      tags = {
        Name = "${zone} ${var.deployment_environment} ${var.deployment_environment == "prd" ? "public" : "private"}"
      }
    }
  }
}