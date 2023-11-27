# Route53 DNS Zones

### General

* Description: Modules that creates route53 zones
* Created By: Joe Perez
* Module Dependencies: N/A
* Provider Dependencies: `aws`

### Usage

* Terraform:

* Public DNS Zone
```hcl
module "chownow_public_dns_zone" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/route53/zone/public?ref=aws-r53-zone-public-v2.0.0"

  description   = "public dns zone for chownow.com"
  domain_name   = "chownow.com"
}
```

* Private DNS Zone
```hcl
module "chownow_private_dns_zone" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/route53/zone/private?ref=aws-r53-zone-private-v2.0.0"

  description   = "private dns zone for chownow.com"
  domain_name   = "chownow.com"
  vpc_id        = "vpc-06ba0123456789f0a"
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                                                   | Options             |  Type  | Required? | Notes |
| :------------ | :------------------------------------------------------------ | :------------------ | :----: | :-------: | :---- |
| description   | description of DNS zone                                       | anything helpful    | string |    Yes    | N/A   |
| domain        | domain name                                                   | an FQDN             | string |    Yes    | N/A   |
| enable_zone   | allows you to enable/disable zone creation in embedded module | 1 or 0 (default: 1) | string |    No     | N/A   |
| vpc_id        | VPC ID required for private DNS zones                         | a VPC ID            | string | Sometimes | N/A   |

#### Outputs

| Variable Name | Description                 |  Type  | Notes |
| :------------ | :-------------------------- | :----: | :---- |
| zone_id       | zone id of created DNS zone | string | N/A   |

### Lessons Learned

* Combining these into a single module sucks because of the mess that's created when you're trying to output one or the other zone id's when one resource does not exist. Terraform will error out.

### References
