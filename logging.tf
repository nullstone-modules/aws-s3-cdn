resource "aws_cloudwatch_log_delivery_destination" "access_logs" {
  name          = "${local.resource_name}-access-logs"
  output_format = "json"
  tags          = local.tags

  delivery_destination_configuration {
    destination_resource_arn = local.log_group_arn
  }
}

resource "aws_cloudwatch_log_delivery_source" "access_logs" {
  name         = "${local.resource_name}-access-logs"
  log_type     = "ACCESS_LOGS"
  resource_arn = aws_cloudfront_distribution.this.arn
  tags         = local.tags
}

resource "aws_cloudwatch_log_delivery" "access_logs" {
  delivery_source_name     = aws_cloudwatch_log_delivery_source.access_logs.name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.access_logs.arn
  tags                     = local.tags
}
