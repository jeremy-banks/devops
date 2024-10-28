this_slug = "sdlc-prd"

deployment_environment = "prd"

# vpc_cidr_substitute != "" = true
vpc_cidr_substitute = "10.51.0.0/16"
vpc_cidr_substitute_failover = "10.52.0.0/16"


r53_zones = [
  # "outerplanes.com",
  "outerplanes.net",
  "outerplanes.org",
]