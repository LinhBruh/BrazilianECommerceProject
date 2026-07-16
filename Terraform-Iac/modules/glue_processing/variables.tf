variable "project_name" {
  description = "Ten project"
  type = string
}

variable "environment" {
  description = "moi truong trien khai"
  type = string
}

variable "data_lake_bucket_name" {
  description = "data lake name"
  type = string
}

variable "data_lake_bucket_arn" {
  description = "data lake arn"
  type = string
}

variable "tags" {
  description = "Tag"
  type = map(string)
  default = {}
}