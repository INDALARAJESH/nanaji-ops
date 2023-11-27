# Known issue with the "Map_all" task_type: https://github.com/hashicorp/terraform-provider-aws/issues/25095
# It is required to "activate" the flow after it is created: https://github.com/hashicorp/terraform-provider-aws/issues/25085
resource "aws_appflow_flow" "salesforce_flow" {
  name        = "${var.service}-sfdc-${var.sfdc_appflow_subscribed_event_names[count.index]}"
  description = "An AppFlow Flow that sends Salesforce events to an EventBridge Bus"
  count       = length(var.sfdc_appflow_subscribed_event_names) # Create an aws_appflow_flow resource for every subscribed event

  # TODO: Add this, or a separate `null_resource` once the AWS CLI is updated on Jenkins workers in OPS-4750
  #
  # provisioner "local-exec" {
  #   # Activate the flow. This runs after resource creation. TODO: We need to verify whether or not the partner bus and event bus must be connected before this.  noqa
  #   command = "aws appflow start-flow --flow-name ${self.name}"
  # }

  destination_flow_config {
    connector_type = "EventBridge"
    destination_connector_properties {
      event_bridge {
        object = local.sfdc_event_bus_name
      }
    }
  }

  source_flow_config {
    connector_type         = "Salesforce"
    connector_profile_name = local.sfdc_appflow_connector
    source_connector_properties {
      salesforce {
        object                      = var.sfdc_appflow_subscribed_event_names[count.index]
        enable_dynamic_field_update = true
      }
    }
  }

  task {
    source_fields = [""] # We map all fields
    task_type     = "Map_all"
    task_properties = {
      EXCLUDE_SOURCE_FIELDS_LIST = "[]"
    }

    connector_operator {
      salesforce = "NO_OP"
    }
  }

  trigger_config {
    trigger_type = "Event"
  }

  lifecycle {
    ignore_changes = [
      # Ignore changed to the task since the Map_all task results in a mismatch between TF and the
      # resource that gets created in AWS. https://github.com/hashicorp/terraform-provider-aws/issues/25095.
      # There is a similar issue with the destination_flow_config.
      task,
      destination_flow_config
    ]
  }
}
