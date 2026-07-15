output "bucket_name" {
  description = "Ten S3 bucket data lake"
  value = aws_s3_bucket.data_lake.id
}

output "bucket_arn" {
  description = "ARN cua s3 bucket data lake"
  value = aws_s3_bucket.data_lake.arn
}

output "zones" {
  description = "Cac logical zone trong data lake"

  value = {
    raw = "raw/"
    processed = "processed/"
    curated =  "curated/"
    quarantine = "quarantine/"
    athena_results = "athena_results/"
  }
}