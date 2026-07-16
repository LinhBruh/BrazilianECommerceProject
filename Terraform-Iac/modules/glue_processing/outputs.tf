output "job_name" {
  description = "Tên Glue processing job"
  value       = aws_glue_job.process_customers.name
}

output "role_arn" {
  description = "IAM role của Glue Job"
  value       = aws_iam_role.glue_job.arn
}

output "script_location" {
  description = "Vị trí Glue script"

  value = "s3://${var.data_lake_bucket_name}/${aws_s3_object.customers_scripts.key}"
}