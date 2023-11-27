# LaunchDarkly Custom Role

### General

* Description: a terraform module to create a LaunchDarkly custom role
* Created By: Ashwin Vaswani
* Module Dependencies:
  * N/A
* Provider Dependencies:
  * LaunchDarkly
* Terraform Version: `0.14.x`

![ld-role](https://github.com/ChowNow/ops-tf-modules/workflows/ld-role/badge.svg)

### Usage

* Terraform (basic example):

```hcl
module "test-role" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/launchdarkly/role?ref=ld-role-v2.1.0"

  id   = "test-role"
  name = "Test Role"

  policy_statements = [
    {
      effect = "allow"
      resources = ["*"]
      actions = ["*"]
    }
  ]
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name              | Description                                    | Options                             |  Type   | Required? | Notes |
| :------------------------- | :--------------------------------------------- | :---------------------------------- | :-----: | :-------: | :---- |
| id        | Unique key for the role in kebabcase                   |                                     | string  |    Yes     | N/A   |
| name                        |Name for role                         |                 | string  |    Yes    | N/A   |
| description                        |Description for role                         |                 | string  |    No    | N/A   |
| policy_statements                   | List of policy statements with required effect, resources, and actions.                       | See examples below                     | list(object)  |    Yes     | N/A   |

Example env object(s):

```hcl
policy_statements = [
  {
    effect = "allow"
    resources = ["*"]
    actions = ["*"]
  },
  {
    effect = "deny"
    resources = ["proj/*:env/production:flag/*"]
    actions = ["*"]
  }
]
```

#### Outputs

| Variable Name | Description            |  Type  | Notes |
| :------------ | :--------------------- | :----: | :---- |
|               |                        |        |       |

### Lessons Learned

TBD


### References

* [Terraform Documentation - Custom Role](https://registry.terraform.io/providers/launchdarkly/launchdarkly/latest/docs/resources/custom_role)
* [How to create a custom role](https://docs.launchdarkly.com/home/members/custom-roles)
