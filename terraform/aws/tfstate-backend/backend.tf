terraform {
  backend "s3" {
    profile         = "superadmin"
    insecure        = false
    region          = "us-west-2"
    bucket          = "scc-blu-w12-usw2-tfstate-storage-blob-569d758c"
    key             = "superadmin/tfstate-backend"
    encrypt         = true
    kms_key_id      = "arn:aws:kms:us-west-2:600627360992:key/mrk-e42ea270137a4b6e9cea326d5435e5c2"
    dynamodb_table  = "scc-blu-w12-usw2-tfstate"
  }
}