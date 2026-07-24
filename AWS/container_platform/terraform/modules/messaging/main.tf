variable "project_name" { type = string }

resource "aws_sns_topic" "events" {
  name = "${var.project_name}-events"
}

resource "aws_sqs_queue" "events_dlq" {
  name = "${var.project_name}-events-dlq"
}

resource "aws_sqs_queue" "events" {
  name = "${var.project_name}-events"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.events_dlq.arn
    maxReceiveCount     = 3
  })
}

resource "aws_sns_topic_subscription" "sqs" {
  topic_arn = aws_sns_topic.events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.events.arn
}

resource "aws_sqs_queue_policy" "allow_sns" {
  queue_url = aws_sqs_queue.events.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "sns.amazonaws.com" }
      Action    = "sqs:SendMessage"
      Resource  = aws_sqs_queue.events.arn
      Condition = { ArnEquals = { "aws:SourceArn" = aws_sns_topic.events.arn } }
    }]
  })
}

output "queue_url" { value = aws_sqs_queue.events.url }
output "topic_arn" { value = aws_sns_topic.events.arn }
