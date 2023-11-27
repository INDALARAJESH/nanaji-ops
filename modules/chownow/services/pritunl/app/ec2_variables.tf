locals {

  pritunl_instances = {
    pritunl0 = {
      name          = "pritunl-app0-${local.env}"
      instance_type = "t3.medium"
      subnet_id     = data.aws_subnets.public.ids[0]
    }
    pritunl1 = {
      name          = "pritunl-app1-${local.env}"
      instance_type = "t3.medium"
      subnet_id     = data.aws_subnets.public.ids[1]
    }
  }
}

