- [Context](#context)
- [Latest Version](#latest-version)
- [Usage](#usage)
  - [Examples](#examples)
  - [Requirements](#requirements)
- [Structure](#structure)
  - [variables.tf](#variablestf)
  - [<base_module_name>.tf](#base_module_nametf)
- [FAQ](#faq)
  - [Why isn't this in readme.md?](#why-isnt-this-in-readmemd)
  - [How do I add a new collection of data to this module?](#how-do-i-add-a-new-collection-of-data-to-this-module)
  - [How do I write inline documentation for data exported by this module?](#how-do-i-write-inline-documentation-for-data-exported-by-this-module)
  - [Can I use this in cross-account, cross-provider scenarios?](#can-i-use-this-in-cross-account-cross-provider-scenarios)
- [Troubleshooting](#troubleshooting)
  - [Error: Unsupported attribute](#error-unsupported-attribute)

## Context
This module is our first attempt at a Terraform infrastructure pattern that is influenced
heavily by some recent additions to the Terraform documentation.

It is a [data only module](https://www.terraform.io/language/modules/develop/composition#data-only-modules). Its purpose will be to encapsulate data from every invocation of certain "base resource" types of infrastructure, generally, infrastructure that has way more outbound couplings or is "depended-on" by more things than it, itself, depends on.

Currently this includes the following modules:

- `modules/chownow/aws/core/base`

## Latest Version
```
git::git@github.com:ChowNow/ops-tf-modules.git//modules/data?ref=v2.0.0
```
Initial commit, supports core_base only and exports generic networking data.

## Usage

1. Invoke the module in your caller state at a given version.
2. Pass an environment string (e.g. `stg`, `qa03`) to direct the module at an environment.
2. Refer to outputs of it in your caller. Autocomplete and IntelliSsense are supported so long as you use the [Terraform Language Server](https://github.com/hashicorp/terraform-ls) in your IDE.
    - For VS Code, that is [this extension](https://github.com/hashicorp/vscode-terraform#features)

### Examples
```hcl
module "net" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/data?ref=SOME_VERSION"
  env    = "stg"
}

resource "aws_instance" "nc_ec2_instance" {
  # [...]
  subnet_id     = module.net.nc_private_subnet_ids[0]
  # [...]
```

### Requirements

- core_base must be at least `v2.1.5` in the environment you target
- core_base must persist its outputs to state in the environment you target with the following:
```hcl
output "this" { value = module.core_base }
```

## Structure
The following files exist in this module:

### variables.tf
This file contains input variables and the locals block.  Use the locals transform (`xform`) variable to reduce the character count in module lookups, e.g.
```hcl
# bad, way too many characters, starts to word wrap at most reasonable viewport sizes
  value       = try(data.terraform_remote_state.core_base_callers.outputs.this.main_gateway_public, null)

# better, still a lot of stuff going on in here, but that's just HCL in general
  value       = try(local.xform.core_base.main_gateway_private, null)
```

### <base_module_name>.tf
Create a file named after the base module you're exporting data from.  This file should contain your data sources (remote state or otherwise) as well as the outputs from it.

Don't split the data sources into a data sources file -- the data source pertains specifically to the outputs and should not pertain to anything else, so keeping them in the same file increases the [cohesion](https://en.wikipedia.org/wiki/Cohesion_(computer_science)#High_cohesion) of that file.

## FAQ
### Why isn't this in readme.md?
This module could have many dozens of outputs, so many that updating readme.md by hand would make every change a 5-8 point ticket.  This module's readme.md should only be autoconfigured by terraform-docs.

### How do I add a new collection of data to this module?
1. You must thread every desired output back to the `composed module` that Terraform invokes from your root state (in `ops/`), create a new version of each module with this output threading.
2. Every output must, across all threading boundaries, resolve to either a value or an explicit null.  If any output fails to resolve at any level, the root state will throw errors on plan or apply.
3. In the `ops/` repo, add an `outputs.tf` file to each desired environment that invokes the `composed module` that you modified.  Map the entire set of module outputs to an output named `this`.  See the requirements section above for an example.
4. After these outputs are applied in the root state, you can rely on them existing in every invocation of the module that targets this environment.

### How do I write inline documentation for data exported by this module?
The data provided to users comes from the description field of outputs in _this module_.  All other output descriptions (e.g. from composed modules or other hierarchical module relationships) are flattened and lost on invocation and persistence into state.

When you write inline documentation, be sure to include the type, as outputs do not currently have type hints and the difference between a list of string and string is significant.

### Can I use this in cross-account, cross-provider scenarios?
Yes. The data only module is just a deduplication abstraction for lookup patterns.  You can, in a given root state, invoke this module multiple times against multiple environments, in a scenario where you needed to e.g. peer two VPCs that exist in two different accounts:
```hcl
module "qa_data" { env = "qa", source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/data?ref=SOME_VERSION"}
module "pde-stg_data" { env = "pde-stg", source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/data?ref=SOME_VERSION"}

resource "aws_vpc_peering" "source" {
    provider = "aws.qa"
    peer_owner_id = module.pde-stg_data.aws_account_id
    peer_vpc_id = module.pde-stg_data.main_vpc_id
    vpc_id = module.qa_data.main_vpc_id
}

resource "aws_vpc_peering_accepter" "destination" {
    provider = "aws.pde-stg"
    vpc_connection_peering_id = aws_vpc_peering.source.id
}
```

## Troubleshooting
### Error: Unsupported attribute
Or: "this value does not have any attributes"

This happens when Terraform's caller state invokes the data sources in this module and they attempt to return outputs for things that don't exist.  All outputs must either return their value or an explicit null.  This means that every possible conditional path throughout a composed module must be handled at the output boundary.

In general, prefer not including any conditions in module hierarchies (with respects to [this guidance](https://www.terraform.io/language/modules/develop/composition#conditional-creation-of-objects) from hashicorp).

You can handle these scenarios in one of two ways:

In terraform 0.14, use `try()` and return either the value or a null (or a default, if one exists and it would be reasonable to do):
```hcl
value = try(some_output_value, null)
```

In terraform 0.15+ you can use `one()` to return "the first item, or null".  If you use `one()` with a set, the set must contain only one or zero elements, or Terraform will complain.
```hcl
output "instance_ip_address" {
  value = one(aws_instance.example[*].private_ip)
}
```
