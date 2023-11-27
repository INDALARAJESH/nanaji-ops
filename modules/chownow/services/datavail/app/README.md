# Datavail App Module

### General

* Description: a module that creates the ec2 instance and security group for Datavail's communication
* Created By: Joe Perez
* Module Dependencies:
  * `core-base`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-datavail-app](https://github.com/ChowNow/ops-tf-modules/workflows/cn-datavail-app/badge.svg)


### Usage

### Packer

1. Connect to the VPN
2. In terminal browse to `ops/packer/services/datavail`
3. Run the make command for the environment you wish to deploy into
4. Grab a coffee while packer builds the instance

### Terraform

* Terraform (basic):


`datavail.tf`
```hcl
module "datavail" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/datavail/app?ref=cn-datavail-app-v2.0.3"

    env             = var.env
    custom_vpc_name = var.env
}

output "private_ip" {
    value = module.datavail_app.private_ip
}
```

### Ansible

1. Update `ops/Jenkinsfile/DeployDatavail.groovy` to include new environment
2. Add new `ops/ansible/datavail-ENV.yml` playbook
3. Run [Datavail](https://jenkins.ops.svpn.chownow.com/job/Operations/job/Datavail/) Jenkins job

## Module Options


### Inputs

| Variable Name   | Description                                | Options             | Type   | Required? | Notes |
| --------------- | ------------------------------------------ | ------------------- | ------ | --------- | ----- |
| custom_vpc_name | custom vpc for resource placement          | valid VPC name      | String | No        | N/A   |
| enable_a_record | enables creation of a record in production | 0 or 1 (default: 1) | String | No        | N/A   |
| env             | environment/stage                          | uat, qa, stg, prod  | String | Yes       | N/A   |
| env_inst        | environment instance, eg 01 added to stg01 | 00, 01, 02, etc     | String | No        | N/A   |
| service         | unique service name                        | (default: datavail) | String | No        | N/A   |



### Outputs

| Variable Name | Description                     | Type   | Notes |
| ------------- | ------------------------------- | ------ | ----- |
| private_ip    | private IP of datavail instance | string | N/A   |


### Lessons Learned

* This is the first time we're using packer built images for a service and that took some time to figure out with our existing setup and packer's newer HCL2


### Resources
