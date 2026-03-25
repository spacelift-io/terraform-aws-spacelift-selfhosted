data "aws_partition" "current" {}

resource "aws_iam_role" "iot_message_sender" {
  count = var.mqtt_broker_type == "iotcore" ? 1 : 0

  name = "spacelift-iot-${var.region}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "iot.${data.aws_partition.current.dns_suffix}"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "iot_message_sender" {
  count = var.mqtt_broker_type == "iotcore" ? 1 : 0

  name = "allow-iot-sqs-sending"
  role = aws_iam_role.iot_message_sender[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey*"
        ]
        Resource = var.kms_master_key_arn
      },
      {
        Effect   = "Allow"
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.iot.arn
      }
    ]
  })
}

resource "aws_iot_topic_rule" "spacelift" {
  count = var.mqtt_broker_type == "iotcore" ? 1 : 0

  name        = "spacelift"
  enabled     = true
  sql         = "SELECT *, Timestamp() as timestamp, topic(3) as worker_pool_ulid, topic(4) as worker_ulid FROM 'spacelift/writeonly/#'"
  sql_version = "2016-03-23"
  description = "Send all messages published in the spacelift namespace to the ${aws_sqs_queue.iot.name}"

  sqs {
    role_arn   = aws_iam_role.iot_message_sender[0].arn
    queue_url  = aws_sqs_queue.iot.url
    use_base64 = true
  }
}
