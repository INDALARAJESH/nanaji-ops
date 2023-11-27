resource "aws_sfn_state_machine" "restaurant_search_etl_state_machine" {
  name       = "${var.service}-${local.env}"
  role_arn   = aws_iam_role.etl_state_machine_role.arn
  definition = <<EOF
{
  "Comment": "Restaurant search ETL process from replica database to search database",
  "StartAt": "WaitForReplicaDBLag",
  "States": {
    "WaitForReplicaDBLag": {
      "Type": "Wait",
      "Seconds": ${var.state_machine_wait_seconds},
      "Next": "Fetch"
    },
    "Fetch": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:${local.aws_region}:${local.aws_account_id}:function:${var.etl_fetch_name}-${local.env}",
      "Next": "ETLAction?",
      "ResultPath": "$.fetch_result",
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException",
            "Lambda.ClientExecutionTimeoutException",
            "Lambda.Unknown",
            "ETLFetchError"
          ],
          "IntervalSeconds": ${var.state_machine_retry_interval_seconds},
          "MaxAttempts": ${var.state_machine_retry_max_attempts},
          "BackoffRate": ${var.state_machine_retry_backoff_rate}
        }
       ],
      "Catch":[
        {
          "ErrorEquals": [
            "ETLFatalError"
          ],
          "Next": "SendToDLQ",
          "ResultPath": "$.error"
        },
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "Next": "SendToDLQ",
          "ResultPath": "$.error"
        }
      ]
    },
    "ETLAction?": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.fetch_result.action",
          "StringEquals": "delete",
          "Next": "Delete"
        },
        {
          "Variable": "$.fetch_result.action",
          "StringEquals": "insert",
          "Next": "Insert"
        }
      ]
    },
    "Delete": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:${local.aws_region}:${local.aws_account_id}:function:${var.etl_delete_name}-${local.env}",
      "End": true,
      "ResultPath": "$.delete_result",
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException",
            "Lambda.ClientExecutionTimeoutException",
            "Lambda.Unknown",
            "ETLDeleteError"
          ],
          "IntervalSeconds": ${var.state_machine_retry_interval_seconds},
          "MaxAttempts": ${var.state_machine_retry_max_attempts},
          "BackoffRate": ${var.state_machine_retry_backoff_rate}
        }
       ],
      "Catch":[
        {
          "ErrorEquals": [
            "ETLFatalError"
          ],
          "Next": "SendToDLQ",
          "ResultPath": "$.error"
        },
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "Next": "SendToDLQ",
          "ResultPath": "$.error"
        }
      ]
    },
    "Insert": {
      "Comment": "Executes Lambda function to index restaurant to search database",
      "Type": "Task",
      "Resource": "arn:aws:lambda:${local.aws_region}:${local.aws_account_id}:function:${var.etl_insert_name}-${local.env}",
      "ResultPath": "$.insert_result",
      "End": true,
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException",
            "Lambda.ClientExecutionTimeoutException",
            "Lambda.Unknown",
            "ETLInsertError"
          ],
          "IntervalSeconds": ${var.state_machine_retry_interval_seconds},
          "MaxAttempts": ${var.state_machine_retry_max_attempts},
          "BackoffRate": ${var.state_machine_retry_backoff_rate}
        }
      ],
      "Catch":[
        {
          "ErrorEquals": [
	    "ETLFatalError"
          ],
          "Next": "SendToDLQ",
          "ResultPath": "$.error"
        },
        {
          "ErrorEquals": [
	    "States.ALL"
	  ],
          "Next": "SendToDLQ",
          "ResultPath": "$.error"
        }
      ]
    },
    "SendToDLQ": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sqs:sendMessage",
      "Parameters": {
        "QueueUrl": "https://sqs.${local.aws_region}.amazonaws.com/${local.aws_account_id}/${var.service}-kickoff-dlq_${local.env}",
        "MessageBody.$": "$"
      },
      "Next": "RestaurantETLFailure"
    },
    "RestaurantETLFailure": {
      "Type": "Fail"
    }
  }
}
EOF
}
