resource "aws_iam_role" "execution" {
  name               = "${local.service}-ecs-execution-${local.env}"
  path               = "/${local.env}/${local.service}/"
  assume_role_policy = data.template_file.ecs_role.rendered

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${local.service}-ecs-execution-${local.env}" }
  )
}

resource "aws_iam_policy" "execution" {
  name   = "${local.service}-execution-${local.env}"
  path   = "/${local.env}/${local.service}/"
  policy = var.ecs_execution_iam_policy
}

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.id
  policy_arn = aws_iam_policy.execution.arn
}

resource "aws_iam_role" "app" {
  name               = "${local.service}-ecs-app-role-${local.env}"
  path               = "/${local.env}/${local.service}/"
  assume_role_policy = data.template_file.ecs_role.rendered

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${local.service}-ecs-app-role-${local.env}" }
  )
}

resource "aws_iam_policy" "app" {
  name   = "${local.service}-app-${local.env}"
  path   = "/${local.env}/${local.service}/"
  policy = var.ecs_task_iam_policy
}

resource "aws_iam_role_policy_attachment" "app" {
  role       = aws_iam_role.app.id
  policy_arn = aws_iam_policy.app.arn
}
