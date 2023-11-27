##################
# Scan Resources #
##################

resource "aws_ssm_patch_group" "amazonlinux2" {
  baseline_id = data.aws_ssm_patch_baseline.amazonlinux2.id
  patch_group = local.name
}


resource "aws_ssm_maintenance_window" "scan_amazonlinux2" {
  name              = "scan-${local.name}"
  schedule          = var.patch_manager_scan_schedule
  schedule_timezone = "America/Los_Angeles"
  duration          = 6
  cutoff            = 1

  # tags = merge(local.common_tags, { "Name" = "scan-${local.name}" })
}

resource "aws_ssm_maintenance_window_target" "scan_amazonlinux2" {
  name          = "scan-${local.name}"
  window_id     = aws_ssm_maintenance_window.scan_amazonlinux2.id
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Environment"
    values = local.target_values
  }
}

resource "aws_ssm_maintenance_window_task" "scan_amazonlinux2" {
  name            = "scan-${local.name}"
  max_concurrency = 10
  max_errors      = 0
  priority        = 1
  task_arn        = "AWS-RunPatchBaseline"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.scan_amazonlinux2.id


  targets {
    key    = "WindowTargetIds"
    values = aws_ssm_maintenance_window_target.scan_amazonlinux2.*.id
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Scan"]
      }
      parameter {
        name   = "RebootOption"
        values = ["NoReboot"]
      }

      notification_config {
        notification_arn    = aws_sns_topic.pm_status.arn
        notification_events = ["Failed"]
        notification_type   = "Invocation"
      }
      service_role_arn = aws_iam_role.service.arn
    }
  }
}




###################
# Patch Resources #
###################

resource "aws_ssm_maintenance_window" "patch_amazonlinux2" {
  name              = "patch-${local.name}"
  schedule          = var.patch_manager_patch_schedule
  schedule_timezone = "America/Los_Angeles"
  duration          = 3
  cutoff            = 1

  # tags = merge(local.common_tags, { "Name" = "patch-${local.name}" })
}

resource "aws_ssm_maintenance_window_target" "patch_amazonlinux2" {
  name          = "patch-${local.name}"
  window_id     = aws_ssm_maintenance_window.patch_amazonlinux2.id
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Environment"
    values = local.target_values
  }
}

resource "aws_ssm_maintenance_window_task" "patch_amazonlinux2" {
  name            = "patch-${local.name}"
  max_concurrency = 10
  max_errors      = 0
  priority        = 1
  task_arn        = "AWS-RunPatchBaseline"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.patch_amazonlinux2.id


  targets {
    key    = "WindowTargetIds"
    values = aws_ssm_maintenance_window_target.patch_amazonlinux2.*.id
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Install"]
      }
      parameter {
        name   = "RebootOption"
        values = ["NoReboot"]
      }

      notification_config {
        notification_arn    = aws_sns_topic.pm_status.arn
        notification_events = ["Failed"]
        notification_type   = "Invocation"
      }
      service_role_arn = aws_iam_role.service.arn
    }
  }
}
