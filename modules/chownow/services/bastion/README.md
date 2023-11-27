# Bastion

### General

* Description: Bastion Terraform Module
* Created By: Jobin Muthalaly
* Module Dependencies: `ec2`
* Provider Dependencies: `aws`

![chownow-services-bastion](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-bastion/badge.svg)

### Usage

* Terraform:

```hcl
module "function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/bastion?ref=bastion-v2.0.0"

  env           = "${var.env}"

}
```

### Initialization

### Terraform

* Run the bastion module in `services` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── bastion
            ├── bastion.tf
            ├── provider.tf
            └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                     | Description                     | Options             |  Type  | Required?/Default | Notes |
| :-------------------------------- | :------------------------------ | :------------------ | :----: | :---------------- | :---- |
| env                               | unique environment/stage name   | dev/qa/prod/stg/uat | string | Yes               | N/A   |
| vpc_name_prefix                   | vpc name prefix                 | ex. main            | string | Yes               | N/A   |
| dns_name_suffix                   | dns name suffix                 | ex. -rp             | string | No / ""           | N/A   |
| service                           | name of app/service             | ex. bastion         | string | No / "bastion"    | N/A   |
| env_inst                          | environment instance            | ex. 01              | string | No / ""           | N/A   |
| domain                            | domain name                     | ex. chownow.com     | string | No / "chownow.com"| N/A   |
| subnet_network_types              | subnet filter value             | ex. public          | string | No / "public"     | N/A   |

