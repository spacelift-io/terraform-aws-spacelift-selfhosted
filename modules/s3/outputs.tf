output "deliveries_bucket_arn" {
  value       = aws_s3_bucket.deliveries.arn
  description = "ARN of the S3 bucket used for storing deliveries."
}

output "deliveries_bucket_name" {
  value       = aws_s3_bucket.deliveries.id
  description = "ID of the S3 bucket used for storing deliveries."
}

output "large_queue_messages_arn" {
  value       = aws_s3_bucket.large_queue_messages.arn
  description = "ARN of the S3 bucket used for storing large queue messages."
}

output "large_queue_messages_bucket_name" {
  value       = aws_s3_bucket.large_queue_messages.id
  description = "ID of the S3 bucket used for storing large queue messages."
}

output "metadata_bucket_arn" {
  value       = aws_s3_bucket.metadata.arn
  description = "ARN of the S3 bucket used for storing metadata."
}

output "metadata_bucket_name" {
  value       = aws_s3_bucket.metadata.id
  description = "ID of the S3 bucket used for storing metadata."
}

output "modules_bucket_arn" {
  value       = aws_s3_bucket.modules.arn
  description = "ARN of the S3 bucket used for storing modules."
}

output "modules_bucket_name" {
  value       = aws_s3_bucket.modules.id
  description = "ID of the S3 bucket used for storing modules."
}

output "policy_inputs_bucket_arn" {
  value       = aws_s3_bucket.policy_inputs.arn
  description = "ARN of the S3 bucket used for storing policy inputs."
}

output "policy_inputs_bucket_name" {
  value       = aws_s3_bucket.policy_inputs.id
  description = "ID of the S3 bucket used for storing policy inputs."
}

output "run_logs_bucket_arn" {
  value       = aws_s3_bucket.run_logs.arn
  description = "ARN of the S3 bucket used for storing run logs."
}

output "run_logs_bucket_name" {
  value       = aws_s3_bucket.run_logs.id
  description = "ID of the S3 bucket used for storing run logs."
}

output "states_bucket_arn" {
  value       = aws_s3_bucket.states.arn
  description = "ARN of the S3 bucket used for storing states."
}

output "states_bucket_name" {
  value       = aws_s3_bucket.states.id
  description = "ID of the S3 bucket used for storing states."
}

output "uploads_bucket_arn" {
  value       = aws_s3_bucket.uploads.arn
  description = "ARN of the S3 bucket used for storing uploads."
}

output "uploads_bucket_name" {
  value       = aws_s3_bucket.uploads.id
  description = "ID of the S3 bucket used for storing uploads."
}

output "user_uploaded_workspaces_arn" {
  value       = aws_s3_bucket.user_uploads.arn
  description = "ARN of the S3 bucket used for storing user uploaded workspaces."
}

output "user_uploaded_workspaces_bucket_name" {
  value       = aws_s3_bucket.user_uploads.id
  description = "ID of the S3 bucket used for storing user uploaded workspaces."
}

output "workspace_bucket_arn" {
  value       = aws_s3_bucket.workspaces.arn
  description = "ARN of the S3 bucket used for storing workspaces."
}

output "workspace_bucket_name" {
  value       = aws_s3_bucket.workspaces.id
  description = "ID of the S3 bucket used for storing workspaces."
}
