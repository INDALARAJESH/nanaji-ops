### General

* Description: A module to create a cloudfront function
* Created By: Allen Dantes
* Module Dependencies: `None`

![aws-cloudfront-function](https://github.com/ChowNow/ops-tf-modules/workflows/aws-cloudfront-function/badge.svg)

### Usage

```hcl

module "sample_cloudfront_function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/cloudfront/function/app-marketplace-origin-router?ref=cloudfront-function-v2.0.0"
  env = var.env
}

```


#### Inputs

| Variable Name                   | Description                                | Options                            |  Type   | Required? | Notes        |
| ------------------------------- | ------------------------------------------ | ---------------------------------- | ------- | --------- | ------------ |
| service                         | Name of service                            | N/A                                | string  | Yes       | N/A          |
| env                             | environment/stage                          | uat, qa, qa00, stg, prod           | string  | Yes       | N/A          |
| env_inst                        | environment instance                       | 00, 01, 02                         | string  | No        | N/A          |
| function_runtime                | Cloudfront Function Runtime                | default: `cloudfront-js-1.0`       | string  | Yes       | N/A          |
| function_publish                | Publish Cloudfront Function                | default: true                      | boolean | No        | N/A          |
| file_path                       | Path for Javascript File                   | NO_ARTIFACT, S3, or CODEPIPELINE   | string  | Yes       | N/A          |
| function_name                   | Name of Function                           | eg: `index.js`                     | string  | Yes       | N/A          |


#### Outputs



#### Notes
For now the only way to deploy is through terraform modules. Since this feature is so new (July 2021), We currently don't have a way for other engineers to deploy.
