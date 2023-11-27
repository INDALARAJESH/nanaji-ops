# Terraform Lambda Module - Basic - VPC dependencies

## General

* Description: Basic Lambda Module - VPC dependencies
* Created By: Karol Kania
* Terraform Version: 0.14.x

![aws-lambda-basic-vpc-dependencies](https://github.com/ChowNow/ops-tf-modules/workflows/aws-lambda-basic-vpc-dependencies/badge.svg)

The Lambda running within a VPC must have a security group attached. For the moment of writing this module, this was the only requirement -- although the module can be further extended in the future.

Lambda functions by default do not accept any traffic; they are simply invoked via API -- no ingress rules for security groups are necessary.

On the other hand, when associated with an ENI, the Lambda functions running within a VPC can communicate with other services -- the egress rules can be applied.

This module creates a necessary dependency for Lambda when configured to run within a VPC:

- it does not specify any ingress rules (wouldn't be used anyway)
- it specifies a single egress rule to be very universal (allows all outgoing traffic)
- stores the SG id as an output value

The SG id attached to this Lambda function(s) can then be used as an object reference in another SG to allow traffic from.