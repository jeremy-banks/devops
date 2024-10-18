this_slug = "sdlc-prd"

deployment_environment = "prd"

vpc_enabled = true
vpc_cidr_primary_substitute = "10.51.0.0/16"
vpc_cidr_failover_substitute = "10.52.0.0/16"

r53_zone_enabled = true
r53_zones = [
  "outerplanes.net",
  "outerplanes.org",
]