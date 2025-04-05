# monitoring/alerts/sns-topic.tf
resource "aws_sns_topic" "alarm_topic" {
  name = "onfinance-alarms"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = "alerts@onfinance.example.com"  # Replace with real email
}