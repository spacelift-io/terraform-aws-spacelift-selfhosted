resource "aws_kms_key" "kms_master_key" {
  description             = "Spacelift master KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 30

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
