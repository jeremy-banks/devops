this_slug = "sdlc-stg"

deployment_environment = "stg"

vpc_enabled = true
# vpc_network_ram_enable = true
vpc_cidr_primary_substitute = "10.53.0.0/16"
vpc_cidr_failover_substitute = "10.54.0.0/16"

r53_zones = [
  "outerplanes.net",
  "outerplanes.org",
]