resource "aws_iam_role" "github_repo_delegate_role" {
  name               = "github-actions-for-${local.base_iam_role_name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.github_trust_relationship.json
  inline_policy {
    name   = "GithubActionsPolicy"
    policy = var.policy_document
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "github-actions-for-${local.base_iam_role_name_suffix}" }
  )
}

data "aws_iam_policy_document" "github_trust_relationship" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    # see: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#configuring-the-role-and-trust-policy
    # for details on this condition
    # Fallback to wildcard access when oidc_subject is missing
    condition {
      test     = var.oidc_subject == "*" ? "StringLike" : "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["${local.base_repository_sub}:${var.oidc_subject}"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}
