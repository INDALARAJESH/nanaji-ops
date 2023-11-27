resource "aws_key_pair" "ec2" {
  key_name   = local.key_pair_name
  public_key = local.public_key

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.key_pair_name }
  )
}
