## IAM

resource "aws_iam_role" "codebuild-role" {
  name               = "${var.service}-codebuild-role-${local.env}"
  assume_role_policy = file("${path.module}/templates/codebuild-role-policy.json.tpl")
  path               = "/${local.env}/${var.service}/"
}

resource "aws_iam_policy" "codebuild-policy" {
  name   = "${var.service}-codebuild-policy-${local.env}"
  path   = "/${local.env}/${var.service}/"
  policy = data.template_file.codebuild-policy-document.rendered
}

resource "aws_iam_role_policy_attachment" "codebuild-attachment" {
  role       = aws_iam_role.codebuild-role.name
  policy_arn = aws_iam_policy.codebuild-policy.arn
}

resource "aws_iam_role_policy" "addtl" {
  count = var.aux_iam_policy != "" ? 1 : 0

  name   = "${var.service}-codebuild-policy-addtl-${local.env}"
  role   = aws_iam_role.codebuild-role.id
  policy = var.aux_iam_policy
}
