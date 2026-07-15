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