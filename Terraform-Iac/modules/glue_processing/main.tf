data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "glue_job" {
  name = "${var.project_name}-${var.environment}-glue-job-role"

  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "glue_job" {
  statement {
    sid = "ListDataLake"
    effect = "Allow"
    actions = ["s3:ListBucket"]

    resources = [var.data_lake_bucket_arn]

    condition {
      test = "StringLike"
      variable = "s3:prefix"

      values = [
        "raw/customers/*",
        "processed/customers/*",
        "scripts/glue/*"
      ]
    }
  }

  statement {
    sid = "ReadRawAndScripts"
    effect = "Allow"
    actions = [
        "s3:GetObject",
        "s3:GetObjectVersion"
    ]
    
    resources = [
        "${var.data_lake_bucket_arn}/raw/customers/*",
        "${var.data_lake_bucket_arn}/scripts/glue/*"
    ]
  }

  statement {
    sid = "WriteProcessed"
    effect = "Allow"
    actions = [
        "s3:DeleteObject",
        "s3:PutObject",
        "s3:AbortMultipartUpload"
    ]

    resources = ["${var.data_lake_bucket_arn}/processed/customers/*"]
  }

  statement {
    sid    = "WriteCloudWatchLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "glue_job" {
  name = "${var.project_name}-${var.environment}-glue-job-policy"

  policy = data.aws_iam_policy_document.glue_job.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "glue_job" {
  role = aws_iam_role.glue_job.name
  policy_arn = aws_iam_policy.glue_job.arn
}

resource "aws_s3_object" "customers_scripts" {
  bucket = var.data_lake_bucket_name
  key = "scripts/glue/processed_customers.py"

  source = "${path.module}/scripts/process_customers.py"
  etag = filemd5("${path.module}/scripts/process_customers.py")

  server_side_encryption = "AES256"

  tags = var.tags
}

resource "aws_glue_job" "process_customers" {
  name = "${var.project_name}-${var.environment}-process-customers"
  role_arn = aws_iam_role.glue_job.arn

  glue_version = "5.1"
  worker_type = "G.1X"
  number_of_workers = 2

  max_retries = 0
  timeout = 10

  execution_property {
    max_concurrent_runs = 1
  }

  command {
    name = "glueetl"
    python_version = "3"
    script_location = "s3://${var.data_lake_bucket_name}/${aws_s3_object.customers_scripts.key}"
  }

  default_arguments = {
    "--BUCKET_NAME"                     = var.data_lake_bucket_name
    "--job-language"                    = "python"
    "--job-bookmark-option"             = "job-bookmark-disable"
    "--enable-metrics"                  = "true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"    = "true"
  }

  tags = var.tags
}



