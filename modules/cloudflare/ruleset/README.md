# Cloudflare Rule Set

### General

* Description: A terraform module that creates a cloudflare rule set
* Created By: Allen Dantes
* Module Dependencies: `none`
* Provider Dependencies: `cloudflare`


### Usage

* Terraform:

```hcl

module "Cloudflare_redirect" {
source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/cloudflare/ruleset?ref=cn-cloudflare-ruleset-v2.0.0"

  env                    = local.env
  env_inst               = var.env_inst
  service                = var.service
  cloudflare_zone_id     = "ajskdhkah12jh1l2jh3123asjdhlasjd"
  cloudflare_name        = " Redirect "
  cloudflare_description = "chownow.com redirect to get.chownow.com"
  cloudflare_kind        = "zone"
  cloudflare_phase       = "http_request_dynamic_redirect"

  rules = [{
    action                = "redirect"
    status_code           = "301"
    target_url_expression = "lower(concat(\"https://\", \"get.chownow.com/Test\"))"
    preserve_query_string = false
    expression            = "(http.request.uri.path matches \"/Test\" and http.host eq \"www.chownow.com\")"
    description           = "www.chownow.com redirect to get.chownow.com"
    enabled               = true
    }
  ]
```

### Initialization

### Terraform

* Run the Cloudflare Rule Set module in `redirect` folder
* Example directory structure:

```
cloudflare/
└── us-east-1
    └── Services
      └── Marketplace
        └── redirect
            ├── provider.tf
            ├── redirect.tf
            └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name          | Description               | Options                        |  Type  | Required?  | Notes |
| :--------------------- | :-------------------------| :------------------------------| :----: | :-------:  | :---- |
| env                    | Environment               | dev, uat, stg, prod            | string |    Yes     | N/A   |
| env_inst               | iteration of environment  | 00, 01, 02, 03                 | string |    Yes     | N/A   |
| service                | Name of service           | eg cloudflare                  | string |    Yes     | N/A   |
| cloudflare_zone_id     | Cloudflare Zone ID        | 7c1askdjalskdj12837            | string |    Yes     | N/A   |
| cloudflare_name        | Cloudflare Name           | eg Redirect                    | string |    Yes     | N/A   |
| cloudflare_description | Cloudflare Description    | eg redirect to get.chownow.com | string |    Yes     | N/A   |
| cloudflare_kind        | Cloudflare Kind           | eg zone                        | string |    Yes     | N/A   |
| cloudflare_phase       | Cloudflare Phase          | http_request_dynamic_redirect  | string |    Yes     | N/A   |
| rules                  | Cloudflare Redirect Rules | []                             | list   |    Yes     | N/A   |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


### References
