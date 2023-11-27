# React-app stack

This is a module to assemble components needed for ChowNow's React-based frontend apps. Components:

  1. S3 bucket to store the React-based static single page app
  1. Codebuild project to deploy it
  1. Cloudfront distribution to serve it
  1. Route53 record to find it
  1. S3-triggered lambda to cull older builds

![chownow-services-react-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-react-app/badge.svg)

## Important Considerations
Inherent limitations within terraform make it impossible for the module to work as hoped and instead, workarounds are needed which make use the module trickier than most.

### Limitation 1 - data source lookups on lambda don't return a proper version
When using a data source lookup on a lambda, the value for the `version` attribute returns simply as `$LATEST` rather than the actual value. The lambda in question here is for use as lambda@EDGE (adding security headers) and as such, will not accept $LATEST and instead *requires* a numerical value.

WORKAROUND: lambda_function_association must be passed in explicitly.

Reference: https://github.com/hashicorp/terraform-provider-aws/issues/10038

### Limitation 2 - interpolation of resource attributes don't function for codebuild environment variable definitions

For example, you can't create a cloudfront resource, then try to define a codebuild enviornment variable as
```
 environment_variable {
  name = "CF_DISTRIBUTION_ID"
  value =  aws.cloudfront_distribution.me.id
 }
```
You get an error such as
```
https://github.com/hashicorp/terraform-provider-aws/issues/6538
```

WORKAROUND: terraform the service, then update by passing in the actual CF_DISTRIBUTION_ID from the created resource

Reference: https://github.com/hashicorp/terraform-provider-aws/issues/6538 (closed, but did not address the problem with codebuild env vars)
