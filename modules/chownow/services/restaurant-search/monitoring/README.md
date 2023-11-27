# Restaurant Search Monitoring

### General

* Description: A module for monitoring of the restaurant search service.
* Created By: Keith Erickson
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-restaurant-search-monitoring-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-restaurant-search-monitoring-base/badge.svg)
![chownow-services-restaurant-search-monitoring-alerts](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-restaurant-search-monitoring-alerts/badge.svg)


### Usage

* Terraform:

* Restaurant Search Monitoring Base Example (`restaurant_search_monitoring_base.tf`):
```hcl
module "restaurant_search_monitoring" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/monitoring/base?ref=restaurant-search-monitoring-base-v2.0.2"
  
  env        = var.env
  env_inst   = var.env_inst
}
```

* Restaurant Search Monitoring Alerts Example (`restaurant_search_monitoring_alerts.tf`):
```hcl
module "restaurant_search_monitoring" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/monitoring/alerts?ref=restaurant-search-monitoring-alerts-v2.0.12"
  
  env        = var.env
  env_inst   = var.env_inst
}
```

* Restaurant Search Monitoring Dashboards Example (`restaurant_search_monitoring_dashboard.tf`):
```hcl
module "restaurant_search_monitoring" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/monitoring/alerts?ref=restaurant-search-monitoring-dashboards-v2.0.0"
  
  env        = var.env
  env_inst   = var.env_inst
}
```

### Deploy

Deployment of this module can be done via Jenkins as we now dynamically retrieve the required DataDog connection secrets from AWS. 

Legacy versions of this module did not have this capability. To deploy them through CLI:

* Get DataDog App key from 1Password. It is in the Dev Common Vault and it is named: Chefs Toys DD APP Key
* Get DataDog API key, currently using **Ops - February 2022**, from DataDog: https://app.datadoghq.com/organization-settings/api-keys
* To deploy to DEV run the following commands, from the root monitoring folder, and provide the keys when prompted:
  * `export TF_VAR_aws_assume_role_name='terraform-developer-dev'`
  * `aws-vault exec tf-beginner -- terraform init`
  * This updates with changes to ops-tf-modules, they must be pushed to git:
    * `aws-vault exec tf-beginner -- terraform get -update`  
  * `aws-vault exec tf-beginner -- terraform apply`
