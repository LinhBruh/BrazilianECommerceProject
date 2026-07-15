variable "bucket_name" {
  description = "Data lake bucket name"
  type = string
}

variable "environment" {
    description = "environment deploy"
    type = string
}

variable "tags" {
  description = "tags ap dung cho resource"
  type = map(string)
  default = {}
}

variable "noncurrent_version_retention_day" {
  description = "so ngay ap dung cac phien ban object cu"
  type = number
  default = 7

  validation {
    condition = var.noncurrent_version_retention_day >=1
    error_message = "Thoi gian cho phien ban cu phai tu 1 ngay tro len"
  }
}

variable "athena_result_retention_day" {
    description = "so ngay du ket qua cua athena"
    type = number
    default = 30

    validation {
        condition = var.athena_result_retention_day >=1
        error_message = "Thoi gian luu ket qua Athena phai tu 1 ngay tro len"
  }
}

