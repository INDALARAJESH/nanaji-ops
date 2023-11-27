# ALB Listener Rule

## Bug Warning
```bash
Error: Error modifying LB Listener Rule: ValidationError: Target group stickiness duration must be between 1 and 604800 seconds
	status code: 400, request id: 841f7f70-990c-4855-8338-4ec96cc17795
```

See: https://github.com/hashicorp/terraform-provider-aws/issues/15144

Short summary: Terraform's internal representation of a "default stickiness block" is invalid, meaning if a listener rule was ever created with a non-null stickiness configuration, we can't revert back to "null stickiness configuration", we have to track a valid-but-disabled stickiness block.

Since this is a terraform state issue, not a code issue, we can't easily handle it in HCL and we can't figure out where the issue is currently hiding without examining every individual terraform state file.

To resolve, set your stickiness block to a valid-but-disabled configuration like the following:
```hcl
      stickiness {
        enabled  = false
        duration = 1
      }
```

Note that, sadly, fixing this issue in the module for one caller also propagates the issue to every other caller with the same inputs (since we are setting stickiness to a non-null configuration, which is the cause of the bug).

### General

* Description: A module to create an ALB Listener Rule
* Created By: Joe Perez
* Module Dependencies: `alb-target-group`, `alb-listener`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-alb-listener-rule](https://github.com/ChowNow/ops-tf-modules/workflows/aws-alb-listener-rule/badge.svg)


### Usage

* Listener rule with path pattern:

```hcl
module "admin_listener_rule_admin" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.4"

  env                    = var.env
  listener_arn           = module.admin_hermosa_alb.listener_arn
  listener_rule_priority = 50
  path_pattern_values    = ["/admin*"]
  service                = var.service
  target_group_arns      = [ module.admin_hermosa_tg.tg_arn ]
}
```

* Listener rule with http header values:

```hcl
module "admin_listener_rule_ck" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.4"

  env                    = var.env
  http_header_values     = ["cloudkitchens"]
  listener_arn           = module.admin_hermosa_alb.listener_arn
  listener_rule_priority = 10
  service                = "hermosa"
  target_group_arns      = [ module.admin_hermosa_tg_ck.tg_arn ]

}

```
* Listener rule to redirect:

```hcl
module "admin_listener_rule_redirect" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener-rule?ref=aws-alb-listener-rule-v2.1.4"

  env                       = var.env
  listener_arn              = module.admin_hermosa_alb.listener_arn
  listener_rule_action_type = "redirect"
  listener_rule_priority    = 80
  redirect_path_origin      = ["/"]
  redirect_path_destination = "/admin/login"
  service                   = var.service
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name             | Description                            | Options                          |  Type  | Required? | Notes |
| :------------------------ | :------------------------------------- | :------------------------------- | :----: | :-------: | :---- |
| env                       | unique environment/stage name          |                                  | string |    Yes    | N/A   |
| env_inst                  | iteration of environment               | eg 00,01,02,etc                  | string |    No     | N/A   |
| extra_tags                | optional addition for tags             | default = {}                     |  map   |    No     | N/A   |
| http_header_name          | http header type                       | default="User-Agent"             | string |    No     | N/A   |
| http_header_values        | list of http values for match          | eg "admin.chownow.com", etc      |  list  |    No     | N/A   |
| listener_arn              | ALB Listener ARN                       | ARN                              | string |    Yes    | N/A   |
| listener_rule_priority    | listener rule order                    | 1-100 (lower is higher priority) |  int   |    No     | N/A   |
| path_pattern_values       | list of path patterns values for match | eg. "/", "/test", "/test*"       | string |    No     | N/A   |
| redirect_host             | redirect host value                    | default="#{host}"                | string |    No     | N/A   |
| redirect_path_origin      | origin path for redirect               | eg. "/"                          |  list  |    No     | N/A   |
| redirect_path_destination | destination path for redirect          | eg. "/something/else"            | string |    No     | N/A   |
| redirect_port             | redirect tcp port                      | default="443"                    | string |    No     | N/A   |
| redirect_protocol         | redirect protocol                      | default="HTTPS"                  | string |    No     | N/A   |
| redirect_query            | redirect query value                   | default=""                       | string |    No     | N/A   |
| service                   | service name                           | hermosa, flex, etc               | string |    Yes    | N/A   |
| target_group_arns         | target groups for rule                 |                                  |  list  |    No     | N/A   |
| target_group_weigths      | target group weights  for rule         |                                  |  list  |    No     | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned

* Keep the rules simple/separated for easy management
* Space out the rules via rule priority to allow other rules to fit in between
* Any changes to a listener rule usually requires it to be rebuilt
* Try to make a note above each rule to make it easier to understand when looking at it in terraform

### References
