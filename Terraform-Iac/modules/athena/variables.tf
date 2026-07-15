variable "work_group_name" {
  description = "Ten athena workgroup"
  type = string
}

variable "data_lake_bucket_name" {
  description = "Bucket de luu ket qua athena"
  type = string
}

variable "bytes_scanned_cutoff_per_querry" {
  description = "so byte toi da 1 query duoc phep quet"
  type = number
  default = 104857600

  validation {
    condition = var.bytes_scanned_cutoff_per_querry >= 104857600
    error_message = "Gioi han phai tu 10MB tro len"
  }
}
variable "tags" {
  description = "Tag ap dung cho athena"
  type = map(string)
  default = {}
}