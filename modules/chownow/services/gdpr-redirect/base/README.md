# GDPR Redirect

### General

* Description: A module to create a GDPR redirect
* Created By: Sebastien Plisson
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-services-gdpr-redirect-base](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-gdpr-redirect-base/badge.svg)

### Usage

* Terraform:

* GDPR Redirect Base Example (`gdpr_base.tf`):
```hcl
module "gdpr_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/gdpr-redirect/base?ref=cn-gdpr-redirect-base-v2.0.0"

  env = "qa"
  env_inst = "00"
  gpdr_redirect_domains = [
    "admin.qa00.svpn.chownow.com",
    "eat.qa00.svpn.chownow.com",
    "flex.qa00.svpn.chownow.com",
    "ordering.qa00.svpn.chownow.com",
    "api.qa00.svpn.chownow.com",
    "chownow.qa00.svpn.chownow.com",
  ]
}
```

### Initialization

### Terraform

* Example directory structure:
```
├── env_global.tf
├── global
└── us-east-1
    ├── api-gateway
    ├── base
    ├── core
    ├── db
    └── services
        └── gdpr-redirect
            └── base
                ├── env_global.tf -> ../../../env_global.tf
                ├── gdpr_base.tf
                └── provider.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name         | Description                 | Options |  Type  | Required? | Notes |
| :-------------------- | :-------------------------- | :------ | :----: | :-------: | :---- |
| env                   | unique environment name     |         | string |    Yes    | N/A   |
| env_inst              | environment instance number | 1...n   | string |    No     | N/A   |
| gpdr_redirect_domains | list of domains to redirect |         |  list  |    Yes    | N/A   |
| aws_assume_role_name  | aws assume role name        |         | string |    No    | N/A   |

#### Outputs

### Lessons Learned
