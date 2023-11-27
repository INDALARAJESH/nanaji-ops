## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.core_base_callers](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | environment id. must always exist, must be a member of local.envs, used to filter outputs for the caller.  possible valid values are: dev, qa, stg, uat, ncp | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_main_gateway_private"></a> [main\_gateway\_private](#output\_main\_gateway\_private) | [string] private connectivity default route gateway id. Usually a nat gateway. |
| <a name="output_main_gateway_public"></a> [main\_gateway\_public](#output\_main\_gateway\_public) | [string] public connectivity default route gateway id. Usually an internet gateway. |
| <a name="output_main_private_subnet_ids"></a> [main\_private\_subnet\_ids](#output\_main\_private\_subnet\_ids) | [list<string>] subnet ids that provide private infrastructure for the main vpc. |
| <a name="output_main_public_subnet_ids"></a> [main\_public\_subnet\_ids](#output\_main\_public\_subnet\_ids) | [list<string>] subnet ids that provide public infrastructure for the main vpc. |
| <a name="output_main_rtb_private"></a> [main\_rtb\_private](#output\_main\_rtb\_private) | [string] route table id for main vpc private subnets. |
| <a name="output_main_rtb_public"></a> [main\_rtb\_public](#output\_main\_rtb\_public) | [string] route table id for main vpc public subnets. |
| <a name="output_nc_gateway_private"></a> [nc\_gateway\_private](#output\_nc\_gateway\_private) | [string] private connectivity default route gateway id. Usually a nat gateway. |
| <a name="output_nc_gateway_public"></a> [nc\_gateway\_public](#output\_nc\_gateway\_public) | [string] public connectivity default route gateway id. Usually an internet gateway. |
| <a name="output_nc_private_subnet_ids"></a> [nc\_private\_subnet\_ids](#output\_nc\_private\_subnet\_ids) | [list<string>] subnet ids that provide private infrastructure for the non-cardholder vpc. |
| <a name="output_nc_public_subnet_ids"></a> [nc\_public\_subnet\_ids](#output\_nc\_public\_subnet\_ids) | [list<string>] subnet ids that provide public infrastructure for the non-cardholder vpc. |
| <a name="output_nc_rtb_private"></a> [nc\_rtb\_private](#output\_nc\_rtb\_private) | [string] route table id for non-cardholder vpc private subnets. |
| <a name="output_nc_rtb_public"></a> [nc\_rtb\_public](#output\_nc\_rtb\_public) | [string] route table id for non-cardholder vpc public subnets. |
