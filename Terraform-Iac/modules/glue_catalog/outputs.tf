output "database_name" {
  description = "Ten cua Glue database"
  value = aws_glue_catalog_database.this.name
}

output "database_arn" {
  description = "ARN cua glue database"
  value = aws_glue_catalog_database.this.arn
}
output "raw_table_names" {
  description = "Danh sach cac bang glue table"
  value = {
    for table_name, table in aws_glue_catalog_table.raw_tables:
      table_name => table.name
  }
}

output "customer_table_name" {
  description = "Ten bang customer trong glue"
  value = aws_glue_catalog_table.raw_tables["customers"].name
}