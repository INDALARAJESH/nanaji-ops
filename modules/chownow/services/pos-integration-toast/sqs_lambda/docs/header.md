# Toast POS Service SQS + Lambda Module

### General

* Description: A sub-module to POS toast integration service
* Created By: Abdulwahid Barguzar, and Kareem Shahin
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

### Description

The goal is to implement a reusable module with SQS + Lambda combination, which integrates with different components of POS Integration toast service such as partner & menu sync handler. This module is designed with a flow where SQS queue will be consuming message received and trigger the lambda to process the message in async manner.

To attach additional policies to the lambda, you must utilize the `aws_iam_role_policy_attachment` resource and provide a policy arn and attach it to the lambda's role which is an output of the module (see below).
