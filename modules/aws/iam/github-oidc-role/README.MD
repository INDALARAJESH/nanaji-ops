# GitHub OIDC Role

## General

* Description: Module that creates an IAM role for GitHub OIDC authenticated GitHub Actions
* Created By: DevOps (#channels-ops)
* Module Dependencies: OIDC Provider (see Notes)
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x (uses `for_each`)

## Usage

```hcl
module "try_github_oidc" {
  source          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/github-oidc-role?ref=github-oidc-role-v2.1.1"

  env                  = var.env
  oidc_provider_arn    = aws_iam_openid_connect_provider.github_oidc.arn
  policy_document      = data.aws_iam_policy_document.my_policy.json
  repository_name      = "example"
  tag_service_family   = "ExampleService"
}
```

Example using [Github Action environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment):

```hcl
module "try_github_oidc" {
  source          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/github-oidc-role?ref=github-oidc-role-v2.1.1"

  env                  = var.env
  iam_role_name_suffix = "dev"
  oidc_provider_arn    = aws_iam_openid_connect_provider.github_oidc.arn
  oidc_subject         = "environment:development"
  policy_document      = data.aws_iam_policy_document.my_policy.json
  repository_name      = "example"
  tag_service_family   = "ExampleService"
}
```

### Example subjectFromWebIdentityToken(s)

These strings are evaluated against the managed role's trust relationship condition.

Repo with refs:
```json
    "responseElements": {
        "provider": "arn:aws:iam::229179723177:oidc-provider/token.actions.githubusercontent.com",
        "subjectFromWebIdentityToken": "repo:ChowNow/chownow-android-demo:ref:refs/heads/main",
        "audience": "sts.amazonaws.com"
    }
```

Environment:

```json
    "responseElements": {
        ...
        "subjectFromWebIdentityToken": "repo:ChowNow/chownow-android-demo:environment:production",
        ...
    }
```

Event type:

```json
    "responseElements": {
        ...
        "subjectFromWebIdentityToken": "repo:ChowNow/chownow-android-demo:pull_request",
        ...
    }
```

## Troubleshooting

To debug failed authorizations you can dig the event out of cloudtrail, set the search field to `Event Name` and look for `AssumeRoleWithWebIdentity` in the concerned aws account.  Common issues include:

1. The repository must grant the GitHub Actions Workflow permissions to get the token, which can be done with:
```yaml
permissions:
  id-token: write
```
(other options exist for managing this setting)

2. The `subjectFromWebIdentityToken` string above must pass an [IAM condition operator](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html). If you omit the `oidc_subject` value, the module falls back to `StringLike` so that the condition can use a wildcard match for "all source branches, all ref types". If an explicit `oidc_subject` is passed, then the condition changes to `StringEquals`. In the future, this wildcard fallback behavior may change.

## Limitations, Scaling

The module currently uses a role-attached [inline policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_iam-quotas.html), which has a character limit.  We must use an IAM Role with this type of authorization, which means that we have two scaling ceilings to think about right now:

1. On the first instance of hitting a policy character limit, rework the module to create/accept Managed Policies, and attach those to the user.
2. When we hit the Managed Policies attachment limit, submit a limit increase request to increase the limit to 20 attached policies.

If we need more than 20 attached policies, it's probably best to totally redesign. :)

# Inputs

| Variable Name        | Description                                                                                                                                                                                                                                                                                               | Options | Type        | Required? |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | ----------- | --------- |
| env                  | unique environment/stage name                                                                                                                                                                                                                                                                             | Any     | String      | Yes       |
| repository_name      | Github repository name, used in resource name interpolations                                                                                                                                                                                                                                              | Any     | String      | Yes       |
| oidc_provider_arn    | AWS ARN for the required openid_connect_provider resource                                                                                                                                                                                                                                                 | ARN     | String      | Yes       |
| policy_document      | JSON of aws_iam_policy_document to allow (defaults to implicit deny all)                                                                                                                                                                                                                                  | Any     | Map[string] | Yes       |
| oidc_subject         | Optional. GitHub OIDC subject to allow.  Defaults to "*", which allows all workflows from the repository. See [this link](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#example-subject-claims) for more details.        | Any     | String      | No        |
| iam_role_name_suffix | Custom suffix used at the end of IAM resource name interpolations after the repository_name. Eg: `service-foo-development` Useful for when multiple IAM resources are created for the same repo in the same AWS account (eg: different resources for a deployment environment vs pushing to an ECR repo). | Any     | String      | No        |
| tag_service_family   | required service family tag for billing purposes                                                                                                                                                                                                                                                          | Any     | String      | Yes       |


# Outputs

| Output Name | Description                                        | Type   |
| ----------- | -------------------------------------------------- | ------ |
| role_name   | IAM role name for use in caller policy attachments | String |

# Notes

## Permissions

You can find an updated list of valid actions and resources at this link: https://docs.aws.amazon.com/service-authorization/latest/reference/reference.html

## Dependencies

This module's resources all depend (loosely) on a configured OpenID Connect Identity Provider existing in the IAM service in the targeted account.

This module must be invoked multiple times to support multiple GitHub repositories, but the oidc provider should only exist once, so it is not included in the module and must be passed in.

A snippet of this resource follows, which should be applicable to any account without modification:
```hcl
resource "aws_iam_openid_connect_provider" "github_oidc" {
    url = "https://token.actions.githubusercontent.com"

    # aka "audiences": https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#adding-the-identity-provider-to-aws
    client_id_list = ["sts.amazonaws.com"]

    # to get this you can use the AWS IAM ui in sandbox:
    # - Identity Providers -> "Add Provider"
    # - set the type to OpenID Connect, paste in the value of "url", above
    # - click "Get Thumbprint"
    thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}
```
You might choose to remove the comments and link to this documentation instead.  If you do, use this markdown anchor link: `https://github.com/ChowNow/ops-tf-modules/tree/master/modules/aws/iam/github-oidc-role#dependencies`
