resource "aws_iam_role" "task_execution" {
  assume_role_policy = file("${path.module}/compute/aws_iam_role.task_execution.assume_role_policy.json")
  tags = {
    Name = "${var.project_name}-task-execution"
  }
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  role = aws_iam_role.task_execution.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task" {
  assume_role_policy = file("${path.module}/compute/aws_iam_role.task.assume_role_policy.json")
  tags = {
    Name = "${var.project_name}-task"
  }
}
