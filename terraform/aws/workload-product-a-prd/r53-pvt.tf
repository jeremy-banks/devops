# resource "aws_route53_zone" "pvt_primary" {
#   provider = aws.this

#   count = length(var.r53_zones_parents)

#   name = "pvt.${var.r53_zones_parents[count.index]}"

#   vpc {
#     vpc_id = module.vpc_primary.vpc_id
#   }
# }

# resource "aws_route53_zone" "pvt_failover" {
#   provider = aws.this_failover

#   count = var.create_failover_region ? length(var.r53_zones_parents) : 0

#   name = "pvt.${var.r53_zones_parents[count.index]}"

#   vpc {
#     vpc_id = module.vpc_failover[0].vpc_id
#   }
# }