# Tenable

### General

* Description: Tenable connector module to create an IAM role in accounts that don't need the base module, e.g. pde-prod, mgmt, and sb
* Created By: DevOps

![chownow-services-tenable-connector](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-tenable-connector/badge.svg)

### Terraform

```hcl

module "tenable_connector" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/tenable/connector?ref=cn-tenable-connector-v3.0.0"
}
```
