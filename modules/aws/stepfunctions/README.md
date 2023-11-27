# Step Functions

### General

* Description: A module to create a step functions state machine
* Created By: Tim Ho
* Module Dependencies: N/A

### Usage

* Terraform:
```hcl
module "state_machine" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/stepfunctions?ref=aws-stepfunctions-v1.0.0"

  env                      = "${var.env}"
  service                  = "${var.service}"
  step_function_name       = "${var.service}_state_machine_${var.env}"
  step_function_definition = "${data.template_file.stepfunction_definition.rendered}"
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name             | Description                                 | Options                     | Type     | Required? | Notes |
| :------------------------ | :------------------------------------------ | :-------------------------- | :------: | :-------: | :---- |
| env                       | unique environment/stage name               |                             | string   |  Yes      | N/A   |
| service                   | service name                                | hermosa, flex, etc          | string   |  Yes      | N/A   |
| step_function_name        | step function name                          |                             | string   |  Yes      | N/A   |
| step_function_definition  | json-formatted step function definition     | valid json str              | string   |  Yes      | N/A   |

#### Outputs

| Variable Name          | Description                   | Type    | Notes |
| :--------------------- | :---------------------------- | :-----: | :---- |
| sfn_iam_role_name      | state machine iam role name   | string  | N/A   |
| sfn_state_machine_arn  | state machine arn             | string  | N/A   |

### Lessons Learned


### References
