locals {
  bucket_names = {
    "binaries" : var.bucket_configuration != null ? var.bucket_configuration.binaries.name : "spacelift-binaries-${var.suffix}",
    "deliveries" : var.bucket_configuration != null ? var.bucket_configuration.deliveries.name : "spacelift-deliveries-${var.suffix}",
    "large-queue" : var.bucket_configuration != null ? var.bucket_configuration.large_queue.name : "spacelift-large-queue-messages-${var.suffix}",
    "metadata" : var.bucket_configuration != null ? var.bucket_configuration.metadata.name : "spacelift-metadata-${var.suffix}",
    "modules" : var.bucket_configuration != null ? var.bucket_configuration.modules.name : "spacelift-modules-${var.suffix}",
    "policy" : var.bucket_configuration != null ? var.bucket_configuration.policy.name : "spacelift-policy-inputs-${var.suffix}",
    "run-logs" : var.bucket_configuration != null ? var.bucket_configuration.run_logs.name : "spacelift-run-logs-${var.suffix}",
    "states" : var.bucket_configuration != null ? var.bucket_configuration.states.name : "spacelift-states-${var.suffix}",
    "uploads" : var.bucket_configuration != null ? var.bucket_configuration.uploads.name : "spacelift-uploads-${var.suffix}",
    "user-uploads" : var.bucket_configuration != null ? var.bucket_configuration.user_uploads.name : "spacelift-user-uploaded-workspaces-${var.suffix}",
    "workspace" : var.bucket_configuration != null ? var.bucket_configuration.workspace.name : "spacelift-workspace-${var.suffix}",
  }

  bucket_expirations = {
    "deliveries" : var.bucket_configuration != null ? var.bucket_configuration.deliveries.expiration_days : 1,
    "large-queue" : var.bucket_configuration != null ? var.bucket_configuration.large_queue.expiration_days : 2,
    "metadata" : var.bucket_configuration != null ? var.bucket_configuration.metadata.expiration_days : 2,
    "policy" : var.bucket_configuration != null ? var.bucket_configuration.policy.expiration_days : 120,
    "run-logs" : var.bucket_configuration != null ? var.bucket_configuration.run_logs.expiration_days : 60,
    "uploads" : var.bucket_configuration != null ? var.bucket_configuration.uploads.expiration_days : 1,
    "user-uploads" : var.bucket_configuration != null ? var.bucket_configuration.user_uploads.expiration_days : 1,
    "workspace" : var.bucket_configuration != null ? var.bucket_configuration.workspace.expiration_days : 90,
  }
}

# Let's not enable server-side encryption for this bucket, it isn't necessary.
resource "aws_s3_bucket" "binaries" {
  bucket        = local.bucket_names["binaries"]
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_versioning" "binaries" {
  bucket = aws_s3_bucket.binaries.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "deliveries" {
  bucket        = local.bucket_names["deliveries"]
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "deliveries" {
  bucket = aws_s3_bucket.deliveries.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "deliveries" {
  bucket = aws_s3_bucket.deliveries.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "deliveries" {
  bucket = aws_s3_bucket.deliveries.id

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }

    filter {
      prefix = ""
    }

    expiration {
      days = local.bucket_expirations["deliveries"]
    }
  }
}

resource "aws_s3_bucket" "large_queue_messages" {
  bucket        = local.bucket_names["large-queue"]
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "large_queue_messages" {
  bucket = aws_s3_bucket.large_queue_messages.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "large_queue_messages" {
  bucket = aws_s3_bucket.large_queue_messages.id

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }

    filter {
      prefix = ""
    }

    expiration {
      days = local.bucket_expirations["large-queue"]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "large_queue_messages" {
  bucket = aws_s3_bucket.large_queue_messages.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "metadata" {
  bucket        = local.bucket_names["metadata"]
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "metadata" {
  bucket = aws_s3_bucket.metadata.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "metadata" {
  bucket = aws_s3_bucket.metadata.id

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }

    filter {
      prefix = ""
    }

    expiration {
      days = local.bucket_expirations["metadata"]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "metadata" {
  bucket = aws_s3_bucket.metadata.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "modules" {
  bucket        = local.bucket_names["modules"]
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "modules" {
  bucket = aws_s3_bucket.modules.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "modules" {
  bucket = aws_s3_bucket.modules.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "modules" {
  bucket = aws_s3_bucket.modules.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "policy_inputs" {
  bucket        = local.bucket_names["policy"]
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_lifecycle_configuration" "policy_inputs" {
  bucket = aws_s3_bucket.policy_inputs.id

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }

    filter {
      prefix = ""
    }

    expiration {
      days = local.bucket_expirations["policy"]
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "policy_inputs" {
  bucket = aws_s3_bucket.policy_inputs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "policy_inputs" {
  bucket = aws_s3_bucket.policy_inputs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "policy_inputs" {
  bucket = aws_s3_bucket.policy_inputs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "run_logs" {
  bucket        = local.bucket_names["run-logs"]
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "run_logs" {
  bucket = aws_s3_bucket.run_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "run_logs" {
  bucket = aws_s3_bucket.run_logs.id

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }

    filter {
      prefix = ""
    }

    expiration {
      days = local.bucket_expirations["run-logs"]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "run_logs" {
  bucket = aws_s3_bucket.run_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "run_logs" {
  bucket = aws_s3_bucket.run_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "states" {
  bucket        = local.bucket_names["states"]
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "states" {
  bucket = aws_s3_bucket.states.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "states" {
  bucket = aws_s3_bucket.states.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "states" {
  bucket = aws_s3_bucket.states.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "uploads" {
  bucket        = local.bucket_names["uploads"]
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_versioning" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "uploads" {
  count  = length(var.cors_hostname) > 0 ? 1 : 0
  bucket = aws_s3_bucket.uploads.id

  cors_rule {
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["${var.cors_hostname}"]
    allowed_headers = ["*"]
  }
}

resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }

    filter {
      prefix = ""
    }

    expiration {
      days = local.bucket_expirations["uploads"]
    }
  }
}

resource "aws_s3_bucket" "user_uploads" {
  bucket        = local.bucket_names["user-uploads"]
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "user_uploads" {
  bucket = aws_s3_bucket.user_uploads.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_versioning" "user_uploads" {
  bucket = aws_s3_bucket.user_uploads.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "user_uploads" {
  bucket = aws_s3_bucket.user_uploads.id

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }

    filter {
      prefix = ""
    }

    expiration {
      days = local.bucket_expirations["user-uploads"]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "user_uploads" {
  bucket = aws_s3_bucket.user_uploads.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "workspaces" {
  bucket        = local.bucket_names["workspace"]
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "workspaces" {
  bucket = aws_s3_bucket.workspaces.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_versioning" "workspaces" {
  bucket = aws_s3_bucket.workspaces.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "workspaces" {
  bucket = aws_s3_bucket.workspaces.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "workspaces" {
  bucket = aws_s3_bucket.workspaces.id

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }
    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    filter {
      prefix = ""
    }

    expiration {
      days = local.bucket_expirations["workspace"]
    }
  }
}
