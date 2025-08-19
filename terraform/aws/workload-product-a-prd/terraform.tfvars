this_slug = "product-a"

environment = "prd"

# create_failover_region_networking = false

azs_number_used_networking = 2

# create_failover_region = false

create_vpc_public_subnets = true

azs_number_used = 2

vpc_cidr_primary  = "10.20.0.0/16"
vpc_cidr_failover = "10.21.0.0/16"

r53_zones_parents = [
  "bar.com",
  "foo.com",
  "foobar.com"
]
r53_zones_delegates_stg = [
  "bar.com",
  "foo.com",
  "foobar.com"
]
r53_zones_delegates_tst = []
r53_zones_delegates_dev = []