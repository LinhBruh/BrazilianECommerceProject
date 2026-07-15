output "work_group_name" {
  description = "ten workgroup athena"
  value = aws_athena_workgroup.this.name
}

output "work_group_arn" {
  description = "ARN cua workgroup athena"
  value = aws_athena_workgroup.this.arn
}
output "result_location" {
  description = "Noi luu ket qua truy van cua athena"
  value = "s3://${var.data_lake_bucket_name}/athena-results/"
}