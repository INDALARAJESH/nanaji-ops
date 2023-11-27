module "sherlock_ecr" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/ecr?ref=ecr-v1.0.0"
  env      = "${var.env}"
  env_inst = "${var.env_inst}"
  service  = "${var.service}"
}
