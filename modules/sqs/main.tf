# Dead Letter Queues
resource "aws_sqs_queue" "deadletter" {
  name                       = "spacelift-dlq"
  kms_master_key_id          = var.kms_master_key_arn
  visibility_timeout_seconds = 300
}

resource "aws_sqs_queue" "deadletter_fifo" {
  name                       = "spacelift-dlq.fifo"
  fifo_queue                 = true
  kms_master_key_id          = var.kms_master_key_arn
  visibility_timeout_seconds = 300
}

# Async Jobs Queue
resource "aws_sqs_queue" "async_jobs" {
  name                       = "spacelift-async-jobs"
  kms_master_key_id          = var.kms_master_key_arn
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 300

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter.arn
    maxReceiveCount     = 3
  })
}

# Async Jobs FIFO Queue
resource "aws_sqs_queue" "async_jobs_fifo" {
  name                       = "spacelift-async-jobs.fifo"
  fifo_queue                 = true
  deduplication_scope        = "messageGroup"
  fifo_throughput_limit      = "perMessageGroupId"
  kms_master_key_id          = var.kms_master_key_arn
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 300

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter_fifo.arn
    maxReceiveCount     = 3
  })
}

# Cronjobs Queue
resource "aws_sqs_queue" "cronjobs" {
  name                       = "spacelift-cronjobs"
  kms_master_key_id          = var.kms_master_key_arn
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 300
  message_retention_seconds  = 3600

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter.arn
    maxReceiveCount     = 3
  })
}

# Events Inbox Queue
resource "aws_sqs_queue" "events_inbox" {
  name                       = "spacelift-events-inbox"
  kms_master_key_id          = var.kms_master_key_arn
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 300

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter.arn
    maxReceiveCount     = 3
  })
}

# IoT Queue
resource "aws_sqs_queue" "iot" {
  name                       = "spacelift-iot"
  kms_master_key_id          = var.kms_master_key_arn
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 45

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter.arn
    maxReceiveCount     = 3
  })
}

# Webhooks Queue
resource "aws_sqs_queue" "webhooks" {
  name                       = "spacelift-webhooks"
  kms_master_key_id          = var.kms_master_key_arn
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 600

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter.arn
    maxReceiveCount     = 3
  })
}