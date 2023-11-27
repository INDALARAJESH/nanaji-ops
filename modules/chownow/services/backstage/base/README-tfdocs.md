<!-- BEGIN_TF_DOCS -->
# Backstage Base Module

### General

* Description: Backstage base
* Created By: Alex Boyd
* Module Dependencies:
* Module Components:
* Providers : `aws`
* Terraform Version: 0.14.x

![cn-services-backstage](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-backstage-base/badge.svg)

## Usage

* Terraform:

```hcl
module "base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/backstage/base?ref=backstage-service-base-v2.0.1"

  env                                    = var.env
  service                                = var.service
  github_catalog_integration_secret_name = var.github_catalog_integration_secret_name
  github_oauth_app_client_id_secret_name = var.github_oauth_app_client_id_secret_name
  github_oauth_app_client_secret_name    = var.github_oauth_app_client_secret_name
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | the environment name | `string` | `"dev"` | no |
| github\_catalog\_integration\_secret\_name | AWS Secret Manager {secret-name} to store github integration token used for catalog discovery in /{env}/{service}/{secret-name} format | `string` | `"github_catalog_app"` | no |
| github\_oauth\_app\_client\_id\_secret\_name | AWS Secret Manager {secret-name} to store github oauth app client id used as an authentication provider in /{env}/{service}/{secret-name} format | `string` | `"github_oauth_app_client_id"` | no |
| github\_oauth\_app\_client\_secret\_name | AWS Secret Manager {secret-name} to store github oauth app client secret used as an authentication provider in /{env}/{service}/{secret-name} format | `string` | `"github_oauth_app_client_secret"` | no |
| jenkins\_api\_key\_secret\_name | AWS Secret Manager {secret-name} to store Jenkins api key secret in /{env}/{service}/{secret-name} format | `string` | `"jenkins_api_key_secret"` | no |
| service | the service name | `string` | `"backstage"` | no |



### Lessons Learned

### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->