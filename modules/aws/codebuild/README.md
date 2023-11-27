### General

* Description: A module to create a CodeBuild project
* Created By: Allen Dantes
* Module Dependencies: `None`

![aws-codebuild](https://github.com/ChowNow/ops-tf-modules/workflows/aws-codebuild/badge.svg)

### Usage

```hcl

module "sample_codebuild" {
  source                      = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/codebuild?ref=codebuild-v2.0.3"
  env                         = var.env
  codebuild_name              = "codebuild-name"
  codebuild_description       = "codebuild-description
  codebuild_github_repository = "https://github.com/ChowNow/codebuild-repo.git"
  codebuild_environment_variables = [
    {
      name  = "env_var_name"
      value = "env_var_value"
    },
    {
      name  = "env_var_name"
      value = "env_var_value"
    }
  ]
}

* Codebuild with additional IAM policy
```hcl

data "aws_iam_policy_document" "read_secretsmanager_secrets" {
  ...
}

module "codebuild_addtl_iam" {
  source                      = "git::git@github.com:ChowNow/ops-tf-modules.git//aws_codebuild_ecs?ref=codebuild_ecs-version"
  env                         = var.env
  codebuild_name              = "codebuild-name"
  codebuild_description       = "codebuild-description
  codebuild_github_repository = "https://github.com/ChowNow/codebuild-repo.git"
  codebuild_environment_variables = [
    {
      name  = "env_var_name"
      value = "env_var_value"
    },
    {
      name  = "env_var_name"
      value = "env_var_value"
    }
  ]
}

resource "aws_iam_role_policy" "addtl" {
  name = "addtl_policy"
  role = module.codebuild_addtl_iam.iam_role_id
  policy = data.aws_iam_policy_document.read_secretsmanager_secrets.json
}
```

#### Inputs

| Variable Name                   | Description                                | Options                            |  Type   | Required? | Notes        |
| ------------------------------- | ------------------------------------------ | ---------------------------------- | ------- | --------- | ------------ |
| service                         | Name of service                            | N/A                                | string  | Yes       | N/A          |
| env                             | environment/stage                          | uat, qa, qa00, stg, prod           | string  | Yes       | N/A          |
| env_inst                        | environment instance                       | 00, 01, 02                         | string  | No        | N/A          |
| codebuild_description           | CodeBuild project description              | N/A                                | string  | Yes       | N/A          |
| codebuild_timeout               | CodeBuild build timeout                    | Default is 5                       | string  | No        | N/A          |
| codebuild_artifact_type         | CodeBuild Artifacts                        | NO_ARTIFACT, S3, or CODEPIPELINE   | string  | No        | N/A          |
| codebuild_artifact_location     | CodeBuild Artifact location (S3 only)      | Default ""                         | string  | No        | N/A          |
| codebuild_compute_type          | CodeBuild Instance Size                    | SMALL, MEDIUM, LARGE, 2XLARGE      | string  | No        | N/A          |
| codebuild_image                 | CodeBuild Image                            | list of security group IDs         | string  | No        | N/A          |
| aux_iam_policy                  | Auxilliary IAM CodeBuild policy            | rendered IAM policy                | string  | No        | N/A          |
| codebuild_environment_variables | CodeBuild environment variables            | N/A                                | list    | No        | N/A          |
| codebuild_source                | Codebuild source                           | GITHUB BITBUCKET S3 etc            | string  | No        | N/A          |
| codebuild_source_location       | Location of source                         | N/A                                | string  | No        | N/A          |
| codebuild_buildspec_path        | Location of buildspec                      | N/A                                | string  | No        | N/A          |
| codebuild_environment_variables | organizational service group for instance  | hermosa, flex, ops, etc            | string  | Yes       | N/A          |
| codebuild_log_retention         | Sets a expiration for codebuild logs       | default is 30 days                 | string  | no        | N/A          |
| custom_name                     | Set a custom name for codebuild project    | N/A                                | string  | no        | N/A          |
| extra_tags                      | extra tags                                 | N/A                                | string  | No        | N/A          |
| tag_managed_by                  | managed by tag                             | name (default: Terraform)          | string  | No        | N/A          |


#### Outputs

none

#### Notes

Please add chownow-svc-codebuild to the github security settings of the working repository to ensure proper connection to the repo when building
privilege_mode must be TRUE to be able to connect to the docker daemon
