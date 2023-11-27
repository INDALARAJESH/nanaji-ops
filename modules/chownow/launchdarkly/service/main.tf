locals {
  default_job_functions = {
    engineering = "Engineering"
    product     = "Product"
  }
  service_name = var.service_name_override != null ? var.service_name_override : title(replace(var.service_id, "-", " "))
}

module "project" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/launchdarkly/project?ref=ld-project-v2.2.0"

  id   = var.service_id
  name = local.service_name

  envs = var.project_envs
}

module "managed_by_role" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/launchdarkly/role?ref=ld-role-v2.1.0"
  for_each = local.default_job_functions

  id          = "${each.key}-owner_${var.service_id}"
  name        = "${title(each.value)} role for ${local.service_name}"
  description = "${title(each.value)} role for ${local.service_name}"

  policy_statements = [
    {
      effect  = "allow"
      actions = ["*"]
      resources = [
        "proj/${var.service_id}:env/*:flag/*;managed_by_${each.key}"
      ]
    },
    {
      effect  = "allow"
      actions = ["*"]
      resources = [
        "proj/${var.service_id}:env/*:segment/*;managed_by_${each.key}"
      ]
    },
    {
      effect  = "allow"
      actions = ["*"]
      resources = [
        "proj/${var.service_id}:metric/*;managed_by_${each.key}"
      ]
    },
    {
      effect  = "allow"
      actions = ["*"]
      resources = [
        "proj/${var.service_id}:env/*:user/*"
      ]
    },
    {
      effect  = "deny"
      actions = ["bypassRequiredApproval"]
      resources = [
        "proj/*:env/*:flag/*"
      ]
    }
  ]
}

module "managed_by_role_with_tag" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/launchdarkly/role?ref=ld-role-v2.1.0"
  for_each = var.additional_job_functions_with_tags

  id          = "${each.value.tag_id}_${each.value.job_function_id}-owner_${var.service_id}"
  name        = "${title(each.value.job_function_id)} ${each.value.tag_id} role for ${local.service_name}"
  description = "${title(each.value.job_function_id)} ${each.value.tag_id} role for ${local.service_name}"

  policy_statements = [
    {
      effect  = "allow"
      actions = ["*"]
      resources = [
        "proj/${var.service_id}:env/*:flag/*;managed_by_${each.value.job_function_id},${each.value.tag_id}"
      ]
    },
    {
      effect  = "allow"
      actions = ["*"]
      resources = [
        "proj/${var.service_id}:env/*:segment/*;managed_by_${each.value.job_function_id},${each.value.tag_id}"
      ]
    },
    {
      effect  = "allow"
      actions = ["*"]
      resources = [
        "proj/${var.service_id}:metric/*;managed_by_${each.value.job_function_id},${each.value.tag_id}"
      ]
    },
    {
      effect  = "allow"
      actions = ["*"]
      resources = [
        "proj/${var.service_id}:env/*:user/*"
      ]
    },
    {
      effect  = "deny"
      actions = ["bypassRequiredApproval"]
      resources = [
        "proj/*:env/*:flag/*"
      ]
    }
  ]
}

resource "launchdarkly_team" "engineers" {
  key         = "${var.service_id}-engineers"
  name        = "${local.service_name} - Engineers"
  description = "Engineering team for ${local.service_name}"

  lifecycle {
    ignore_changes = [member_ids, maintainers, custom_role_keys]
  }
}
