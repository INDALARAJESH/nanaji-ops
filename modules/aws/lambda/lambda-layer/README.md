# Terraform Lambda Layer Module - Basic

## General

* Description: Lambda Layer Module
* Created By: Tim Ho
* Module Dependencies: N/A
* Provider(s): aws
* Terraform Version: 0.14.x

![aws-lambda-lambda-layer](https://github.com/ChowNow/ops-tf-modules/workflows/aws-lambda-lambda-layer/badge.svg)

#### Overview

This module will create a lambda layer.
Similar to lambda/lambda-basic, this module creates an s3 bucket and empty zip archive as a placeholder for the layer source code. The layer function language defaults to python3, with supported runtimes [ "python3.7", "python3.8" ].

#### Terraform

* Basic reference:

```
module "python3_layer" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-layer?ref=aws-lambda-layer-v2.0.0"

  env                   = var.env
  layer_description     = "sample description for new lambda layer"
  layer_name            = "python3_layer"
}

```

* Basic Nodejs reference:

```
module "nodejs_layer" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-layer?ref=aws-lambda-layer-v2.0.0"

  env                       = var.env
  layer_description         = "sample description for new layer"
  layer_name                = "nodejs_layer"
  layer_function_language   = "nodejs"
  layer_compatible_runtimes = [ "nodejs12.x" ]
}

```

### Considerations

The data.aws_lambda_layer_version.layer resource is necessary in order to refresh
terraform state so that the proper layer_arn is served in the module output.
