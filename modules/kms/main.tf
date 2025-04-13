resource "aws_kms_key" "kms_master_key" {
  description         = "Spacelift KMS key for AWS resource encryption"
  multi_region        = var.master_key_multi_regional
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
  description         = "Spacelift KMS key used for in-app encryption"
  multi_region        = var.encryption_key_multi_regional
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

resource "aws_kms_key" "jwt_key" {
  description              = "Spacelift KMS key used to sign and verify JWTs"
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "RSA_4096"
  multi_region             = var.jwt_key_multi_regional

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
