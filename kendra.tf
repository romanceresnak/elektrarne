resource "awscc_kendra_index" "kendra_index" {
  edition     = "ENTERPRISE_EDITION"
  name        = "kendra-index"
  role_arn    = awscc_iam_role.kendra_iam_role.arn
  description = "Kendra index"
}

resource "awscc_iam_role" "kendra_iam_role" {
  role_name   = "kendra_iam_role"
  assume_role_policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
      }
    ]
  })
  max_session_duration = 7200
}

resource "awscc_iam_role_policy" "kendra_iam_role_policy" {
  policy_name = "kendra_role_policy"
  role_name   = awscc_iam_role.kendra_iam_role.id

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "cloudwatch:PutMetricData"
        Resource = "*"
        Condition = {
          "StringEquals" : {
            "cloudwatch:namespace" : "AWS/Kendra"
          }
        }
      },
      {
        Effect   = "Allow"
        Action   = "logs:DescribeLogGroups"
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "kendra:BatchDeleteDocument",
        Resource = "${awscc_kendra_index.kendra_index.arn}"
      },
      {
        Effect   = "Allow"
        Action   = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/kendra/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogStreams",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/kendra/*:log-stream:*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.resources-bucket.arn,
          "${aws_s3_bucket.resources-bucket.arn}/*"
        ]
      },
    ]
  })
}

data "aws_caller_identity" "current" {}

resource "awscc_kendra_data_source" "kendra_datasource_s3" {
  index_id        = awscc_kendra_index.kendra_index.id
  name            = "kendra-datasource-s3"
  role_arn        = awscc_iam_role.kendra_iam_role.arn
  type            = "S3"

  data_source_configuration = {
    s3_configuration = {
      bucket_name = aws_s3_bucket.resources-bucket.bucket
    }
  }
}