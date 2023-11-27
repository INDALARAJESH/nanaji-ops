data "aws_iam_policy_document" "es_policy" {
  statement {
    sid = "RSS application user full access"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.es.arn]
    }

    actions = ["es:*"]

    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:domain/${local.domain_name}/*"
    ]
  }

  statement {
    sid = "RSS admin read-only CAT and Task APIs"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.admin_ro.arn]
    }

    actions = ["es:*"]

    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:domain/${local.domain_name}/_cat*",
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:domain/${local.domain_name}/_tasks*"
    ]
  }

  statement {
    sid = "RSS admin read-only Index API"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.admin_ro.arn]
    }

    actions = ["es:ESHttpGet"]

    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:domain/${local.domain_name}/*"
    ]
  }
}

resource "aws_iam_user" "es" {
  name = local.domain_name
  path = "/system/elasticsearch/"
}

resource "aws_iam_access_key" "es" {
  user = aws_iam_user.es.name
}

resource "aws_iam_user" "admin_ro" {
  name = "${local.domain_name}-admin_ro"
  path = "/system/elasticsearch/"
}

resource "aws_iam_access_key" "admin_ro" {
  user = aws_iam_user.admin_ro.name
}
