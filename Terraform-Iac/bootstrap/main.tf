locals {
  state_bucket_name = "${var.project_name}-${var.aws_account_id}-${var.aws_region}-${var.environment}-tfstate"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = local.state_bucket_name
  force_destroy = false # Khong duoc xoa khi van con state file

  lifecycle {
    prevent_destroy = true #Khong duoc destroy khi terraform destroy
  }
}


resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true #Khong cho them public ACL moi
  block_public_policy     = true # Bo qua public ACL da ton tai
  ignore_public_acls      = true # Khong cho them bucket policy public
  restrict_public_buckets = true # Han che truy cap neu co policy tinh public
}

resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

#Tao mot IAM policy deny action vao s3 neu truy cap khong dung HTTPS -> data source de terraform tao JSON policy vaof IAM
data "aws_iam_policy_document" "terraform_state" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    } # ap dung cho tat ca

    actions = ["s3:*"] # hanh dong voi s3 resource

    resources = [
      aws_s3_bucket.terraform_state.arn,       #voi bucket
      "${aws_s3_bucket.terraform_state.arn}/*" #voi cac object ben trong bucket
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.terraform_state.json

  depends_on = [aws_s3_bucket_public_access_block.terraform_state] #Yeu cau terraform tao block public access truoc khi them iam policy
}