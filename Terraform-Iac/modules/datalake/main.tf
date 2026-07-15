resource "aws_s3_bucket" "data_lake" {
  bucket = var.bucket_name
  force_destroy = false #Khong duoc tu xoa data lake khi ben trong khong con du lieu

  tags = merge(
    var.tags,
    {
        Name = var.bucket_name
        Component = "data-lake"
    }
  )
}

resource "aws_s3_bucket_public_access_block" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id
  
  block_public_acls = true
    block_public_policy =  true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake" {
    bucket = aws_s3_bucket.data_lake.id

    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

resource "aws_s3_bucket_lifecycle_configuration" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  depends_on = [ aws_s3_bucket_versioning.data_lake ]

  rule {
    id = "abort-incomplete-upload"  # xoa multipart bi up do
    status = "Enabled"

    filter {
      
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  rule {
    id = "expire-noncurrent-versions"
    status = "Enabled"

    filter {
      
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_retention_day
    }
  }

  rule {
    id = "expire-athena-result"
    status = "Enabled"

    filter {
      prefix = "athena-results/"
    }

    expiration {
      days = var.athena_result_retention_day
    }
  }
}

data "aws_iam_policy_document" "data_lake" {
  statement {
    sid = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = [ "s3:*" ]

    resources = [
        aws_s3_bucket.data_lake.arn,
        "${aws_s3_bucket.data_lake.arn}/*"
    ]

    condition {
      test = "Bool"
      variable = "aws:SecureTransport"
      values = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id
  policy = data.aws_iam_policy_document.data_lake.json

  depends_on = [ aws_s3_bucket_public_access_block.data_lake ]
}

