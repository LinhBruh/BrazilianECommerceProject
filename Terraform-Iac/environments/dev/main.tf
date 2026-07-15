data "aws_caller_identity" "current" {} # Lay ra account id dang dung hien tai
locals {
  data_lake_bucket_name = "${var.project_name}-${var.environment}-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
}

module "data_lake" {
  source = "../../modules/datalake"

  bucket_name = local.data_lake_bucket_name
  environment = var.environment

  noncurrent_version_retention_day = 7
  athena_result_retention_day      = 30

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}