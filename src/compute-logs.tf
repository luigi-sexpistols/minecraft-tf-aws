resource "aws_cloudwatch_log_group" "containers" {
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-containers"
  }
}
