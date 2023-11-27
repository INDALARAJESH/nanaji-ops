# AWS global base

### General

* Description: A module that creates the base resources for a ChowNow AWS Account at the global level:
  * Public svpn DNS zone - eg. `{ENV}.svpn.chownow.com`
  * CAA record in public svpn zone for certificate creation
  * Jenkins service account in IAM
  * Github Actions ECR service account in IAM
  * Grafana service account in IAM
  * Hermosa SNS service acount in IAM for Order Events project (temporary)
  * AWS DMS IAM roles and policies for cloudwatch logging
  * Datadog secret creation
* Created By: Joe Perez
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-global-base](https://github.com/ChowNow/ops-tf-modules/workflows/aws-global-base/badge.svg)

### Usage

* Terraform:
`ops>terraform>environments`
```
env
└── global
    └── base
        ├── base.tf
        ├── provider.tf
        └── variables.tf
```

* Global Base (default):

`provider.tf`
```hcl
provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
}

provider "aws" {
  alias = "prod_dns"
  assume_role {
    role_arn     = "arn:aws:iam::PRODAWSACCOUNTNUMBERGOESHERE:role/${var.aws_assume_role_name}"
    session_name = "terraform_prod_dns"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.14.6"
}

```



`base.tf`
```hcl
module "global_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/global/base?ref=cn-aws-global-base-v2.1.19"

  env      = var.env
  env_inst = var.env_inst

}


module "ns_forward" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/ns-forward?ref=aws-r53-ns-forward-v2.0.6"

  providers = {
      aws = aws.prod_dns
  }

  env         = var.env
  env_inst    = var.env_inst
  nameservers = flatten(module.global_base.public_svpn_nameservers)

  depends_on = [ module.global_base ]
}
```

`variables.tf`

```hcl
variable "env" {
  description = "unique environment/stage name"
  default     = "jp" # Short Account Name
}

variable "env_inst" {
  description = "unique environment/stage name"
  default     = ""
}

variable "aws_account_id" {
  description = "AWS Account Number"
  default     = 1234567890 # chownow-SHORTACCOUNTNAME
}

variable "aws_assume_role_name" {
  description = "role assumption for provider settings"
  default     = "OrganizationAccountAccessRole"
}

```


* Global Base (conditional creation without jenkins user and public svpn zone):

`base.tf`
```hcl
module "global_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/global/base?ref=cn-aws-global-base-v2.1.3"

  env                     = "stg"
  enable_user_jenkins     = 0
  enable_zone_svpn_public = 0

}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                  | Description                                            | Options                             |  Type  | Required? | Notes |
| :----------------------------- | :----------------------------------------------------- | :---------------------------------- | :----: | :-------: | :---- |
| env                            | unique environment/stage name                          | sandbox/dev/qa/uat/stg/prod/etc     | string |    Yes    | N/A   |
| env_inst                       | instance of an environment                             | a two digit number, 00, 01, 02, etc | string |    No     | N/A   |
| enable_record_caa              | enables/disables default CAA record                    | 1 or 0 (default: 1)                 |  int   |    No     | N/A   |
| enable_record_caa_chownowcdn   | enables/disables default CAA record for chownow_cdn    | 1 or 0 (default: 1)                 |  int   |    No     | N/A   |
| enable_record_caa_chownowapi   | enables/disables default CAA record for chownow_api    | 1 or 0 (default: 1)                 |  int   |    No     | N/A   |
| enable_user_gha_ecr            | enables/disables github actions ECR user creation      | 1 or 0 (default: 1)                 |  int   |    No     | N/A   |
| enable_user_grafana            | enables/disables grafana user creation                 | 1 or 0 (default: 1)                 |  int   |    No     | N/A   |
| enable_user_hermosa_sns        | enables/disables hermosa sns user creation             | 1 or 0 (default: 0)                 |  int   |    No     | N/A   |
| enable_user_jenkins            | enables/disables jenkins user creation                 | 1 or 0 (default: 1)                 |  int   |    No     | N/A   |
| enable_zone_svpn_public        | enables/disables public svpn zone creation             | 1 or 0 (default : 1)                |  int   |    No     | N/A   |
| enable_zone_chownowcdn         | enables/disables public chownowcdn zone creation       | 1 or 0 (default : 1)                |  int   |    No     | N/A   |
| enable_zone_chownowapi         | enables/disables public chownowapi zone creation       | 1 or 0 (default : 1)                |  int   |    No     | N/A   |
| enable_secret_dd_ops_api       | enables/disables datadog api key creation              | 1 or 0 (default : 1)                |  int   |    No     | N/A   |
| enable_dms_iam                 | enables/disables AWS DMS IAM role creation             | 1 or 0 (default : 1)                |  int   |    No     | N/A   |
| enable_packer_iam              | enables/disables Packer IAM role creation              | 1 or 0 (default : 1)                |  int   |    No     | N/A   |
| enable_terraform_developer_iam | enables/disables terraform developer IAM role creation | 1 or 0 (default : 0)                |  int   |    No     | N/A   |
| enable_secret_github_pat       | enables/disables github frontend key creation          | 1 or 0 (default : 1)                |  int   |    No     | N/A   |
| enable_teleport_iam            | enables/disables teleport User/Role creation           | 1 or 0 (default : 0)                |  int   |    No     | N/A   |



#### Outputs

| Variable Name           | Description                                        | Type  | Notes |
| :---------------------- | :------------------------------------------------- | :---: | :---- |
| public_svpn_nameservers | a list of nameservers for this account's svpn zone | list  | N/A   |

### Lessons Learned

* Using count on a module alters the output format in the same way it does when applying count to a resources. You must specify an index (eg `aws_iam_user.johndoe.0.name`)


### References
