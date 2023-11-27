# Forwarding Nameserver Record

### General

* Description: Modules that creates a forwarding NS record in the production AWS account for the public svpn zone in another account (eg `qa15.svpn.chownow.com`)
* Created By: Joe Perez
* Module Dependencies: `aws-core-base`
* Provider Dependencies: `aws`

### Usage

* Terraform:

`something.tf`
```hcl
module "ns_forward" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/ns-forward?ref=aws-r53-ns-forward-v2.0.1"

  providers = {
      aws = aws.prod_dns
  }
  env         = var.env
  env_inst    = var.env_inst
  nameservers = flatten(module.core_base.public_svpn_nameservers)
}
```
_Note: the `flatten` function is required, otherwise the output renders as a list wrapped in `toList`_

`provider.tf`
```hcl
...
...
...

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
}

provider "aws" {
  alias = "prod_dns"
  assume_role {
    role_arn     = "arn:aws:iam::PRODUCTIONACCOUNTNUMBERGOESHERE:role/${var.aws_assume_role_name}"
    session_name = "terraform_prod_dns"
  }
}

...
...
...
```
_Note: the first/default `aws` provider is for the lower-environment resources that you're creating and the `aws` provider with the `prod_dns` alias will be used to connect to the production AWS account where the public `chownow.com` zone lives._


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                                         | Options                        |  Type  | Required? | Notes |
| :------------ | :-------------------------------------------------- | :----------------------------- | :----: | :-------: | :---- |
| env           | unique environment/stage name                       | sb/dev/qa/uat/stg/ncp/prod/etc | string |    Yes    | N/A   |
| env_inst      | two digit environment instance number               | eg 00,01,02, etc               | string |    No     | N/A   |
| nameservers   | list of name servers from lower environment account |                                |  list  |    Yes    | N/A   |
| domain        | base dns domain                                     | default: chownow.com           | string |    No     | N/A   |
| subdomain     | dns subdomain                                       | default: svpn                  | string |    No     | N/A   |
#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |

### Lessons Learned

* This is our first use of multiple providers
* This could have been consolidated into the core base module by passing two providers to the core base module. This approach felt wrong because then each module and/or resource needed to be assigned a provider

### References
