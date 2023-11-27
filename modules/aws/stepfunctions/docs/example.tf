module "state_machine" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/stepfunctions?ref=aws-stepfunctions-v2.0.0"

  env                = local.env
  name               = var.name
  service            = var.service
  step_function_name = format("%s-%s-sfn-%s", var.name, var.service, local.env)
  step_function_definition = templatefile(format("%s/templates/sfn-definition.asl.json", path.module), {
    SomeVariableUsedInTemplate = module.reference.output
  })
}