this_slug = "sdlc-stg"

deployment_environment = "stg"

vpc_cidr_substitute != "" = true
vpc_cidr_substitute = "10.53.0.0/16"
vpc_cidr_substitute_failover = "10.54.0.0/16"

r53_zones = [
  "outerplanes.net",
  "outerplanes.org",
]