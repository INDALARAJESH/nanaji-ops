data "aws_iam_policy_document" "default_ecr_policy" {
  ### Allows AWS resources (like ECS) to pull
  ### images from this ECR repo
  statement {
    sid    = "ReadOnlyResources"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalOrgPaths"
      values = [
        "o-6uwgjdpwv4/r-8tom/ou-8tom-26i7k69s/ou-8tom-c5zsbv4r/ou-8tom-ag4yk3ih/*" # AWS Principal Org Path for Lower Environments
      ]
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
    ]
  }

  ### Allows Lambda in lower environments to pull images from this repo
  statement {
    sid    = "ReadOnlyLambdaLower"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:sourceArn"
      values = [
        "arn:aws:lambda:${data.aws_region.current.name}:229179723177:function:*", #dev
        "arn:aws:lambda:${data.aws_region.current.name}:731031120404:function:*", #qa
        "arn:aws:lambda:${data.aws_region.current.name}:855766371093:function:*", #pde
        "arn:aws:lambda:${data.aws_region.current.name}:937307470951:function:*", #stg
        "arn:aws:lambda:${data.aws_region.current.name}:851526424910:function:*"  #uat
      ]
    }

    actions = [
      "ecr:BatchGetImage",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
    ]
  }

  ### Allows Jenkins/Terraform service account in lower environments to pull images
  ### from this ecro repo
  statement {
    sid    = "ReadOnlyJenkinsLower"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::937307470951:user/svc_jenkins-stg",
        "arn:aws:iam::937307470951:role/OrganizationAccountAccessRole",
        "arn:aws:iam::855766371093:user/svc_jenkins-pde-stg",
        "arn:aws:iam::229179723177:user/svc_jenkins-dev",
        "arn:aws:iam::855766371093:role/OrganizationAccountAccessRole",
        "arn:aws:iam::851526424910:role/OrganizationAccountAccessRole",
        "arn:aws:iam::851526424910:user/svc_jenkins-uat",
        "arn:aws:iam::731031120404:user/svc_jenkins-qa",
        "arn:aws:iam::229179723177:role/OrganizationAccountAccessRole",
        "arn:aws:iam::731031120404:role/OrganizationAccountAccessRole"
      ]
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings"
    ]
  }

  ### Allows AWS resources (like ECS) in production environments to pull
  ### images from this production ECR repo
  statement {
    sid    = "ReadOnlyResourcesProd"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalOrgPaths"
      values = [
        "o-6uwgjdpwv4/r-8tom/ou-8tom-26i7k69s/ou-8tom-c5zsbv4r/ou-8tom-5ivayf84/*", # AWS Principal Org Path to OPS Environment
        "o-6uwgjdpwv4/r-8tom/ou-8tom-26i7k69s/ou-8tom-c5zsbv4r/ou-8tom-ze9e82me/*", # AWS Principal Org Path to PDE Environment
        "o-6uwgjdpwv4/r-8tom/ou-8tom-26i7k69s/ou-8tom-c5zsbv4r/ou-8tom-ns798oh7/*"  # AWS Principal Org Path to Prod/NCP Environment
      ]
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
    ]
  }

  ### Allows Lambda in production environments to pull images from production
  ### ECR repos
  statement {
    sid    = "ReadOnlyLambdaProd"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:sourceArn"
      values = [
        "arn:aws:lambda:${data.aws_region.current.name}:475330587555:function:*", #data
        "arn:aws:lambda:${data.aws_region.current.name}:449190145484:function:*", #ops
        "arn:aws:lambda:${data.aws_region.current.name}:595631937550:function:*", #ncp
        "arn:aws:lambda:${data.aws_region.current.name}:234359455876:function:*"  #prod
      ]
    }

    actions = [
      "ecr:BatchGetImage",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
    ]
  }

  ### Allows Jenkins/Terraform service accounts in production environments to pull images
  ### from production ECR repos
  statement {
    sid    = "ReadOnlyJenkinsProd"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::475330587555:user/svc_jenkins-data",
        "arn:aws:iam::449190145484:user/svc_jenkins-ops",
        "arn:aws:iam::595631937550:user/svc_jenkins-ncp",
        "arn:aws:iam::855766371093:user/svc_jenkins-pde-prod",
        "arn:aws:iam::234359455876:user/svc_jenkins-prod",
        "arn:aws:iam::475330587555:role/OrganizationAccountAccessRole",
        "arn:aws:iam::449190145484:role/OrganizationAccountAccessRole",
        "arn:aws:iam::595631937550:role/OrganizationAccountAccessRole",
        "arn:aws:iam::855766371093:role/OrganizationAccountAccessRole",
        "arn:aws:iam::234359455876:role/OrganizationAccountAccessRole",
      ]
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings"
    ]
  }
}
