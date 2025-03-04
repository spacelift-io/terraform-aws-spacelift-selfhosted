resource "aws_kms_key" "kms_master_key" {
  description         = "Spacelift KMS key for AWS resource encryption"
  multi_region        = true
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "Enable IAM User Permissions"
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Principal = {
          AWS = "arn:${data.aws_partition.current.partition}:iam::${var.account_id}:root"
        }
      }
    ]
  })
}

resource "aws_kms_key" "encryption_key" {
  description         = "Spacelift KMS key for in-app encryption"
  multi_region        = true
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "Enable IAM User Permissions"
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Principal = {
          AWS = "arn:${data.aws_partition.current.partition}:iam::${var.account_id}:root"
        }
      }
    ]
  })
}

data "aws_partition" "current" {}
