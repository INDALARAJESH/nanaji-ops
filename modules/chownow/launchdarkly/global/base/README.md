# ChowNow LaunchDarkly Global Base

### General

* Description: creates global LaunchDarkly resources like roles and teams
* Created By: Ashwin Vaswani
* Module Dependencies:
  * `modules/launchdarkly/role`
* Provider Dependencies:
  * LaunchDarkly (above 2.8.0)
* Terraform Version: `0.14.x`

![cn-ld-global-base](https://github.com/ChowNow/ops-tf-modules/workflows/cn-ld-global-base/badge.svg)

### Usage

* Terraform (basic example):

```hcl
module "ld_global_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/launchdarkly/global/base?ref=cn-ld-global-base-v2.3.2"
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

N/A

#### Outputs

| Variable Name | Description            |  Type  | Notes |
| :------------ | :--------------------- | :----: | :---- |
|               |                        |        |       |

### Lessons Learned

TBD


### References

* [LD Role](../../../launchdarkly/role)
