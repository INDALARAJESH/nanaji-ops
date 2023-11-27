output "ids" {
  value = aws_instance.vm.*.id
}
output "private_ips" {
  value = aws_instance.vm.*.private_ip
}

output "public_ips" {
  value = aws_instance.vm.*.public_ip
}

output "ec2_iam_role_name" {
  value = aws_iam_role.ec2_role.name
}

output "volume_ids" {
  value = aws_instance.vm.*.root_block_device
}
