output "database_name" {
  description = "Tên Glue processed database"
  value       = aws_glue_catalog_database.processed.name
}

output "customers_table_name" {
  description = "Tên processed customers table"
  value       = aws_glue_catalog_table.customers.name
}

output "customers_location" {
  description = "S3 location của processed customers"

  value = "s3://${var.data_lake_bucket_name}/processed/customers/"
}