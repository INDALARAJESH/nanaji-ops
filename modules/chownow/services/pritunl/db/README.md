# ChowNow Pritunl Database

### General

* Created By: Joe Perez
* Provider Dependencies: `aws`
* Terraform Version: `0.14.11`

![chownow-service-pritunl-db](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-service-pritunl-db/badge.svg)

## Latest Version
```
git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/pritunl/db?ref=cn-pritunl-db-v2.0.3
```

2.0.0: Initial commit.
2.0.1: Adding keypair and SSH security group
2.0.2: Adding Threatstack configuration


### Pre-Flight

1. You will need to create a Packer AMI for your instance prior to running Terraform in a given AWS account. Failing to do this will result in the AMI not being found. See: https://github.com/ChowNow/ops/tree/master/packer/aws/ec2


## Usage

```bash
$ENV
├── env_global.tf
├── global
└── us-east-1
    └── services
        ├── pritunl
            └── db
                ├── data_source.tf
                ├── db.tf
                ├── env_global.tf -> ../../../env_global.tf
                └── provider.tf
```


* Deploying mongodb:

`data_source`
```hcl
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:NetworkZone"
    values = ["private_base"]
  }
}
```

`db.tf`
```hcl
module "db" {
  source    = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/pritunl/db?ref=cn-pritunl-db-v2.0.3"

  env               = var.env
  mongodb_instances = local.mongodb_instances
  vpc_name          = local.vpc_name
}

```

`variables.tf`
```hcl
locals {
  vpc_name = "nc-${var.env}"

  mongodb_instances = {
    mongodb0 = {
      name          = "pritunl-mongodb0-${var.env}"
      instance_type = "t3.small"
      subnet_id     = data.aws_subnets.private.ids[0]
    }
    mongodb1 = {
      name          = "pritunl-mongodb1-${var.env}"
      instance_type = "t3.small"
      subnet_id     = data.aws_subnets.private.ids[1]
    }
    mongodb2 = {
      name          = "pritunl-mongodb2-${var.env}"
      instance_type = "t3.small"
      subnet_id     = data.aws_subnets.private.ids[2]
    }
  }
}
```

### Configuring cluster

* Connect to each instance via SSM, eg: `aws-vault exec dev -- aws-connect -n pritunl-mongodb0-dev`
* Create keyfile (one instance): `openssl rand -base64 756 | sudo tee /etc/mongod.keyfile`
  * Copy and paste the key to `/etc/mongod.keyfile` on any other instances
* Update permissions (all instances): `sudo chmod 400 /etc/mongod.keyfile`
* Make mongo the owner (all instances): `sudo chown mongod:mongod /etc/mongod.keyfile`
* Adding cluster configuration to `/etc/mongod.conf` (all instances):

```bash
# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1, pritunl-mongodb0.dev.aws.chownow.com  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.


security:
  keyFile: /etc/mongod.keyfile

replication:
  replSetName: pritunl-data
```
**NOTE: CHANGE HOSTNAME TO YOUR SERVICE'S HOSTNAME**

* Restart mongod (all instances): `sudo systemctl restart mongod`

* Connect to local mongo (one instance): `mongosh`
* Initiate replica set only (one instance):

```bash
rs.initiate(
  {
    _id : "pritunl-data",
    members: [
      { _id : 0, host : "pritunl-mongodb0.dev.aws.chownow.com:27017" },
      { _id : 1, host : "pritunl-mongodb1.dev.aws.chownow.com:27017" },
      { _id : 2, host : "pritunl-mongodb2.dev.aws.chownow.com:27017" }
    ]
  }
)
```
**NOTE: CHANGE HOSTNAMES TO YOUR SERVICE'S HOSTNAMES**

* View status of cluster (one instance): `rs.status()`

* Create admin use on `PRIMARY` instance (one instance):

```bash
admin = db.getSiblingDB("admin")

admin.createUser(
  {
    user: "chowadmin",
    pwd: passwordPrompt(), // or cleartext password
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)

```
**NOTE: ADD THESE CREDENTIALS TO 1PASSWORD!**

* Login as `chowadmin` (one instance): `db.getSiblingDB("admin").auth("chowadmin", passwordPrompt())`

* Create cluster admin (one instance):

```bash
db.getSiblingDB("admin").createUser(
  {
    "user" : "devops-engineer",
    "pwd" : passwordPrompt(),     // or cleartext password
    roles: [ { "role" : "clusterAdmin", "db" : "admin" } ]
  }
)
```
**NOTE: ADD THESE CREDENTIALS TO 1PASSWORD!**


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                        | Options                             |  Type  | Required? | Notes |
| :------------ | :--------------------------------- | :---------------------------------- | :----: | :-------: | :---- |
| env           | unique environment/stage name      | sandbox/dev/qa/uat/stg/prod/etc     | string |    Yes    | N/A   |
| env_inst      | instance of an environment         | a two digit number, 00, 01, 02, etc | string |    No     | N/A   |
| service       | name of service                    | default: pritunl                    | string |    No     | N/A   |
| vpc_name      | name of vpc for resource placement |                                     | string |    Yes    | N/A   |


#### Outputs

| Variable Name                             | Description                            | Type  | Notes |
| :---------------------------------------- | :------------------------------------- | :---: | :---- |

### Lessons Learned

*

### References
* [Deploy Replica Set with Keyfile Authentication](https://www.mongodb.com/docs/manual/tutorial/deploy-replica-set-with-keyfile-access-control/#std-label-deploy-repl-set-with-auth)
