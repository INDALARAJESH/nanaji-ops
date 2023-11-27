# ALB Listener

### General

* Description: A module to create an ALB Listener
* Created By: Joe Perez
* Module Dependencies: `alb-public` or `alb-private`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-alb-listener](https://github.com/ChowNow/ops-tf-modules/workflows/aws-alb-listener/badge.svg)

### Usage


* Listener with forward to target group:

```hcl
module "web_listener_8443" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener?ref=aws-alb-listener-v2.0.0"

  alb_arn              = module.web_alb.alb_arn
  certificate_arn      = "arn:aws:acm:us-east-1:1234567890:certificate/c10a1dcb-4eba-4450-861d-a1245fgsweaf"
  listener_da_type     = "forward"
  listener_port        = "8443"
  target_group_arn     = module.web_8443_tg.tg_arn
}
```

* Listener with fixed-response to 403:

```hcl
module "web_listener_8443" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener?ref=aws-alb-listener-v2.0.0"

  alb_arn              = module.web_alb.alb_arn
  certificate_arn      = "arn:aws:acm:us-east-1:1234567890:certificate/c10a1dcb-4eba-4450-861d-a1245fgsweaf"
  listener_da_type     = "fixed-response"
}
```

* Listener with HTTP to HTTPS redirect:

```hcl
module "web_listener_80_to_443" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/listener?ref=aws-alb-listener-v2.0.0"

  alb_arn              = module.web_alb.alb_arn
  certificate_arn      = "null"
  listener_da_type     = "redirect"
  listener_port        = "80"
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name             | Description                          | Options                                  | Type   | Required? | Notes |
| :------------------------ | :----------------------------------- | :--------------------------------------- | :----: | :-------: | :---- |
| alb_arn                   | ARN for ALB to attach to             | ARN                                      | string |  Yes      | N/A   |
| certificate_arn           | ARN for certificate to use           | Certificate ARN                          | string |  Yes      | N/A   |
| env                       | unique environment/stage name        |                                          | string |  Yes      | N/A   |
| env_inst                  | iteration of environment             | eg 00,01,02,etc                          | string |  No       | N/A   |
| listener_da_type          | listener default action type         | "forward", "fixed-response", "redirect"  | string |  Yes      | N/A   |
| redirect_host             | redirect host value                  | default=""                               | string |  No       | N/A   |
| redirect_path_destination | destination path for redirect        | eg. "/something/else"                    | string |  No       | N/A   |
| redirect_port             | redirect tcp port                    | default="443"                            | string |  No       | N/A   |
| redirect_protocol         | redirect protocol                    | default="HTTPS"                          | string |  No       | N/A   |
| redirect_query            | redirect query value                 | default=""                               | string |  No       | N/A   |
| service                   | service name                         | hermosa, flex, etc                       | string |  Yes      | N/A   |

#### Outputs

| Variable Name      | Description           | Type    | Notes |
| :----------------- | :-------------------- | :-----: | :---- |
| listener_arn       | ALB listener ARN      | string  | N/A   |
| listener_port      | ALB listener port     | string  | N/A   |
| listener_protocol  | ALB listener protocol | string  | N/A   |


### Lessons Learned

* Dynamically adding target groups in this module can get tricky

### References
