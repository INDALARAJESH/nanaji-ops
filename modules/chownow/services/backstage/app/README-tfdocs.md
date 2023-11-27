<!-- BEGIN_TF_DOCS -->
# Backstage App Module

### General

* Description: Backstage application
* Created By: Alex Boyd
* Module Dependencies:
* Module Components:
* Providers : `aws`
* Terraform Version: 0.14.x

![cn-services-backstage](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-backstage/badge.svg)

## Usage

* Terraform:

```hcl
module "app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/backstage/app?ref=backstage-service-app-v2.0.1"

  env                     = var.env
  service                 = var.service
  db_instance_identifier  = var.db_instance_identifier
  image_repo              = var.image_repo
  image_tag               = var.image_tag
  alb_access_logs_enabled = var.alb_access_logs_enabled
  vpc_name_prefix         = var.vpc_name_prefix

  # secrets
  db_password_secret_name                = var.db_password_secret_name
  github_catalog_integration_secret_name = var.github_catalog_integration_secret_name
  github_oauth_app_client_id_secret_name = var.github_oauth_app_client_id_secret_name
  github_oauth_app_client_secret_name    = var.github_oauth_app_client_secret_name

  providers = {
    aws = aws
  }
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_access\_logs\_enabled | Enables ALB access logs, and will create an s3 bucket for storing them. | `bool` | `false` | no |
| container\_port | Port the application runs on. | `string` | `"7000"` | no |
| db\_instance\_identifier | Postgres Database ID used to retrieve the hostname to set the POSTGRES\_HOST environment variable in ecs | `string` | n/a | yes |
| db\_password\_secret\_name | AWS Secret Manager {secret-name} to retrieve database password from in /{env}/{service}/{secret-name} format | `string` | `"db_password"` | no |
| dd\_agent\_container\_image\_version | Datadog agent container image version (tag) | `string` | `"7"` | no |
| dd\_trace\_enabled | Enable/disable datadog dd\_trace | `bool` | `true` | no |
| dns\_ttl | TTL on route53 records | `string` | `300` | no |
| domain\_public | public domain name information used for R53 and ALB | `string` | `"svpn.chownow.com"` | no |
| ecs\_service\_desired\_count | desired number of task instances to run | `number` | `1` | no |
| env | the environment name | `string` | `"dev"` | no |
| firelens\_container\_image\_version | firelens container image version (tag) | `string` | `"2.25.1"` | no |
| firelens\_container\_name | firelens container name | `string` | `"log_router"` | no |
| firelens\_container\_ssm\_parameter\_name | firelens container ssm parameter name | `string` | `"/aws/service/aws-for-fluent-bit"` | no |
| firelens\_options\_dd\_host | Host URI of the datadog log endpoint | `string` | `"http-intake.logs.datadoghq.com"` | no |
| github\_catalog\_integration\_secret\_name | AWS Secret Manager {secret-name} to store github integration token used for catalog discovery in /{env}/{service}/{secret-name} format | `string` | `"github_catalog_app"` | no |
| github\_oauth\_app\_client\_id\_secret\_name | AWS Secret Manager {secret-name} to store github oauth app client id used as an authentication provider in /{env}/{service}/{secret-name} format | `string` | `"github_oauth_app_client_id"` | no |
| github\_oauth\_app\_client\_secret\_name | AWS Secret Manager {secret-name} to store github oauth app client secret used as an authentication provider in /{env}/{service}/{secret-name} format | `string` | `"github_oauth_app_client_secret"` | no |
| image\_repo | Image repository URL used to define where to find the image to use in ecs | `string` | n/a | yes |
| image\_tag | Image tag to deploy | `string` | n/a | yes |
| service | the service name | `string` | `"backstage"` | no |
| vpc\_name\_prefix | Name of the vpc the service will on | `string` | `"main"` | no |
| wait\_for\_steady\_state | wait for deployment to be ready | `bool` | `true` | no |



### Lessons Learned

### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->