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

module "glue_catalog" {
  source                = "../../modules/glue_catalog"
  database_name         = "be_olist_dev_raw"
  data_lake_bucket_name = module.data_lake.bucket_name

  description = "Raw zone metadata for brazillian ecommerce dataset"
  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
    DataZone    = "raw"
  }
}

module "athena" {
  source                = "../../modules/athena"
  work_group_name       = "be-olist-dev"
  data_lake_bucket_name = module.data_lake.bucket_name

  bytes_scanned_cutoff_per_querry = 104857600

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
    Component   = "query"
  }
}

module "glue_processing" {
  source = "../../modules/glue_processing"

  project_name          = var.project_name
  environment           = var.environment
  data_lake_bucket_arn  = module.data_lake.bucket_arn
  data_lake_bucket_name = module.data_lake.bucket_name

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
    DataZone    = "processed"
  }
}

module "processed_catalog" {
  source = "../../modules/processed_catalog"

  database_name = "be_olist_dev_processed"
  data_lake_bucket_name = module.data_lake.bucket_name

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
    DataZone    = "processed"
  }
}