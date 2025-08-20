# resource "aws_route53_zone" "zones_public_prd" {
#   provider = aws.this

#   count = length(var.r53_zones_parents)

#   name = var.r53_zones_parents[count.index]
# }

# resource "aws_route53_zone" "zones_public_stg" {
#   provider = aws.workload_product_a_stg

#   count = length(var.r53_zones_delegates_stg)

#   name = "stg.${var.r53_zones_delegates_stg[count.index]}"
# }

# resource "aws_route53_record" "stg_ns_in_parent" {
#   provider = aws.this

#   for_each = toset(var.r53_zones_delegates_stg)

#   zone_id = aws_route53_zone.zones_public_prd[
#     index(var.r53_zones_parents, each.key)
#   ].zone_id

#   name = "stg.${each.key}"
#   type = "NS"
#   ttl  = 300
#   records = aws_route53_zone.zones_public_stg[
#     index(var.r53_zones_delegates_stg, each.key)
#   ].name_servers
# }

# resource "aws_route53_zone" "zones_public_tst" {
#   provider = aws.workload_product_a_tst

#   count = length(var.r53_zones_delegates_tst)

#   name = "tst.${var.r53_zones_delegates_tst[count.index]}"
# }

# resource "aws_route53_record" "tst_ns_in_parent" {
#   provider = aws.this

#   for_each = toset(var.r53_zones_delegates_tst)

#   zone_id = aws_route53_zone.zones_public_prd[
#     index(var.r53_zones_parents, each.key)
#   ].zone_id

#   name = "tst.${each.key}"
#   type = "NS"
#   ttl  = 300
#   records = aws_route53_zone.zones_public_tst[
#     index(var.r53_zones_delegates_tst, each.key)
#   ].name_servers
# }

# resource "aws_route53_zone" "zones_public_dev" {
#   provider = aws.workload_product_a_dev

#   count = length(var.r53_zones_delegates_dev)

#   name = "dev.${var.r53_zones_delegates_dev[count.index]}"
# }

# resource "aws_route53_record" "dev_ns_in_parent" {
#   provider = aws.this

#   for_each = toset(var.r53_zones_delegates_dev)

#   zone_id = aws_route53_zone.zones_public_prd[
#     index(var.r53_zones_parents, each.key)
#   ].zone_id

#   name = "dev.${each.key}"
#   type = "NS"
#   ttl  = 300
#   records = aws_route53_zone.zones_public_dev[
#     index(var.r53_zones_delegates_dev, each.key)
#   ].name_servers
# }