### Notes

* After first creation and attachment of the task definition to the ECS service, changes are ignored because task definition updates and deployments are handled separately via jenkins

### Lessons Learned

* Terraform will run pre-validations on resources regardless of _count_ values. This leads to problems when attempting to conditionally create iam policy documents with policy = "" if count = "${var.is_equal_to_0}" else policy = "${var.policy_document}"
  * https://github.com/hashicorp/terraform/issues/20892#issuecomment-478847896

* To replace a web service with minimal downtime, enable `create_before_destroy` give the service custom name with the `custom_ecs_service_name` variable, and set the `wait_for_steady_state` to true. This will create a service with a new name, once terraform is done applying, you can remove the `custom_ecs_service_name` and apply again to get back to the original name. After that you can disable `create_before_destroy` and `wait_for_steady_state`

### References
