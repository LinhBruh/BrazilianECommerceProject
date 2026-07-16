output "data_lake_bucket_name" {
  description = "ten data lake bucket name"
  value       = module.data_lake.bucket_name
}

output "data_lake_bucket_arn" {
  description = "arn cua data lake"
  value       = module.data_lake.bucket_arn
}

output "data_lake_zone" {
  description = "cac zone trong data lake"
  value       = module.data_lake.zones
}

output "glue_raw_database_name" {
  description = "Tên Glue Catalog Database của raw zone"
  value       = module.glue_catalog.database_name
}
output "glue_customer_table_name" {
  description = "ten bang customer trong glue"
  value       = module.glue_catalog.customer_table_name
}

output "athena_workgroup_name" {
  description = "ten athena workgroup"
  value       = module.athena.work_group_name
}

output "athena_result_location" {
  description = "Noi luu ket qua athena"
  value       = module.athena.result_location
}

output "glue_raw_table_names" {
  description = "Ten cac bang trong glue database"
  value       = module.glue_catalog.raw_table_names
}

output "glue_process_customers_job_name" {
  description = "Tên Glue Job xử lý customers"
  value       = module.glue_processing.job_name
}
output "glue_processed_database_name" {
  description = "Tên Glue processed database"
  value       = module.processed_catalog.database_name
}

output "glue_processed_customers_table" {
  description = "Tên processed customers table"
  value       = module.processed_catalog.customers_table_name
}