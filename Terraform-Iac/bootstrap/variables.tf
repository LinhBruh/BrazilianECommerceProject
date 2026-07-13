variable "project_name" {
  description = "Project DE with CLoud"
  type        = string
  default     = "olist-de"
}

variable "environment" {
  description = "Environment deploy"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "region deploy"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = "olist-dev"
}

variable "aws_account_id" {
  description = "AWS account id"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id phải gồm đúng 12 chữ số."
  }
}