# ECR

### General

* Description: Creates an ECR repo
* Created By: Joe Perez
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-ecr-basic](https://github.com/ChowNow/ops-tf-modules/workflows/aws-ecr-basic/badge.svg)

### Usage

* Terraform with basic ECR repo lifecycle policy:

```hcl
module "ecr" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecr/basic?ref=aws-ecr-basic-v2.0.7"

  env     = var.env
  service = var.service
}
```

* Terraform with custom ECR repo lifecycle policy:

```hcl
module "ecr" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecr/basic?ref=aws-ecr-basic-v2.0.7"

  env     = var.env
  service = var.service

  enable_lifecycle_policy        = 0
  custom_custom_lifecycle_policy = data.template_file.new-ecr-lifecycle-policy.rendered
}
```

* Terraform with custom ECR repo name:

```hcl
module "ecr" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecr/basic?ref=aws-ecr-basic-v2.0.7"

  env     = var.env
  service = var.service

  custom_name = var.service
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                | Description                                | Options                                | Type     | Required? | Notes |
| :--------------------------- | :----------------------------------------- | :------------------------------------- | :------: | :-------: | :---- |
| base_count                   | amount of images to keep                   | numeric value (default: 30)            | int      |  No       | N/A   |
| base_prefix                  | the prefix to match on for rule            | (default: base- and BASE-)             | string   |  No       | N/A   |
| base_rule_priority           | the ERC lifecycle rule priority            | value between 1 and 100 (default: 30)  | int      |  No       | N/A   |
| branch_develop_count         | amount of images to keep                   | numeric value (default: 15)            | int      |  No       | N/A   |
| branch_develop_prefix        | the prefix to match on for rule            | (default: develop- and DEVELOP-)       | string   |  No       | N/A   |
| branch_develop_rule_priority | the ERC lifecycle rule priority            | value between 1 and 100 (default: 50)  | int      |  No       | N/A   |
| branch_staging_count         | amount of images to keep                   | numeric value (default: 15)            | int      |  No       | N/A   |
| branch_staging_prefix        | the prefix to match on for rule            | (default: staging- and STAGING-)       | string   |  No       | N/A   |
| branch_staging_rule_priority | the ERC lifecycle rule priority            | value between 1 and 100 (default: 60)  | int      |  No       | N/A   |
| custom_lifecycle_policy      | user defined ECR lifecycle policy          | rendered template or file              | file     |  No       | N/A   |
| custom_name                  | user defined custom ecr name               | any string                             | string   |  No       | N/A   |
| enable_container_scanning    | enable vulnerability scanning on images    | true/false (default: true)             | boolean  |  No       | N/A   |
| enable_lifecycle_policy      | enables/disables built-in lifecycle policy | 1 or 0 (default: 1)                    | int      |  No       | N/A   |
| env                          | unique environment/stage name              | sandbox/dev/qa/uat/stg/prod/etc        | string   |  Yes      | N/A   |
| feature_count                | amount of images to keep                   | numeric value (default: 30)            | int      |  No       | N/A   |
| feature_prefix               | the prefix to match on for rule            | (default: cn- and CN-)                 | string   |  No       | N/A   |
| feature_rule_priority        | the ERC lifecycle rule priority            | value between 1 and 100 (default: 20)  | int      |  No       | N/A   |
| pr_count                     | amount of images to keep                   | numeric value (default: 30)            | int      |  No       | N/A   |
| pr_prefix                    | the prefix to match on for rule            | (default: pr- and PR-)                 | string   |  No       | N/A   |
| pr_rule_priority             | the ERC lifecycle rule priority            | value between 1 and 100 (default: 40)  | int      |  No       | N/A   |
| repository_policy            | JSON-formatted ECR repo policy             | valid ecr policy (default: "")         | string   |  No       | N/A   |
| semver_count                 | amount of images to keep                   | numeric value (default: 30)            | int      |  No       | N/A   |
| semver_prefix                | the prefix to match on for rule            | (default: v and V)                     | string   |  No       | N/A   |
| semver_rule_priority         | the ERC lifecycle rule priority            | value between 1 and 100 (default: 10)  | int      |  No       | N/A   |
| service                      | name of ECR service                        | eg. dms                                | string   |  Yes      | N/A   |
| untagged_count               | amount of images to keep                   | numeric value (default: 5)             | int      |  No       | N/A   |
| untagged_rule_priority       | the ERC lifecycle rule priority            | value between 1 and 100 (default: 100) | int      |  No       | N/A   |

#### Outputs

| Variable Name      | Description         | Type    | Notes |
| :----------------- | :------------------ | :-----: | :---- |
| repo_url           | ECR Repo URL        | string  |  N/A  |
| repo_arn           | ECR Repo ARN        | string  |  N/A  |

### Lessons Learned

* Lifecycle policies map one to one with ECR repos
* You can add multiple rules to a single lifecyle policy
* When adjusting the lifecycle rule order, you must also adjust the position of the rules. Otherwise terraform will continue to trigger changes.
* Permission policies for cross account image pulling is really complex given our requirements
* The conditional statement in the ECR policy which uses `aws:PrincipalOrgID` as the match is fickle. The other tags to match on like `aws:PrincipalOrgPaths` doesn't work, which blocks ECS from deploying an image from an ECR repo outside of its account

### References

* [Terraform ECR Lifecycle Policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy)
