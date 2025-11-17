# Async Jobs Queue Outputs
output "async_jobs_queue_url" {
  description = "The URL of the async jobs queue"
  value       = aws_sqs_queue.async_jobs.url
}

output "async_jobs_queue_arn" {
  description = "The ARN of the async jobs queue"
  value       = aws_sqs_queue.async_jobs.arn
}

output "async_jobs_queue_name" {
  description = "The name of the async jobs queue"
  value       = aws_sqs_queue.async_jobs.name
}

# Async Jobs FIFO Queue Outputs
output "async_jobs_fifo_queue_url" {
  description = "The URL of the async jobs FIFO queue"
  value       = aws_sqs_queue.async_jobs_fifo.url
}

output "async_jobs_fifo_queue_arn" {
  description = "The ARN of the async jobs FIFO queue"
  value       = aws_sqs_queue.async_jobs_fifo.arn
}

output "async_jobs_fifo_queue_name" {
  description = "The name of the async jobs FIFO queue"
  value       = aws_sqs_queue.async_jobs_fifo.name
}

# Events Inbox Queue Outputs
output "events_inbox_queue_url" {
  description = "The URL of the events inbox queue"
  value       = aws_sqs_queue.events_inbox.url
}

output "events_inbox_queue_arn" {
  description = "The ARN of the events inbox queue"
  value       = aws_sqs_queue.events_inbox.arn
}

# Cronjobs Queue Outputs
output "cronjobs_queue_url" {
  description = "The URL of the cronjobs queue"
  value       = aws_sqs_queue.cronjobs.url
}

output "cronjobs_queue_arn" {
  description = "The ARN of the cronjobs queue"
  value       = aws_sqs_queue.cronjobs.arn
}

output "cronjobs_queue_name" {
  description = "The name of the cronjobs queue"
  value       = aws_sqs_queue.cronjobs.name
}

# Deadletter Queue Outputs
output "deadletter_queue_url" {
  description = "The URL of the dlq queue"
  value       = aws_sqs_queue.deadletter.url
}

output "deadletter_queue_name" {
  description = "The name of the dlq queue"
  value       = aws_sqs_queue.deadletter.name
}

output "deadletter_queue_arn" {
  description = "The ARN of the dlq queue"
  value       = aws_sqs_queue.deadletter.arn
}

# Deadletter FIFO Queue Outputs
output "deadletter_fifo_queue_url" {
  description = "The URL of the dlq fifo queue"
  value       = aws_sqs_queue.deadletter_fifo.url
}

output "deadletter_fifo_queue_name" {
  description = "The name of the dlq fifo queue"
  value       = aws_sqs_queue.deadletter_fifo.name
}

output "deadletter_fifo_queue_arn" {
  description = "The ARN of the dlq fifo queue"
  value       = aws_sqs_queue.deadletter_fifo.arn
}

# Webhooks Queue Outputs
output "webhooks_queue_url" {
  description = "The URL of the VCS webhooks queue"
  value       = aws_sqs_queue.webhooks.url
}

output "webhooks_queue_arn" {
  description = "The ARN of the VCS webhooks queue"
  value       = aws_sqs_queue.webhooks.arn
}

output "webhooks_queue_name" {
  description = "The name of the VCS webhooks queue"
  value       = aws_sqs_queue.webhooks.name
}

# IoT Queue Outputs
output "iot_queue_url" {
  description = "The URL of the IoT queue"
  value       = aws_sqs_queue.iot.url
}

output "iot_queue_arn" {
  description = "The ARN of the IoT queue"
  value       = aws_sqs_queue.iot.arn
}

output "iot_queue_name" {
  description = "The name of the IoT queue"
  value       = aws_sqs_queue.iot.name
}
