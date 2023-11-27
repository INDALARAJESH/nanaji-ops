# ChowNow LaunchDarkly Service

### General

* Description: creates LaunchDarkly project with sub-environments as well as roles to scope access control
* Created By: Ashwin Vaswani
* Module Dependencies:
  * `modules/launchdarkly/project`
  * `modules/launchdarkly/role`
* Provider Dependencies:
  * LaunchDarkly
* Terraform Version: `0.14.x`

![cn-ld-service](https://github.com/ChowNow/ops-tf-modules/workflows/cn-ld-service/badge.svg)

### Usage

* Terraform (basic example):

```hcl
module "my_ld_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/launchdarkly/service?ref=cn-ld-service-v2.3.1"

  service_id = "my-ld-service"
  # Optional
  service_name_override = "My Cool Service"

  project_envs = [
    {
      id   = "local"
      name = "Local"
    },
    {
      id   = "dev"
      name = "Development"
    },
    {
      id   = "qa"
      name = "QA"
    },
    {
      id   = "qa00"
      name = "QA00"
    },
    {
      id   = "qa01"
      name = "QA01"
    },
    {
      id   = "qa02"
      name = "QA02"
    },
    {
      id   = "qa03"
      name = "QA03"
    },
    {
      id   = "uat"
      name = "UAT"
    },
    {
      id   = "stg"
      name = "Staging"
    },
    {
      id   = "production"
      name = "Production"
    }
  ]

  # Optional
  job_functions_with_tags = {
    onboarding_engineering = {
      job_function_id = "engineering"
      tag_id          = "onboarding"
    }
    onboarding_product = {
      job_function_id = "product"
      tag_id          = "onboarding"
    }
  }
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name              | Description                                    | Options                             |  Type   | Required? | Notes |
| :------------------------- | :--------------------------------------------- | :---------------------------------- | :-----: | :-------: | :---- |
| service_id        | Unique key for the project in kebabcase (system / service)                   |                                     | string  |    Yes     | N/A   |
| project_envs                   | List of unique environments with required id and names                      | See examples below                     | list(object)  |    Yes     | N/A   |
| service_name_override        | Overridden friendly name for the service                   | By default uses a friendly version of the service_id                                    | string  |    No     | N/A   |
| additional_job_functions_with_tags                      | Additional roles to create with further access control based on tag values                    | See examples below               | object  |    No    | N/A   |

Example project_envs value:

```hcl
envs = [
  {
    id   = "local"
    name = "Local"
  },
  {
    id    = "qa"
    name  = "QA"
    color = "EEEEEE" # Optional. Hex color value in the UI.
  },
  {
    id   = "production"
    name = "Production"
  }
]
```

Example additional_job_functions_with_tags value:

```hcl
additional_job_functions_with_tags = {
  onboarding_engineering = {
    job_function_id = "engineering"
    tag_id          = "onboarding"
  }
  onboarding_product = {
    job_function_id = "product"
    tag_id          = "onboarding"
  }
}
```

#### Outputs

| Variable Name | Description            |  Type  | Notes |
| :------------ | :--------------------- | :----: | :---- |
|               |                        |        |       |

### Lessons Learned

TBD


### References

* [LD Project](../../../launchdarkly/project)
* [LD Role](../../../launchdarkly/role)
