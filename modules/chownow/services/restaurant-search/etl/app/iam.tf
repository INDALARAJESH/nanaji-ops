##########  IAM FOR OPENSEARCH  ##########

resource "aws_iam_policy" "etl_es_policy" {
  name        = "${var.service}-es_policy-${local.env}"
  description = "Policy to OpenSearch"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${var.env}*/restaurant-search/es_*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["es:ES*"]
        Resource = "arn:aws:es:${local.aws_region}:${local.aws_account_id}:domain/restaurant-search-${local.env}"
      }
    ]
  })
}


##########  IAM FOR STEP FUNCTION  ##########

resource "aws_iam_role" "etl_state_machine_role" {
  name        = "${var.service}-${local.env}-state-machine-role"
  description = "Role for etl state machine"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = [
            "states.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "aws_managed_step_function_policy_attachment" {
  role       = aws_iam_role.etl_state_machine_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
}

resource "aws_iam_policy" "etl_state_machine_lambda_policy" {
  name        = "${var.service}-step-function_policy-${local.env}"
  description = "Policy to give restaurant search ETL step function specific functionality"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:InvokeFunction"
        Resource = "arn:aws:lambda:${local.aws_region}:${local.aws_account_id}:function:${var.service}-*"
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage"
        ]
        Resource = "arn:aws:sqs:${local.aws_region}:${local.aws_account_id}:${var.service}*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "etl_state_machine_lambda_policy_attachment" {
  role       = aws_iam_role.etl_state_machine_role.name
  policy_arn = aws_iam_policy.etl_state_machine_lambda_policy.arn
}


##########  IAM FOR KICKOFF LAMBDA  ##########

resource "aws_iam_policy" "etl_kickoff_lambda_policy" {
  name        = "${var.etl_kickoff_name}_policy-${local.env}"
  path        = "/lambda_policies/${var.service}/"
  description = "Policy to give ${var.etl_kickoff_name} specific functionality"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          "${local.dd_api_key_arn}*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage",
          "sqs:SendMessage"
        ]
        Resource = "arn:aws:sqs:${local.aws_region}:${local.aws_account_id}:${var.service}*"
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ListQueues"
        ]
        Resource = "arn:aws:sqs:${local.aws_region}:${local.aws_account_id}:*"
      },
      {
        Effect = "Allow"
        Action = [
          "states:StartExecution"
        ]
        Resource = "arn:aws:states:${local.aws_region}:${local.aws_account_id}:stateMachine:${var.service}-${local.env}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "etl_kickoff_lambda_policy_attachment" {
  role       = module.restaurant_search_etl_kickoff_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.etl_kickoff_lambda_policy.arn
}


##########  IAM FOR FETCH LAMBDA  ##########

resource "aws_iam_policy" "etl_fetch_lambda_policy" {
  name        = "${var.etl_fetch_name}_policy-${local.env}"
  path        = "/lambda_policies/${var.service}/"
  description = "Policy to give ${var.etl_fetch_name} specific functionality"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${var.env}*/${var.service}/replica_db_*",
          "${local.dd_api_key_arn}*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "states:*"
        ]
        Resource = "arn:aws:states:${local.aws_region}:${local.aws_account_id}:stateMachine:${var.service}-${local.env}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "etl_fetch_lambda_policy_attachment" {
  role       = module.restaurant_search_etl_fetch_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.etl_fetch_lambda_policy.arn
}


##########  IAM FOR DELETE LAMBDA  ##########

resource "aws_iam_policy" "etl_delete_lambda_policy" {
  name        = "${var.etl_delete_name}_policy-${local.env}"
  path        = "/lambda_policies/${var.service}/"
  description = "Policy to give ${var.etl_delete_name} specific functionality"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          "${local.dd_api_key_arn}*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "states:*"
        ]
        Resource = "arn:aws:states:${local.aws_region}:${local.aws_account_id}:stateMachine:${var.service}-${local.env}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "etl_delete_lambda_policy_attachment" {
  role       = module.restaurant_search_etl_delete_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.etl_delete_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "etl_delete_lambda_es_policy_attachment" {
  role       = module.restaurant_search_etl_delete_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.etl_es_policy.arn
}


##########  IAM FOR INSERT LAMBDA  ##########

resource "aws_iam_policy" "etl_insert_lambda_policy" {
  name        = "${var.etl_insert_name}_policy-${local.env}"
  path        = "/lambda_policies/${var.service}/"
  description = "Policy to give ${var.etl_insert_name} specific functionality"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${var.env}*/${var.service}/replica_db_*",
          "${local.dd_api_key_arn}*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "states:*"
        ]
        Resource = "arn:aws:states:${local.aws_region}:${local.aws_account_id}:stateMachine:${var.service}-${local.env}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "etl_insert_lambda_policy_attachment" {
  role       = module.restaurant_search_etl_insert_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.etl_insert_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "etl_insert_lambda_es_policy_attachment" {
  role       = module.restaurant_search_etl_insert_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.etl_es_policy.arn
}


##########  IAM FOR MANAGE ECS  ##########

data "aws_iam_policy" "managed_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "etl_manage_ecs_execution_policy" {
  source_json = data.aws_iam_policy.managed_role_policy.policy
  statement {
    actions   = ["logs:*LogEvents", "logs:Create*"]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${var.env}*/restaurant-search/*",
      "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${var.env}*/${var.service}/*",
      "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${var.env}*/datadog/*"
    ]
  }
}

data "aws_iam_policy_document" "etl_manage_ecs_task_policy" {
  statement {
    effect  = "Allow"
    actions = ["es:ES*"]
    resources = [
      "arn:aws:es:${local.aws_region}:${local.aws_account_id}:domain/restaurant-search-*"
    ]
  }
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${var.env}*/restaurant-search/*",
      "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${var.env}*/${var.service}/*",
      "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${var.env}*/datadog/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
      "arn:aws:s3:::cn-*-events-firehose-${local.env}",
      "arn:aws:s3:::cn-*-events-firehose-${local.env}/*"
    ]
  }
  statement {
    effect  = "Allow"
    actions = ["sqs:Send*"]
    resources = [
      "arn:aws:sqs:${local.aws_region}:${local.aws_account_id}:restaurant-search-*-events-${local.env}"
    ]
  }
}
