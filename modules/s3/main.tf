locals {
  bucket_names = {
    binaries          = coalesce(try(var.bucket_configuration.binaries.name, null), "spacelift-binaries-${var.suffix}")
    deliveries        = coalesce(try(var.bucket_configuration.deliveries.name, null), "spacelift-deliveries-${var.suffix}")
    large-queue       = coalesce(try(var.bucket_configuration.large_queue.name, null), "spacelift-large-queue-messages-${var.suffix}")
    metadata          = coalesce(try(var.bucket_configuration.metadata.name, null), "spacelift-metadata-${var.suffix}")
    modules           = coalesce(try(var.bucket_configuration.modules.name, null), "spacelift-modules-${var.suffix}")
    policy            = coalesce(try(var.bucket_configuration.policy.name, null), "spacelift-policy-inputs-${var.suffix}")
    run-logs          = coalesce(try(var.bucket_configuration.run_logs.name, null), "spacelift-run-logs-${var.suffix}")
    run-observability = coalesce(try(var.bucket_configuration.run_observability.name, null), "spacelift-run-observability-${var.suffix}")
    states            = coalesce(try(var.bucket_configuration.states.name, null), "spacelift-states-${var.suffix}")
    uploads           = coalesce(try(var.bucket_configuration.uploads.name, null), "spacelift-uploads-${var.suffix}")
    user-uploads      = coalesce(try(var.bucket_configuration.user_uploads.name, null), "spacelift-user-uploaded-workspaces-${var.suffix}")
    workspace         = coalesce(try(var.bucket_configuration.workspace.name, null), "spacelift-workspace-${var.suffix}")
  }

  bucket_expirations = {
    deliveries        = coalesce(try(var.bucket_configuration.deliveries.expiration_days, null), 1)
    large-queue       = coalesce(try(var.bucket_configuration.large_queue.expiration_days, null), 2)
    metadata          = coalesce(try(var.bucket_configuration.metadata.expiration_days, null), 2)
    policy            = coalesce(try(var.bucket_configuration.policy.expiration_days, null), 120)
    run-logs          = coalesce(try(var.bucket_configuration.run_logs.expiration_days, null), 60)
    run-observability = coalesce(try(var.bucket_configuration.run_observability.expiration_days, null), 60)
    uploads           = coalesce(try(var.bucket_configuration.uploads.expiration_days, null), 1)
    user-uploads      = coalesce(try(var.bucket_configuration.user_uploads.expiration_days, null), 1)
    workspace         = coalesce(try(var.bucket_configuration.workspace.expiration_days, null), 90)
  }
}

# Let's not enable server-side encryption for this bucket, it isn't necessary.
resource "aws_s3_bucket" "binaries" {
  bucket        = local.bucket_names["binaries"]
  force_destroy = !var.retain_on_destroy

  region = var.region
}

resource "aws_s3_bucket_versioning" "binaries" {
  bucket = aws_s3_bucket.binaries.id
  versioning_configuration {
    status = "Enabled"
  }

  region = var.region
}

resource "aws_s3_bucket" "deliveries" {
  bucket        = local.bucket_names["deliveries"]
  force_destroy = !var.retain_on_destroy
  region        = var.region
}

resource "aws_s3_bucket_server_side_encryption_configuration" "deliveries" {
  bucket = aws_s3_bucket.deliveries.id
  region = var.region

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "deliveries" {
  count  = var.enable_public_access_block_on_s3 == true ? 1 : 0
  bucket = aws_s3_bucket.deliveries.id
  region = var.region

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "deliveries" {
  bucket = aws_s3_bucket.deliveries.id
  region = var.region

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
  region        = var.region
}

resource "aws_s3_bucket_server_side_encryption_configuration" "large_queue_messages" {
  bucket = aws_s3_bucket.large_queue_messages.id
  region = var.region

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "large_queue_messages" {
  bucket = aws_s3_bucket.large_queue_messages.id
  region = var.region

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
  count  = var.enable_public_access_block_on_s3 == true ? 1 : 0
  bucket = aws_s3_bucket.large_queue_messages.id
  region = var.region

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "metadata" {
  bucket        = local.bucket_names["metadata"]
  force_destroy = !var.retain_on_destroy
  region        = var.region
}

resource "aws_s3_bucket_server_side_encryption_configuration" "metadata" {
  bucket = aws_s3_bucket.metadata.id
  region = var.region

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "metadata" {
  bucket = aws_s3_bucket.metadata.id
  region = var.region

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
  count  = var.enable_public_access_block_on_s3 == true ? 1 : 0
  bucket = aws_s3_bucket.metadata.id
  region = var.region

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "modules" {
  bucket        = local.bucket_names["modules"]
  force_destroy = !var.retain_on_destroy
  region        = var.region
}

resource "aws_s3_bucket_server_side_encryption_configuration" "modules" {
  bucket = aws_s3_bucket.modules.id
  region = var.region

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "modules" {
  count  = var.enable_public_access_block_on_s3 == true ? 1 : 0
  bucket = aws_s3_bucket.modules.id
  region = var.region

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "modules" {
  bucket = aws_s3_bucket.modules.id
  region = var.region
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "policy_inputs" {
  bucket        = local.bucket_names["policy"]
  force_destroy = !var.retain_on_destroy
  region        = var.region
}

resource "aws_s3_bucket_lifecycle_configuration" "policy_inputs" {
  bucket = aws_s3_bucket.policy_inputs.id
  region = var.region

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }
    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
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
  region = var.region

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "policy_inputs" {
  count  = var.enable_public_access_block_on_s3 == true ? 1 : 0
  bucket = aws_s3_bucket.policy_inputs.id
  region = var.region

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "policy_inputs" {
  bucket = aws_s3_bucket.policy_inputs.id
  region = var.region
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "run_logs" {
  bucket        = local.bucket_names["run-logs"]
  force_destroy = !var.retain_on_destroy
  region        = var.region
}

resource "aws_s3_bucket_server_side_encryption_configuration" "run_logs" {
  bucket = aws_s3_bucket.run_logs.id
  region = var.region

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "run_logs" {
  bucket = aws_s3_bucket.run_logs.id
  region = var.region

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }
    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
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
  count  = var.enable_public_access_block_on_s3 == true ? 1 : 0
  bucket = aws_s3_bucket.run_logs.id
  region = var.region

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "run_logs" {
  bucket = aws_s3_bucket.run_logs.id
  region = var.region
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "run_observability" {
  bucket        = local.bucket_names["run-observability"]
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "run_observability" {
  bucket = aws_s3_bucket.run_observability.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "run_observability" {
  bucket = aws_s3_bucket.run_observability.id

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }
    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }

    filter {
      prefix = ""
    }

    expiration {
      days = local.bucket_expirations["run-observability"]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "run_observability" {
  count  = var.enable_public_access_block_on_s3 == true ? 1 : 0
  bucket = aws_s3_bucket.run_observability.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "run_observability" {
  bucket = aws_s3_bucket.run_observability.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "states" {
  bucket        = local.bucket_names["states"]
  region        = var.region
  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "states" {
  bucket = aws_s3_bucket.states.id
  region = var.region

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "states" {
  count  = var.enable_public_access_block_on_s3 == true ? 1 : 0
  bucket = aws_s3_bucket.states.id
  region = var.region

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "states" {
  bucket = aws_s3_bucket.states.id
  region = var.region
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "uploads" {
  bucket        = local.bucket_names["uploads"]
  force_destroy = !var.retain_on_destroy
  region        = var.region
}

resource "aws_s3_bucket_server_side_encryption_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  region = var.region

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_versioning" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  region = var.region
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "uploads" {
  count  = length(var.cors_hostname) > 0 ? 1 : 0
  bucket = aws_s3_bucket.uploads.id
  region = var.region

  cors_rule {
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["${var.cors_hostname}"]
    allowed_headers = ["*"]
  }
}

resource "aws_s3_bucket_public_access_block" "uploads" {
  count  = var.enable_public_access_block_on_s3 == true ? 1 : 0
  bucket = aws_s3_bucket.uploads.id
  region = var.region

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  region = var.region

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }
    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
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
  region        = var.region
}

resource "aws_s3_bucket_server_side_encryption_configuration" "user_uploads" {
  bucket = aws_s3_bucket.user_uploads.id
  region = var.region

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_versioning" "user_uploads" {
  bucket = aws_s3_bucket.user_uploads.id
  region = var.region
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "user_uploads" {
  bucket = aws_s3_bucket.user_uploads.id
  region = var.region

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }
    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
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
  count  = var.enable_public_access_block_on_s3 == true ? 1 : 0
  bucket = aws_s3_bucket.user_uploads.id
  region = var.region

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "workspaces" {
  bucket        = local.bucket_names["workspace"]
  force_destroy = !var.retain_on_destroy
  region        = var.region
}

resource "aws_s3_bucket_server_side_encryption_configuration" "workspaces" {
  bucket = aws_s3_bucket.workspaces.id
  region = var.region

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_versioning" "workspaces" {
  bucket = aws_s3_bucket.workspaces.id
  region = var.region
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "workspaces" {
  count  = var.enable_public_access_block_on_s3 == true ? 1 : 0
  bucket = aws_s3_bucket.workspaces.id
  region = var.region

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "workspaces" {
  bucket = aws_s3_bucket.workspaces.id
  region = var.region

  rule {
    id     = "expire-after-x-days"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }
    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }

    filter {
      prefix = ""
    }

    expiration {
      days = local.bucket_expirations["workspace"]
    }
  }
}
