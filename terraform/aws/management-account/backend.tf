# terraform {
#   backend "s3" {
#     profile      = "superadmin"
#     region       = "TFSTATEBACKENDREGION"
#     bucket       = "TFSTATEBACKENDS3BUCKETNAME"
#     key          = "superadmin/management-account"
#     use_lockfile = true
#     insecure     = false
#     encrypt      = true
#     kms_key_id   = "TFSTATEBACKENDKMSARN"
#   }
# }