#!/bin/bash
ENV=$1
TARGET_DIR=$2
AWS_ACCOUNT_ID=$3

cookiecutter --no-input -o ${TARGET_DIR}/terraform/environments/${ENV}/us-east-1 01-cloudwatch/ environment=${ENV} aws_account_id=${AWS_ACCOUNT_ID}
cookiecutter --no-input -o ${TARGET_DIR}/terraform/environments/${ENV}/global 02-global-dns/ environment=${ENV} aws_account_id=${AWS_ACCOUNT_ID}
cookiecutter --no-input -o ${TARGET_DIR}/terraform/environments/${ENV}/us-east-1 03-acm/ environment=${ENV} aws_account_id=${AWS_ACCOUNT_ID}
cookiecutter --no-input -o ${TARGET_DIR}/terraform/environments/${ENV}/us-east-1/services 04-channels-api/ environment=${ENV} aws_account_id=${AWS_ACCOUNT_ID}
cookiecutter --no-input -o ${TARGET_DIR}/terraform/environments/${ENV}/us-east-1/services 05-facebook-business-integration/ environment=${ENV} aws_account_id=${AWS_ACCOUNT_ID}
