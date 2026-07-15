resource "aws_athena_workgroup" "this" {
  name = var.work_group_name
  description = "Athena workgroup cho Brazillian Ecommerce dataset"
  state = "ENABLED"

  configuration {
    enforce_workgroup_configuration = true #bat user phai dung workgroup config, khong doi output location,...
    publish_cloudwatch_metrics_enabled = true #gui metric sang clouwatch
    bytes_scanned_cutoff_per_query = var.bytes_scanned_cutoff_per_querry #gioi han query

    result_configuration {
      output_location = "s3://${var.data_lake_bucket_name}/athena-results/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  tags = var.tags
}