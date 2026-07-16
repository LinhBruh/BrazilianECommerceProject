variable "database_name" {
  description = "ten glue database cho processed zone"
  type = string
}

variable "data_lake_bucket_name" {
  description = "bucket chua data processed"
  type = string
}

variable "tags" {
  description = "Tag ap dung cho glue catalog"
  type = map(string)
  default = {
  }
}