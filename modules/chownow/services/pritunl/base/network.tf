### Elastic IPs for Pritunl hosts

resource "aws_eip" "pritunl_app0" {
  vpc = true

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "pritunl-app0-${local.env}",
    )
  )
}

resource "aws_eip" "pritunl_app1" {
  vpc = true

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "pritunl-app1-${local.env}",
    )
  )
}

### Managed prefix list for Pritunl public IPs

resource "aws_ec2_managed_prefix_list" "pritunl_public_ip_list" {
  name           = "${var.service}-public-ip-list-${local.env}"
  address_family = "IPv4"
  max_entries    = 5

  entry {
    cidr        = "${aws_eip.pritunl_app0.public_ip}/32"
    description = "pritunl-app0-public-ip"
  }

  entry {
    cidr        = "${aws_eip.pritunl_app1.public_ip}/32"
    description = "pritunl-app1-public-ip"
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "${var.service}-public-ip-list-${local.env}",
    )
  )
}

