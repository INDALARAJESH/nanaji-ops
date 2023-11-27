output "ec2_instance" { value = aws_instance.jumpbox }
output "security_group" { value = aws_security_group.jumpbox }
output "iam_role" { value = aws_iam_role.jumpbox-ssm }
