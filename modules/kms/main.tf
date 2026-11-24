resource "aws_kms_key" "deploy_kms_master_key" {
  count = var.create_deploy_keys ? 1 : 0

  description         = "Spacelift KMS key for AWS resource encryption"
  multi_region        = var.master_key_multi_regional
  enable_key_rotation = true

  # Official documentation specifies that this is where the KMS key is
  # managed, not the only region it works in. It can still be an MRK.
  region = var.region

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

resource "aws_kms_key" "deploy_encryption_key" {
  count = var.create_deploy_keys ? 1 : 0

  description         = "Spacelift KMS key used for in-app encryption"
  multi_region        = var.encryption_key_multi_regional
  enable_key_rotation = true

  # Official documentation specifies that this is where the KMS key is
  # managed, not the only region it works in. It can still be an MRK.
  region = var.region

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

resource "aws_kms_key" "deploy_jwt_key" {
  count = var.create_deploy_keys ? 1 : 0

  description              = "Spacelift KMS key used to sign and verify JWTs"
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "RSA_4096"
  multi_region             = var.jwt_key_multi_regional

  # Official documentation specifies that this is where the KMS key is
  # managed, not the only region it works in. It can still be an MRK.
  region = var.region

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

resource "aws_kms_key" "flows_kms_key" {
  count = var.create_flows_key ? 1 : 0

  description         = "Spacelift Flows KMS key for encrypting the Flows bucket"
  enable_key_rotation = true
  region              = var.region

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

moved {
  from = aws_kms_key.kms_master_key
  to   = aws_kms_key.deploy_kms_master_key[0]
}

moved {
  from = aws_kms_key.encryption_key
  to   = aws_kms_key.deploy_encryption_key[0]
}

moved {
  from = aws_kms_key.jwt_key
  to   = aws_kms_key.deploy_jwt_key[0]
}
