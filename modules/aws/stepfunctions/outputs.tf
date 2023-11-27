output "sfn_iam_role_name" {
  value = aws_iam_role.step_function.name
}

output "sfn_state_machine_arn" {
  value = aws_sfn_state_machine.step_function.arn
}
