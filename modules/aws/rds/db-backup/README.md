# RDS Automated Backups


### General

* Description: A module to create automated backups for a given RDS database in another region (not compatible with Aurora yet)
* Created By: Joe Perez
* Module Dependencies:
* Provider Dependencies:
  * `aws` >4.0

![aws-rds-db-backup](https://github.com/ChowNow/ops-tf-modules/workflows/aws-rds-db-backup/badge.svg)

### Usage

* Terraform:


`provider.tf`
```hcl
terraform {
  backend "s3" {
    bucket = "chownow-terraform-remote-state-v4-dev"
    key    = "dev/us-west-2/db/backup/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }

  region = "us-west-2"

  default_tags {
    tags = {
      TFWorkspace = format("ops/%s", split("terraform/", path.cwd)[1])
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 0.14.6"
}
```

`db_backup.tf`

```hcl
module "db_backup" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/db-backup?ref=aws-rds-db-backup-v2.0.0"

  env       = var.env
  databases = var.databases

}
```

`variables.tf`

```hcl
variable "databases" {
  default = {
    yakko = {
      arn       = "arn:aws:rds:us-east-1:123456789012:db:yakko-postgres-dev"
      retention = 7
    }
    wakko = {
      arn       = "arn:aws:rds:us-east-1:123456789012:db:wakko-postgres-dev"
      retention = 7
    }
    dot = {
      arn       = "arn:aws:rds:us-east-1:123456789012:db:dot-postgres-dev"
      retention = 7
    }
  }
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume
*
#### Inputs

| Variable Name | Description                                | Options             |  Type  | Required? | Notes |
| :------------ | :----------------------------------------- | :------------------ | :----: | :-------: | :---- |
| databases     | list of database ARNs and retention period |                     |  list  |    Yes    | N/A   |
| env           | unique environment/stage name              |                     | string |    Yes    | N/A   |
| service       | service name                               | default `db-backup` | string |    No     | N/A   |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned

* This currently doesn't work with Aurora, AWS support says that functionality is on the roadmap but there's no delivery date set (08/15/22)
* You will need to point the terraform provider to a different region than your RDS database. I've been told we're standardizing on `us-west-2` ([source](https://chownow.atlassian.net/browse/OPS-3357))
* The source database must have backup retention enabled, or else you'll get an error like this:
```
Error: error starting RDS instance automated backups replication: InvalidDBInstanceState: Source DB instance must have backup retention enabled.
        status code: 400, request id: f663fc63-7b1d-4947-b631-a68565411111111111
```


### References
