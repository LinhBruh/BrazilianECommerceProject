variable "project_name" {
  description = "ten project"
  type        = string
  default     = "be-olist"
}

variable "environment" {
  description = "environment deploy"
  type        = string
  default     = "dev"

  validation {
    condition     = var.environment == "dev"
    error_message = "module nay chi danh cho moi truong dev"
  }
}

variable "aws_region" {
  description = "region deploy"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "profile aws cli"
  type        = string
  default     = "default"
}

variable "aws_account_id" {
  description = "Account id"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "AWS Account ID phải gồm 12 chữ số."
  }
}

variable "owner" {
  description = "owner project"
  type        = string
  default     = "linhbodoi"
}
