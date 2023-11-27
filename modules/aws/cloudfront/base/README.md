# cloudfront/base

This module is intended to be invoked a single time per account, it contains account-wide and global resources that really should only exist a single time, but can have many consumers.

We want to avoid using `terraform_remote_state` data source lookups because they are fragile and cumbersome, so we instead create resources directly in the calling account + region combo. For now, region is almost always us-east-1, but in the future we might need to invest additional complexity into this module to support multi-region resources.

## Usage
This module takes no parameters, and probably should never take any parameters. It's best if we keep it the same everywhere, so that it is an error either everywhere or nowhere.
```hcl
module "cloudfront_base" {
      source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/cloudfront/base?ref=cn-aws-cloudfront-base-v2.0.1"
}
```

# Resources
## Security Headers Response Policy
This used to be a lambda@edge function that was associated (a mixture of static and dynamically) with various cloudfront distributions.  It appends security-related response headers to traffic destined back to clients, for things like cache age, stuff like that.  The exact properties are best referenced in the resource (currently in `cloudfront.tf`)

Pass the id into your cloudfront distribution's [cache behavior](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#cache-behavior-arguments) object as the value to the `response_headers_policy_id` field.

It can be found like this:
```hcl
data "aws_cloudfront_response_headers_policy" "security_headers" {
  name = "chownow-security-headers"
}
```
Usage:
```hcl
response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers.id
```


