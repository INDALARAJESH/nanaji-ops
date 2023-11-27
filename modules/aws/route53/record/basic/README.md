# Basic Route53 DNS Record

### General

* Description: Modules that creates basic route53 records
* Created By: Joe Perez
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-r53-record-basic](https://github.com/ChowNow/ops-tf-modules/workflows/aws-r53-record-basic/badge.svg)

### Usage

* Terraform:


* A Record:

```hcl
module "caa_records" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.1"

  name    = "test"
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  type    = "A"
  records = "["1.1.1.1"]"
}

```

* CAA Record:
```hcl
module "caa_records" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.2"

  zone_id = "${data.aws_route53_zone.public.zone_id}"
  type    = "CAA"
  records = "[
      "0 iodef \"mailto:security@chownow.com\"",
      "0 issue \"digicert.com\"",
      "0 issuewild \"amazonaws.com\"",
      "0 issue \"letsencrypt.org\"",
      "0 issuewild \"digicert.com\""
  ]"
}

```

* CNAME Record:

```hcl
module "cname_cloudflare_api" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.2"

  name    = "${var.subdomain_api}.${local.dns_zone}."
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  ttl     = "${var.ttl_api}"
  type    = "CNAME"
  records = ["${var.subdomain_api}.${local.dns_zone}.${var.cloudflare_domain}"]
}
```

* CNAME Record with additional CNAME for GDPR routing:

```hcl
module "cname_cloudflare_facebook" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.2"

  name    = "${var.subdomain_facebook}.${local.dns_zone}."
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  ttl     = "${var.ttl_facebook}"
  type    = "CNAME"
  records = ["${var.subdomain_facebook}.${local.dns_zone}.${var.cloudflare_domain}"]

  enable_gdpr_cname = 1
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name     | Description                                                       | Options                                            |  Type  | Required? | Notes                                            |
| :---------------- | :---------------------------------------------------------------- | :------------------------------------------------- | :----: | :-------: | :----------------------------------------------- |
| enable_gdpr_cname | way to enable/disable gdpr cname creation                         | 1 or 0 (default: 0)                                |  int   |    No     | N/A                                              |
| enable_record     | way to enable/disable record when it's embedded in another module | 1 or 0 (default: 1)                                |  int   |    No     | N/A                                              |
| gdpr_destination  | Cloudfront distribution destination value for GDPR cname          | (default: "d19qcrio9y8d0j.cloudfront.net")         | string |    No     | N/A                                              |
| geo_country       | geographic routing policy country                                 | 2 letter country code (default: *)                 | string |    No     | `*` represents the "default" policy for a record |
| geo_identifier    | geographic routing policy unique identifier                       | (default:"Default")                                | string |    No     | N/A                                              |
| name              | Route53 record name                                               |                                                    | string |    No     | N/A                                              |
| records           | Route53 records                                                   | depends on the record type                         |  list  |    Yes    | N/A                                              |
| ttl               | record ttl                                                        | in seconds (default: 300)                          | string |    No     | N/A                                              |
| type              | record type                                                       | A, CAA, CNAME, MX, PTR, SPF, SRV, TXT (default: A) | string |    No     | N/A                                              |
| zone_id           | Route53 Zone ID for record placement                              | a VPC ID                                           | string |    Yes    | N/A                                              |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |

### Lessons Learned

* When setting a default geographic routing policy on a Route53 record, you must set the type to country and value to `*`. You can alternatively set the location type to `continent` and set a value like `EU`, but that option is currently available in this module

### References
