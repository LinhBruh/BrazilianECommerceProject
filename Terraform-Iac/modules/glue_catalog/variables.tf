variable "database_name" {
  description = "ten database cho glue catalog"
  type = string

  validation {
    condition     = can(regex("^[a-z0-9_]+$", var.database_name))
    error_message = "Tên Glue Database chỉ nên chứa chữ thường, số và dấu gạch dưới."
  }
}

variable "description" {
  description = "Mo ta glue catalog"
  type = string
  default = "Olist brazillian ecommerce datalog"
}

variable "tags" {
  description = "Tag ap dung cho Glue database"
  type = map(string)
  default = {}
}

variable "data_lake_bucket_name" {
  description = "Ten s3 bucket chua du lieu"
  type = string
}