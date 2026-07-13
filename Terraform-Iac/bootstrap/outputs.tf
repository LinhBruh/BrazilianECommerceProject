output "state_bucket_name" {
  description = "Ten bucket S3 luu Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_arn" {
  description = "ARN cua S3 bucket"
  value       = aws_s3_bucket.terraform_state.arn
}