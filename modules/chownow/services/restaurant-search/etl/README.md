# Restaurant Search ETL

### General

* Description: A module for ETL of restaurant data from Hermosa to the restaurant search database.
* Created By: Keith Erickson
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-restaurant-search-etl-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-restaurant-search-etl-app/badge.svg)
![chownow-services-restaurant-search-etl-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-restaurant-search-etl-base/badge.svg)
![chownow-services-restaurant-search-etl-eventbridge](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-restaurant-search-etl-eventbridge/badge.svg)


### Usage

* Terraform:

* Restaurant Search ETL App Example (`restaurant_search_etl_app.tf`):
```hcl
module "restaurant_search_etl_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/etl/app?ref=restaurant-search-etl-app-v2.0.24"
  
  env       = var.env
  env_inst  = var.env_inst
  service   = var.service
  vpc_name  = "nc-dev"
}
```

* Restaurant Search ETL Base Example (`restaurant_search_etl_base.tf`):
```hcl
module "restaurant_search_etl_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/etl/base?ref=restaurant-search-etl-base-v2.0.6"

  env = var.env
}
```

* Restaurant Search Eventbridge Base Example (`restaurant_search_etl_base.tf`):
```hcl
module "restaurant_search_periodic_backfill" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/etl/eventbridge?ref=restaurant-search-etl-eventbridge-v2.0.3"

  env                 = var.env
  vpc_name            = var.vpc_name
  lookback_time_frame = var.lookback_time_frame
  rule_frequency      = var.rule_frequency

  cross_account_identifiers = ["arn:aws:iam::731031120404:root"]
}

```

### Concurrent Dev Deployments
The `restaurant-search-etl-app` module has been set up to support multiple deployments into the dev environment
at one time using the `dev_workspace` variable. This allows multiple engineers to deploy the module in the same environment
at the same time without terraform conflicts.

To do a concurrent deploy:
1. In the `ops` repo create a new workspace by copying the `ops/terraform/environments/dev/us-east-1/services/restaurant-search/etl/app` directory.
   1. Put the copied workspace (`restaurant-search/etl/app`) in the same project directory (`ops/terraform/environments/dev/us-east-1/services/restaurant-search`) with a different  
   name (ie `ops/terraform/environments/dev/us-east-1/services/restaurant-search/cn-20534/etl/app`)
   2. Replace `restaurant-search` with your new workspace name in the `terraform` json:  ```
   terraform {
    backend "s3" {
    bucket = "chownow-terraform-remote-state-v4-dev"
    key    = "dev/us-east-1/services/restaurant-search/cn-20534/etl/app/terraform.tfstate"
    region = "us-east-1"
    }
    }```
2. Update the `dev_workspace` variable in `ops-tf-modules/modules/chownow/services/restaurant-search/etl/app/variables.tf` to your  
  workspace name. (ie `cn-20534`)
3. Run the Jenkins [deploy](https://jenkins.ops.svpn.chownow.com/job/Developer-Infrastructure-Provisioning/job/Terraform%20Beginner/), being sure
  to reference your new workspace in the `Dynamic_Workspace_Path` parameter. (ie `us-east-1/services/restaurant-search/cn-20534/etl/app`)
4. When finished with development tear down the resources from your temporary workspace and delete the workspace from the `ops` repo.

Note: Ideally we would delete the statefile associated with the workspace, but currently engineers do not have access to the
statefile bucket.
