output "iam_user_automation_iam_access_key_id" {
  description = "automation access key id"
  value       = module.iam_user_automation.iam_access_key_id
  sensitive   = true
}

output "iam_user_automation_iam_access_key_secret" {
  description = "automation access key secret"
  value       = module.iam_user_automation.iam_access_key_secret
  sensitive   = true
}