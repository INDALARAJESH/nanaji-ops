<!-- BEGIN_TF_DOCS -->
# ChowNow Core Base

### General

* Description: a module that includes VPCs and DNS zones
* Created By: Joe Perez
* Module Dependencies: `global-base`, `region-base`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-core-base](https://github.com/ChowNow/ops-tf-modules/workflows/aws-core-base/badge.svg)

## Usage

* Terraform:

```hcl

# Environment without env_inst
# ops>terraform>environments>env>core>base>base.tf`
module "core_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/core/base?ref=cn-aws-core-base-v2.3.4"

  env                  = var.env
  cidr_block_main      = "10.91.0.0/16"
  enable_vpc_nc        = 0
}

# Environment with `env_inst` variable
# ops>terraform>environments>env>core>base>base.tf`
module "core_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/core/base?ref=cn-aws-core-base-v2.3.4"

  env                  = var.env
  env_inst             = var.env_inst
  cidr_block_main      = "10.91.0.0/16"
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | n/a | `list` | ```[ "us-east-1a", "us-east-1b", "us-east-1c" ]``` | no |
| caa\_records | list of CAA records for cloudflare certificate creation | `list` | ```[ "0 iodef \"mailto:security@chownow.com\"", "0 issue \"digicert.com\"", "0 issue \"amazonaws.com\"", "0 issuewild \"amazonaws.com\"", "0 issue \"letsencrypt.org\"", "0 issuewild \"digicert.com\"" ]``` | no |
| cidr\_block\_env | the env VPC's CIDR Block | `string` | `""` | no |
| cidr\_block\_main | the Main VPC's CIDR Block | `string` | `""` | no |
| cidr\_block\_nc | the non-cardholder data VPC's CIDR Block | `string` | `""` | no |
| cidr\_block\_pritunl | The Pritunl VPN VPC's CIDR Block | `string` | `""` | no |
| enable\_vpc\_env | enable/disable env vpc creation | `number` | `0` | no |
| enable\_vpc\_main | enable/disable main vpc creation | `number` | `1` | no |
| enable\_vpc\_nc | enable/disable non-cardholder data VPC creation | `number` | `1` | no |
| enable\_vpc\_pritunl | enable/disable Pritunl VPN VPC creation | `number` | `0` | no |
| enable\_vpce\_aws | enables/disables creation of common AWS Service VPC Endpoints | `number` | `1` | no |
| enable\_vpce\_datadog | enables/disables creation of DataDog VPC Endpoints | `number` | `1` | no |
| env | unique environment/stage name a | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extended\_subnet\_naming | whether extended naming convention is used. qa0x uses extended naming | `bool` | `false` | no |
| extra\_allowed\_subnets\_env | extra subnets to allow access to VPC | `list` | `[]` | no |
| extra\_allowed\_subnets\_main | extra subnets to allow access to VPC | `list` | `[]` | no |
| extra\_allowed\_subnets\_nc | extra subnets to allow access to VPC | `list` | `[]` | no |
| extra\_allowed\_subnets\_pritunl | Extra subnets to allow access to VPC | `list` | `[]` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| private\_subnets\_env | The env VPC's private subnets | `list` | `[]` | no |
| private\_subnets\_main | The Main VPC's private subnets | `list` | `[]` | no |
| private\_subnets\_nc | The non-cardholder data VPC's private subnets | `list` | `[]` | no |
| private\_subnets\_pritunl | The Main VPC's private subnets | `list` | `[]` | no |
| privatelink\_subnets\_main | The Main VPC's privatelink subnets | `list` | `[]` | no |
| privatelink\_subnets\_nc | The non-cardholder data VPC's privatelink subnets | `list` | `[]` | no |
| privatelink\_subnets\_pritunl | The Main VPC's privatelink subnets | `list` | `[]` | no |
| public\_subnets\_env | The env VPC's public subnets | `list` | `[]` | no |
| public\_subnets\_main | The Main VPC's public subnets | `list` | `[]` | no |
| public\_subnets\_nc | The non-cardholder data VPC's public subnets | `list` | `[]` | no |
| public\_subnets\_pritunl | The Pritunl VPN VPC's public subnets | `list` | `[]` | no |
| root\_domain | root domain name | `string` | `"chownow.com"` | no |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| vpc\_name\_prefix\_main | The Main VPC's name prefix, eg. main in main-dev | `string` | `"main"` | no |
| vpc\_name\_prefix\_nc | The non-cardholder data VPC's name prefix, eg. nc in nc-dev | `string` | `"nc"` | no |
| vpc\_name\_prefix\_pritunl | The Pritunl VPN VPC's name prefix, eg. pritunl in pritunl-dev | `string` | `"pritunl"` | no |

## Outputs

| Name | Description |
|------|-------------|
| main\_gateway\_private | "main vpc". output names structured like this for better sorting |
| main\_gateway\_public | n/a |
| main\_rtb\_private | n/a |
| main\_rtb\_public | n/a |
| main\_subnets\_private | n/a |
| main\_subnets\_public | n/a |
| nc\_gateway\_private | "non cardholder" vpc |
| nc\_gateway\_public | n/a |
| nc\_rtb\_private | n/a |
| nc\_rtb\_public | n/a |
| nc\_subnets\_private | n/a |
| nc\_subnets\_public | n/a |

### Lessons Learned

* I could have added both the nameserver forward module and wildcard cert creation to the module, but then I'd have to pass two providers to the core module. In time, I think we might start using multiple providers, but I don't want to complicate things further for the time being [JP]

### References

* [Practical VPC Design](https://medium.com/aws-activate-startup-blog/practical-vpc-design-8412e1a18dcc)

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
