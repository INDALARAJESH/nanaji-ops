# LaunchDarkly Project

### General

* Description: a terraform module to create a LaunchDarkly project and it's environments
* Created By: Ashwin Vaswani
* Module Dependencies:
  * N/A
* Provider Dependencies:
  * LaunchDarkly
* Terraform Version: `0.14.x`

![ld-project](https://github.com/ChowNow/ops-tf-modules/workflows/ld-project/badge.svg)

### Usage

* Terraform (basic example):

```hcl
module "project" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/launchdarkly/project?ref=ld-project-v2.2.0"

  id   = "my-service-name"
  name = "My Service Name"

  envs = [
    {
      id   = "local"
      name = "Local"
    },
    {
      id    = "new-env"
      name  = "New Env"
      color = "EEEEEE"
    },
    {
      id   = "production"
      name = "Production"
    }
  ]
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name              | Description                                    | Options                             |  Type   | Required? | Notes |
| :------------------------- | :--------------------------------------------- | :---------------------------------- | :-----: | :-------: | :---- |
| id        | Unique key for the project in kebabcase (system / service)                   |                                     | string  |    Yes     | N/A   |
| name                        |Name for project (system / service name)                        | eg: stg, production, qa, qa00                   | string  |    Yes    | N/A   |
| envs                   | List of unique environments with required id and names. Optional tags and colors                       | See examples below                     | list(object)  |    Yes     | N/A   |
| tags                      | Additional tags to add on to the project. By default adds terraform.                    |                | string  |    Yes    | N/A   |

Example env object(s):

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

#### Outputs

| Variable Name | Description            |  Type  | Notes |
| :------------ | :--------------------- | :----: | :---- |
|               |                        |        |       |

### Lessons Learned

When attempting to add a new environment, the Terraform state might show that it's attempting to add an environment that might already exist. This is a bug with Terraform, and the environment remains the same. The same behavior is experienced when attempting to remove an existing environment.

Additionally, there might be inconsistencies with the environment color, but this can be ignored as well.


### References

* [Terraform Documentation - Project](https://registry.terraform.io/providers/launchdarkly/launchdarkly/latest/docs/resources/project)
* [How to create a project and environments](https://docs.launchdarkly.com/home/organize/projects)
