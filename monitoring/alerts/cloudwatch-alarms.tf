# monitoring/alerts/cloudwatch-alarms.tf
resource "aws_cloudwatch_metric_alarm" "pod_cpu_utilization" {
  alarm_name          = "onfinance-pod-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "pod_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm monitors pod CPU utilization"
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]
  
  dimensions = {
    ClusterName = "onfinance-eks"
  }
}

resource "aws_cloudwatch_metric_alarm" "pod_memory_utilization" {
  alarm_name          = "onfinance-pod-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "pod_memory_utilization"
  namespace           = "ContainerInsights"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm monitors pod memory utilization"
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]
  
  dimensions = {
    ClusterName = "onfinance-eks"
  }
}

resource "aws_cloudwatch_metric_alarm" "node_cpu_utilization" {
  alarm_name          = "onfinance-node-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm monitors node CPU utilization"
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]
  
  dimensions = {
    ClusterName = "onfinance-eks"
  }
}